// outputs of the ecr

output "cloutwatch_group_name" {
  value = aws_cloudwatch_log_group.iac_agent_log_group.name
}
