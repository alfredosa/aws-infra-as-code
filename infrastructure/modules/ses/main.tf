resource "aws_ses_domain_identity" "ses" {
  domain = "${var.domain}-${var.environment}.com"
}