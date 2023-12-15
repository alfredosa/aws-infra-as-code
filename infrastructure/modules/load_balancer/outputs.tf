output "metabase_lb_target_group_arn" {
  value = aws_lb_target_group.metabase.arn
}

output "dns_name" {
  value = aws_lb.load_balancer.dns_name
}

output "load_balancer_security_group_ids" {
  value = aws_lb.load_balancer.security_groups
  
}