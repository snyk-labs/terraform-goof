variable "environment" {
  description = "the type of environment (dev,staging/prod)"
}

variable "default_tags" {
  default     = {}
  description = "default tags to resources"
}

variable "public_block_acl" {
  default     = false
  description = "test value for publicly accessible acl"
}

variable "public_ignore_acl" {
  default     = true
  description = "test value for publicly accessible acl"
}

variable "public_policy_control" {
  default     = true
  description = "test value for public policy control"
}

variable "acl" {}

variable "private_subnet" {}

variable "vpc_id" {}

variable "db_username" {}

variable "db_password" {}
