resource "aws_s3_bucket" "b" {
  bucket = "inf-waggys-data-lake"

  tags = {
    Name        = "iac Orchastration s3 bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "acl-iac-bucket" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}
