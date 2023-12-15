// outputs of the ecr

output "cloudwatch_group_name" {
  value = aws_cloudwatch_log_group.cloutwatch_log_group.name
}
