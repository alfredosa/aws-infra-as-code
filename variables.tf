variable "s3_bucket" {
  description = "S3 bucket name for iac TF"
  default = "iac-data-lake"
  type = string
}

variable "ecs_cluster_name" {
  default = "iac"
}

variable "key_name" {
  default = "iac.key"
}
variable "secret_key" {
    description = "super access key"
    type = string

}
variable "access_key" {
    description = "super secret key"
    type = string
}

# core
variable "region" {
    description = "The AWS region to create resources in."
    default = "eu-west-2"
}

variable "db_name" {
    description = "The name of the database to create."
    default = "iac"
}

variable "db_username" {
    description = "The username for the database."
    default = "iac"
}

variable "db_password" {
    description = "The password for the database."
    default = "foobarbaz"
}

### ECR Repository
variable "iac-ecr" {
  description = "ECR Repository name"
  default = "iac-ecr"
}

# variable "availability_zones" {
#   description = "Availability zones"
#   type        = list(string)
#   default     = ["eu-west-2b", "eu-west-2c"]
# }
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

variable "agent_log_retention_in_days" {
  description = "Number of days to retain agent logs for"
  default     = 30
  type        = number
}


variable "agent_queue_name" {
  description = "iac queue that the agent should listen to"
  default     = "default"
  type        = string
}


variable "metabase_task_role_arn" {
  description = "Optional task role ARN to pass to the agent. If not defined, a task role will be created"
  default     = null
  type        = string
}

variable "name" {
  description = "Unique name for this IaC deployment"
  default = "waggys-iac"
  type        = string
}



# # networking
# variable "public_subnet_1_cidr" {
#   description = "CIDR Block for Public Subnet 1"
#   default     = "10.0.1.0/24"
# }
# variable "public_subnet_2_cidr" {
#   description = "CIDR Block for Public Subnet 2"
#   default     = "10.0.2.0/24"
# }
# variable "private_subnet_1_cidr" {
#   description = "CIDR Block for Private Subnet 1"
#   default     = "10.0.3.0/24"
# }
# variable "private_subnet_2_cidr" {
#   description = "CIDR Block for Private Subnet 2"
#   default     = "10.0.4.0/24"
# }
