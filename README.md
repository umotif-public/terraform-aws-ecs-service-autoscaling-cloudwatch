# terraform-aws-ecs-service-autoscaling-cloudwatch

Terraform module to configure ECS Service autoscaling using CloudWatch metrics

## Terraform versions

Terraform 0.12. Pin module version to `~> v2.0`. Submit pull-requests to `master` branch.

## Usage

```hcl
module "ecs-service-autoscaling-cloudwatch" {
  source = "umotif-public/ecs-service-autoscaling-cloudwatch/aws"
  version = "~> 2.0.0"

  enabled = true

  name_prefix = "test-sqs-scalling"

  min_capacity = 1
  max_capacity = 20

  cluster_name = "dev-ecs"
  service_name = "dev-actions"

  scale_up_step_adjustment = [
    {
      scaling_adjustment          = 2
      metric_interval_lower_bound = 0
      metric_interval_upper_bound = "" # indicates inifinity
    }
  ]

  scale_down_step_adjustment = [
    {
      scaling_adjustment          = -4
      metric_interval_upper_bound = 0
      metric_interval_lower_bound = ""
    }
  ]

  metric_query = [
    {
      id = "visible"
      metric = [
        {
          namespace   = "AWS/SQS"
          metric_name = "ApproximateNumberOfMessagesVisible"
          period      = 60
          stat        = "Maximum"

          dimensions = {
            QueueName = "dev-actions-queue-name"
          }
        }
      ]
    }
  ]
}
```

## Assumptions

Module is to be used with Terraform > 0.12.

## Examples

* [ECS Service CloudWatch SQS Autoscaling](https://github.com/umotif-public/terraform-aws-ecs-service-autoscaling-cloudwatch/tree/master/examples/core)

## Authors

Module managed by [Marcin Cuber](https://github.com/marcincuber) [LinkedIn](https://www.linkedin.com/in/marcincuber/).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.6 |
| aws | >= 2.45 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.45 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| adjustment\_type\_down | Autoscaling policy down adjustment type (ExactCapacity, ChangeInCapacity, PercentChangeInCapacity) | `string` | `"ChangeInCapacity"` | no |
| adjustment\_type\_up | Autoscaling policy up adjustment type (ExactCapacity, ChangeInCapacity, PercentChangeInCapacity) | `string` | `"ChangeInCapacity"` | no |
| cluster\_name | Name of ECS cluster that service is in | `string` | n/a | yes |
| enabled | Whether to create the resources. Set to `false` to prevent the module from creating any resources | `bool` | `true` | no |
| high\_evaluation\_periods | The number of periods over which data is compared to the high threshold | `string` | `"1"` | no |
| high\_threshold | The value against which the high statistic is compared | `string` | `"10"` | no |
| low\_evaluation\_periods | The number of periods over which data is compared to the low threshold | `string` | `"1"` | no |
| low\_threshold | The value against which the low statistic is compared | `string` | `"10"` | no |
| max\_capacity | Maximum number of tasks to scale to | `string` | `"5"` | no |
| metric\_query | Enables you to create an alarm based on a metric math expression. You may specify at most 20. | `any` | `[]` | no |
| min\_capacity | Minimum number of tasks to scale to | `string` | `"2"` | no |
| name\_prefix | A prefix used for naming resources. | `string` | n/a | yes |
| scale\_down\_cooldown | The amount of time, in seconds, after a scaling down completes and before the next scaling activity can start | `string` | `"60"` | no |
| scale\_down\_min\_adjustment\_magnitude | Minimum number of tasks to scale down at a time | `string` | `"0"` | no |
| scale\_down\_step\_adjustment | A set of adjustments that manage scaling. Requires at least one object inside the list containing: `metric_interval_lower_bound`, `metric_interval_upper_bound`, `scaling_adjustment`. | `list(object({ metric_interval_lower_bound = string, metric_interval_upper_bound = string, scaling_adjustment = string }))` | `[]` | no |
| scale\_up\_cooldown | The amount of time, in seconds, after a scaling up completes and before the next scaling up can start | `string` | `"60"` | no |
| scale\_up\_min\_adjustment\_magnitude | Minimum number of tasks to scale up at a time | `string` | `"0"` | no |
| scale\_up\_step\_adjustment | A set of adjustments that manage scaling. Requires at least one object inside the list containing: `metric_interval_lower_bound`, `metric_interval_upper_bound`, `scaling_adjustment`. | `list(object({ metric_interval_lower_bound = string, metric_interval_upper_bound = string, scaling_adjustment = string }))` | `[]` | no |
| service\_name | Name of ECS service to autoscale | `string` | n/a | yes |
| tags | A mapping of tags to assign to all resources | `map(string)` | `{}` | no |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

See LICENSE for full details.

## Pre-commit hooks

### Install dependencies

* [`pre-commit`](https://pre-commit.com/#install)
* [`terraform-docs`](https://github.com/segmentio/terraform-docs) required for `terraform_docs` hooks.
* [`TFLint`](https://github.com/terraform-linters/tflint) required for `terraform_tflint` hook.

#### MacOS

```bash
brew install pre-commit terraform-docs tflint

brew tap git-chglog/git-chglog
brew install git-chglog
```
