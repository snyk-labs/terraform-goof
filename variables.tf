variable "region" {
  type    = string
  default = "us-east-1"
}

variable "ami" {
  type    = string
  description = "ami used for ec2 instance. example - ami-0a91cd140a1fc148a (Ubuntu 20.4 LTS)"
}

variable "access_key" {
  type    = string
}

variable "secret_key" {
  type    = string
}

variable "s3_acl" {
  type = string
  default = "public"
}
