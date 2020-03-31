variable "enabled" {
  type        = bool
  description = "Whether to create the resources. Set to `false` to prevent the module from creating any resources"
  default     = true
}

variable "name_prefix" {
  description = "A prefix used for naming resources."
  type        = string
}

variable "cluster_name" {
  type        = string
  description = "Name of ECS cluster that service is in"
}

variable "service_name" {
  type        = string
  description = "Name of ECS service to autoscale"
}

variable "metric_query" {
  description = "Enables you to create an alarm based on a metric math expression. You may specify at most 20."
  type        = any
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}

variable "max_capacity" {
  type        = string
  description = "Maximum number of tasks to scale to"
  default     = "5"
}

variable "min_capacity" {
  type        = string
  description = "Minimum number of tasks to scale to"
  default     = "2"
}

variable "scale_up_cooldown" {
  type        = string
  description = "The amount of time, in seconds, after a scaling up completes and before the next scaling up can start"
  default     = "60"
}

variable "scale_down_cooldown" {
  type        = string
  description = "The amount of time, in seconds, after a scaling down completes and before the next scaling activity can start"
  default     = "60"
}


variable "adjustment_type_down" {
  type        = string
  description = "Autoscaling policy down adjustment type (ExactCapacity, ChangeInCapacity, PercentChangeInCapacity)"
  default     = "ChangeInCapacity"
}

variable "adjustment_type_up" {
  type        = string
  description = "Autoscaling policy up adjustment type (ExactCapacity, ChangeInCapacity, PercentChangeInCapacity)"
  default     = "ChangeInCapacity"
}

variable "scale_down_min_adjustment_magnitude" {
  type        = string
  description = "Minimum number of tasks to scale down at a time "
  default     = "0"
}

variable "scale_up_min_adjustment_magnitude" {
  type        = string
  description = "Minimum number of tasks to scale up at a time "
  default     = "0"
}

variable "scale_down_scaling_adjustment" {
  type        = string
  description = "The number of members by which to scale down, when the adjustment bounds are breached. Should always be negative value"
  default     = "-2"
}

variable "scale_down_lower_bound" {
  type        = string
  description = "The lower bound for the difference between the alarm threshold and the CloudWatch metric. Without a value, AWS will treat this bound as negative infinity"
  default     = ""
}

variable "scale_down_upper_bound" {
  type        = string
  description = "The upper bound for the difference between the alarm threshold and the CloudWatch metric. Without a value, AWS will treat this bound as infinity"
  default     = "0"
}

variable "scale_up_scaling_adjustment" {
  type        = string
  description = "The number of members by which to scale up, when the adjustment bounds are breached. Should always be positive value"
  default     = "4"
}

variable "scale_up_lower_bound" {
  type        = string
  description = "The lower bound for the difference between the alarm threshold and the CloudWatch metric. Without a value, AWS will treat this bound as negative infinity"
  default     = "0"
}

variable "scale_up_upper_bound" {
  type        = string
  description = "The upper bound for the difference between the alarm threshold and the CloudWatch metric. Without a value, AWS will treat this bound as infinity"
  default     = ""
}

variable "high_evaluation_periods" {
  type        = string
  description = "The number of periods over which data is compared to the high threshold"
  default     = "1"
}

variable "high_threshold" {
  type        = string
  description = "The value against which the high statistic is compared"
  default     = "10"
}

variable "low_evaluation_periods" {
  type        = string
  description = "The number of periods over which data is compared to the low threshold"
  default     = "1"
}

variable "low_threshold" {
  type        = string
  description = "The value against which the low statistic is compared"
  default     = "10"
}
