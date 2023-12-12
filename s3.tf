resource "aws_s3_bucket" "b" {
  bucket = "inf-waggys-data-lake"

  tags = {
    Name        = "iac Orchastration s3 bucket"
    Environment = "Dev"
  }
}


