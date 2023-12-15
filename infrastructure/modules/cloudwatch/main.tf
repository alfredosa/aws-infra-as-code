resource "aws_cloudwatch_log_group" "cloutwatch_log_group" {
  name              = "log-group-${var.environment}"
  retention_in_days = var.agent_log_retention_in_days
}