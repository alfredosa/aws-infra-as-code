variable "environment" {
  description = "The environment to deploy to."
  default     = "staging"
}

variable "org_name" {
  description = "The name of the organisation."
  default     = "iac"
}


variable "vpc_id" {
  description = "The VPC ID to deploy to."
  type        = string
}

variable "load_balancer_security_group_ids" {
  description = "The security group ID of the load balancer."
  type        = list(string)
}