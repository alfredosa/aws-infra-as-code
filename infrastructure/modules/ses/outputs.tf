output "domain_identity_arn" {
  description = "The ARN of the domain identity"
  value       = aws_ses_domain_identity.ses.arn
}