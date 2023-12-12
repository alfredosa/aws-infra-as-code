output "metabase_service_id" {
  value = aws_ecs_service.metabase_service.id
}

output "iac_agent_execution_role_arn" {
  value = aws_iam_role.iac_agent_execution_role.arn
}

output "iac_metabase_task_role_arn" {
  value = var.metabase_task_role_arn == null ? aws_iam_role.iac_metabase_task_role[0].arn : var.metabase_task_role_arn
}

output "iac_agent_security_group" {
  value = aws_security_group.iac_agent.id
}

output "iac_agent_cluster_name" {
  value = aws_ecs_cluster.iac_agent_cluster.name
}

output "load_balancer_dns_name" {
  value = aws_lb.metabase.dns_name
}