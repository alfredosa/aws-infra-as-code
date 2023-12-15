variable "environment" {
  description = "The environment to deploy to."
  default     = "staging"
}

variable "org_name" {
  description = "The name of the organisation."
}

variable "metabase_cpu" {
  description = "CPU units to allocate to the agent"
  default     = 2048
  type        = number
  
}

variable "metabase_memory" {
  description = "Memory units to allocate to the agent"
  default     = 4096
  type        = number
}

variable "metabase_image" {
  description = "Container image for the agent. This could be the name of an image in a public repo or an ECR ARN"
  default     = "metabase/metabase:latest"
  type        = string
}

variable "db_name" {
    description = "The name of the database to create."
}

variable "db_username" {
    description = "The username for the database."
}

variable "db_password" {
    description = "The password for the database."
}

variable "db_host" {
    description = "The host for the database."
}

variable "region" {
    description = "The AWS region to create resources in."
}

variable "cloudwatch_group_name" {
  description = "The name of the CloudWatch log group to send logs to."
  type        = string
}

variable "ecs_cluster_id" {
  description = "The ID of the ECS cluster to deploy to."
  type        = string
}

variable "load_balancer_target_group_arn" {
  description = "The ARN of the load balancer target group to attach to the agent."
  type        = string
}

variable "public_subnet_ids" {
  description = "The IDs of the public subnets to deploy to."
  type        = list(string)
}

variable "cluster_security_group_id" {
    description = "The ID of the security group to attach to the agent."
    type        = string
}
