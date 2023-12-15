output "cluster_security_group_id" {
  value = aws_security_group.ecs_agent.id
}

output "cluster_id" {
  value = aws_ecs_cluster.ecs_agent_cluster.id
}