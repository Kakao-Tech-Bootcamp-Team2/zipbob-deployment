resource "aws_sns_topic" "cpu_alerts" {
  name = "cpu-usage-alerts"
}

resource "aws_sns_topic_subscription" "cpu_alerts_email" {
  topic_arn = aws_sns_topic.cpu_alerts.arn
  protocol  = "email"
  endpoint  = "jonum12312@gmail.com"
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_usage" {
  alarm_name                = "high-cpu-usage"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 1
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 300
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "This metric monitors ec2 cpu usage"
  actions_enabled           = true
  alarm_actions             = [aws_sns_topic.cpu_alerts.arn]
  ok_actions                = [aws_sns_topic.cpu_alerts.arn]
  insufficient_data_actions = [aws_sns_topic.cpu_alerts.arn]
}
