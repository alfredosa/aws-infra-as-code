variable "environment" {
  description = "The environment to deploy to."
  default     = "staging"
}

variable "org_name" {
  description = "The name of the organisation."
  default     = "iac"
}

variable "metabase_task_role_arn" {
  description = "Optional task role ARN to pass to the agent. If not defined, a task role will be created"
  default     = null
  type        = string
}

variable "ecs_cluster_name" {
  default = "${var.org_name}-${var.environment}"
}