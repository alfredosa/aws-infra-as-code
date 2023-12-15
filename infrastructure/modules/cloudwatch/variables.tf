variable "environment" {
  description = "The environment to deploy to."
  default     = "staging"
}

variable "agent_log_retention_in_days" {
  description = "Number of days to retain agent logs for"
  default     = 30
  type        = number
}