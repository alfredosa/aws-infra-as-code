output "load_balancer_arn" {
  value = aws_lb.load_balancer.arn
}

output "load_balancer_dns_name" {
  value = aws_lb.load_balancer.dns_name
}