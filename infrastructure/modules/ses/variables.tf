variable "domain" {
  description = "The domain to verify with SES"
  type        = string
}

variable "environment" {
  description = "The environment to deploy to."
  default     = "staging"
  
}