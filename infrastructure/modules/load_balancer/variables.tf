variable "vpc_id" {
  description = "The VPC ID to deploy the load balancer into"
  type        = string
}

variable "public_subnet_1_id" {
  description = "The subnet ID to deploy the load balancer into"
  type        = string
}

variable "public_subnet_2_id" {
  description = "The subnet ID to deploy the load balancer into"
  type        = string
}

variable "environment" {
  description = "The environment to deploy to."
  default     = "staging"
  
}

variable "base_cidr_block_list" {
  description = "The base CIDR block to use for the VPC."
  default     = ["0.0.0.0/0"]
}