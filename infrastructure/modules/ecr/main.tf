resource "aws_ecr_repository" "iac-ecr" {
  name = "${var.org_name}-${var.environment}"
}

