variable "region" {
  type    = string
  default = "us-west-2"
}

variable "ami" {
  type    = string
  description = "ami used for ec2 instance. example - ami-0e440512457dcde50 (Amazon Linux 2023 arm64 AMI) in us-west-2"
  default = "ami-0e440512457dcde50"
}

variable "access_key" {
  description = "AWS Access Key"
  type    = string
}

variable "secret_key" {
  description = "AWS Secret Key"
  type    = string
}

variable "session_token" {
  description = "AWS session token for temporary credentials"
  type        = string
  sensitive   = true
  default     = null
}

variable "s3_acl" {
  type = string
  default = "public-read-write"
}

variable "env" {
  type = string
  default = "dev"
}
