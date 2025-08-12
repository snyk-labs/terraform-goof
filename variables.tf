variable "region" {
  type    = string
  default = "us-west-1"
}

variable "ami" {
  type    = string
  description = "ami used for ec2 instance. example - ami-07336266b2c69c546 (terraform-goof-example-ami)"
  default = "ami-07336266b2c69c546"
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
