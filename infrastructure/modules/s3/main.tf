resource "aws_s3_bucket" "b" {
  bucket = "${var.organization_name}-${var.bucket_name}-${var.environment}"

  tags = {
    Name        = "${var.organization_name}-${var.bucket_name}"
    Environment = "${var.environment}"
  }
}


