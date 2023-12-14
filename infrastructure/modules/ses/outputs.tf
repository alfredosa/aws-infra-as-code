output "verification_token" {
  description = "The verification token for the domain"
  value       = aws_ses_domain_identity.example.verification_token
}

output "domain_identity_arn" {
  description = "The ARN of the domain identity"
  value       = aws_ses_domain_identity.example.arn
}