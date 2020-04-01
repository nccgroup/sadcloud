resource "aws_cloudwatch_metric_alarm" "main" {

  count = var.alarm_without_actions ? 1 : 0

  alarm_name                = var.name
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "GetRequests"
  namespace                 = "AWS/S3"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "10000"

  alarm_actions = null
}
