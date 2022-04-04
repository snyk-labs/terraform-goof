variable "environment" {
  description = "the type of environment (dev,staging/prod)"
}

variable "default_tags" {
  default     = {}
  description = "default tags to resources"
}

variable "public_var_test" {
  default     = false
  description = "test value for publicly accessible s3"
}

variable "acl" {}

variable "private_subnet" {}

variable "vpc_id" {}

variable "db_username" {}

variable "db_password" {}
