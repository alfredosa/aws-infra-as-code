variable "s3_bucket" {
  description = "S3 bucket name for iac TF"
  default     = "iac-data-lake"
  type        = string
}

variable "key_name" {
  default = "iac.key"
}

# core
variable "region" {
  description = "The AWS region to create resources in."
  default     = "eu-west-2"
}

variable "db_name" {
  description = "The name of the database to create."
  default     = "iac"
}

variable "db_username" {
  description = "The username for the database."
  default     = "iac"
}

variable "db_password" {
  description = "The password for the database."
  default     = "foobarbaz"
}
