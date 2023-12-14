resource "ses_domain_identity" "ses" {
  domain = "${var.domain}-${var.environment}.com"
}