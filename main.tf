#####
# Autoscaling Target
#####
resource "aws_appautoscaling_target" "target" {
  count = var.enabled ? 1 : 0

  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
  service_namespace  = "ecs"
}

#####
# Autoscaling Policies
#####
resource "aws_appautoscaling_policy" "scale_up" {
  count = var.enabled ? 1 : 0

  name               = "sqs-scale-up"
  policy_type        = "StepScaling"
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  step_scaling_policy_configuration {
    cooldown                 = var.scale_up_cooldown
    adjustment_type          = var.adjustment_type_up
    metric_aggregation_type  = "Average"
    min_adjustment_magnitude = var.scale_up_min_adjustment_magnitude

    step_adjustment {
      metric_interval_lower_bound = var.scale_up_lower_bound
      metric_interval_upper_bound = var.scale_up_upper_bound
      scaling_adjustment          = var.scale_up_scaling_adjustment
    }
  }

  depends_on = [aws_appautoscaling_target.target]
}

resource "aws_appautoscaling_policy" "scale_down" {
  count = var.enabled ? 1 : 0

  name               = "sqs-scale-down"
  policy_type        = "StepScaling"
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  step_scaling_policy_configuration {
    cooldown                 = var.scale_down_cooldown
    adjustment_type          = var.adjustment_type_down
    metric_aggregation_type  = "Average"
    min_adjustment_magnitude = var.scale_down_min_adjustment_magnitude

    step_adjustment {
      metric_interval_lower_bound = var.scale_down_lower_bound
      metric_interval_upper_bound = var.scale_down_upper_bound
      scaling_adjustment          = var.scale_down_scaling_adjustment
    }
  }

  depends_on = [aws_appautoscaling_target.target]
}

#####
# CloudWatch Alerts
#####

resource "aws_cloudwatch_metric_alarm" "service_queue_high" {
  count = var.enabled ? 1 : 0

  alarm_name          = "${var.name_prefix}-sqs-queue-high"
  alarm_description   = "Alarm monitors SQS Queue count utilization for scaling up"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.high_evaluation_periods
  threshold           = var.high_threshold
  alarm_actions       = [aws_appautoscaling_policy.scale_up[0].arn]

  dynamic "metric_query" {
    for_each = var.metric_query
    content {
      id          = lookup(metric_query.value, "id")
      label       = lookup(metric_query.value, "label", null)
      return_data = lookup(metric_query.value, "return_data", null)
      expression  = lookup(metric_query.value, "expression", null)

      dynamic "metric" {
        for_each = lookup(metric_query.value, "metric", [])
        content {
          metric_name = lookup(metric.value, "metric_name")
          namespace   = lookup(metric.value, "namespace")
          period      = lookup(metric.value, "period")
          stat        = lookup(metric.value, "stat")
          unit        = lookup(metric.value, "unit", null)
          dimensions  = lookup(metric.value, "dimensions", null)
        }
      }
    }
  }

  tags = var.tags

  depends_on = [aws_appautoscaling_policy.scale_up]
}

resource "aws_cloudwatch_metric_alarm" "service_queue_low" {
  count = var.enabled ? 1 : 0

  alarm_name          = "${var.name_prefix}-sqs-queue-low"
  alarm_description   = "Alarm monitors SQS Queue count utilization for scaling down."
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.low_evaluation_periods
  threshold           = var.low_threshold
  alarm_actions       = [aws_appautoscaling_policy.scale_down[0].arn]

  dynamic "metric_query" {
    for_each = var.metric_query
    content {
      id          = lookup(metric_query.value, "id")
      label       = lookup(metric_query.value, "label", null)
      return_data = lookup(metric_query.value, "return_data", null)
      expression  = lookup(metric_query.value, "expression", null)

      dynamic "metric" {
        for_each = lookup(metric_query.value, "metric", [])
        content {
          metric_name = lookup(metric.value, "metric_name")
          namespace   = lookup(metric.value, "namespace")
          period      = lookup(metric.value, "period")
          stat        = lookup(metric.value, "stat")
          unit        = lookup(metric.value, "unit", null)
          dimensions  = lookup(metric.value, "dimensions", null)
        }
      }
    }
  }

  tags = var.tags

  depends_on = [aws_appautoscaling_policy.scale_down]
}
