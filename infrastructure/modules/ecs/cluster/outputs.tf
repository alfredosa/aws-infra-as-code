output "task_role_arn" {
  value = aws_iam_role.ecs_metabase_task_role.arn
}

output "cluster_execution_role_arn" {
  value = aws_iam_role.ecs_agent_execution_role.arn
}

output "cluster_security_group_id" {
  value = aws_security_group.ecs_agent.id
}
