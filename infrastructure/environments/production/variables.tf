variable "domain" {
    description = "The Organization Domain"
    type        = string
}

variable "organization_name" {
    description = "The Organization Name"
    type        = string
}

variable "secret_key" {
    description = "super access key"
    type = string

}
variable "access_key" {
    description = "super secret key"
    type = string
}

variable "environment" {
    description = "The environment to deploy to."
    type        = string
}

variable "region" {
    description = "The AWS region to create resources in."
    type        = string
    default = "eu-west-2"
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
