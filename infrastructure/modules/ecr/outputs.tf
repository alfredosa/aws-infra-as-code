// outputs of the ecr

output "ecr_url" {
  value = aws_ecr_repository.iac-ecr.repository_url
}

