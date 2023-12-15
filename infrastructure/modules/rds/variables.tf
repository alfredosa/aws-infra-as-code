variable "db_name" {
  description = "The name of the database to create."
}

variable "db_username" {
  description = "The username for the database."
}

variable "db_password" {
  description = "The password for the database."
}

variable "vpc_id" {
  description = "The ID of the VPC to deploy to."
}

variable "org_name" {
  description = "The name of the organisation."
}

variable "dedicated_service" {
  description = "The name of the organisation."
}

variable "ecs_cluster_security_group_id" {
  description = "The ID of the security group to attach to the agent."
}

variable "private_subnet_group_name" {
  description = "The name of the private subnet group to deploy to."
}

variable "environment" {
  description = "The environment to deploy to."
}

variable "db_instance_class" {
  description = "The instance class to use for the database."
}