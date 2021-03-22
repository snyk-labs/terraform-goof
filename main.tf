provider "aws" {
  version                     = "~> 2.67"
  region                      = var.region
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = var.access_key
  secret_key                  = var.secret_key
}

resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 8
  #require_lowercase_characters   = true
  #require_numbers                = true
  #require_uppercase_characters   = true
  #require_symbols                = true
  #allow_users_to_change_password = true
  #password_reuse_prevention      = 24
  max_password_age                = 3
}

module "vpc" {
  source = "./modules/vpc"
}

module "subnet"  {
  source = "./modules/subnet"
  vpc_id = module.vpc.vpc_id
}

module "storage" {
  source = "./modules/storage"

  acl = var.s3_acl
  db_password = "supersecret"
  db_username = "snyk"
  environment = "dev"
  private_subnet = [module.subnet.subnet_id]
  vpc_id = module.vpc.vpc_id
}

module "instance" {
  source                 = "git@github.com:terraform-aws-modules/terraform-aws-ec2-instance.git"
  ami                    = var.ami
  instance_type          = "t2.micro"
  name                   = "example-server"
  instance_count         = 1

  vpc_security_group_ids = [module.vpc.vpc_sg_id]
  subnet_id              = module.subnet.subnet_id

  tags = {
    Terraform            = "true"
    Environment          = "dev"
  }
}

