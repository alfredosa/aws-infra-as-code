terraform {
  backend "s3" {
    dynamodb_table = "terraform-locks"
    bucket         = "terraform-tfstate-infrastructure-as-code"
    encrypt        = true
    key            = "infrastructure/environments/prod/tfstate/app.tfstate"
    region         = "eu-west-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.31.0"
    }
  }
}

provider "aws" {
  # allowed_account_ids = [var.aws_account_id] when formalized into an Organization
  region              = var.region

  access_key = var.access_key
  secret_key = var.secret_key

  default_tags {
    tags = {
      terraform  = true
      repository = "infrastructure-as-code"
    }
  }
}