provider "aws" {
  region = "eu-west-1"
}

module "ecs-service-scaling" {
  source = "../.."

  enabled = true

  name_prefix = "test-sqs-scalling"

  min_capacity = 2
  max_capacity = 22

  cluster_name = "dev-ecs"
  service_name = "dev-triggers-action"

  metric_query = [
    {
      id          = "e1"
      return_data = true
      expression  = "visible+notvisible"
      label       = "Sum_Visible+NonVisible"
    },
    {
      id = "visible"
      metric = [
        {
          namespace   = "AWS/SQS"
          metric_name = "ApproximateNumberOfMessagesVisible"
          period      = 60
          stat        = "Maximum"

          dimensions = {
            QueueName = "dev-triggers-action"
          }
        }
      ]
    },
    {
      id = "notvisible"

      metric = [
        {
          namespace   = "AWS/SQS"
          metric_name = "ApproximateNumberOfMessagesNotVisible"
          period      = 60
          stat        = "Maximum"

          dimensions = {
            QueueName = "dev-triggers-action"
          }
        }
      ]
    }
  ]
}
