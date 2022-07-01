resource "aws_db_subnet_group" "snyk_rds_subnet_grp" {
  name       = "snyk_rds_subnet_grp_${var.environment}"
  subnet_ids = var.private_subnet

  tags = merge(var.default_tags, {
    Name = "snyk_rds_subnet_grp_${var.environment}"
  })
}

resource "aws_security_group" "snyk_rds_sg" {
  name   = "snyk_rds_sg"
  vpc_id = var.vpc_id

  tags = merge(var.default_tags, {
    Name = "snyk_rds_sg_${var.environment}"
  })

  # HTTP access from anywhere
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_kms_key" "snyk_db_kms_key" {
  description             = "KMS Key for DB instance ${var.environment}"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = merge(var.default_tags, {
    Name = "snyk_db_kms_key_${var.environment}"
  })
}

resource "aws_db_instance" "snyk_db" {
  name                      = "snyk_db_${var.environment}"
  allocated_storage         = 20
  engine                    = "postgres"
  engine_version            = "10.20"
  instance_class            = "db.t3.micro"
  storage_type              = "gp2"
  password                  = var.db_password
  username                  = var.db_username
  vpc_security_group_ids    = [aws_security_group.snyk_rds_sg.id]
  db_subnet_group_name      = aws_db_subnet_group.snyk_rds_subnet_grp.id
  identifier                = "snyk-db-${var.environment}"
  storage_encrypted         = true
  skip_final_snapshot       = true
  final_snapshot_identifier = "snyk-db-${var.environment}-db-destroy-snapshot"
  kms_key_id                = aws_kms_key.snyk_db_kms_key.arn
  tags = merge(var.default_tags, {
    Name = "snyk_db_${var.environment}"
  })
}

resource "aws_ssm_parameter" "snyk_ssm_db_host" {
  name        = "/snyk-${var.environment}/DB_HOST"
  description = "Snyk Database"
  type        = "SecureString"
  value       = aws_db_instance.snyk_db.endpoint

  tags = merge(var.default_tags, {})
}

resource "aws_ssm_parameter" "snyk_ssm_db_password" {
  name        = "/snyk-${var.environment}/DB_PASSWORD"
  description = "Snyk Database Password"
  type        = "SecureString"
  value       = aws_db_instance.snyk_db.password

  tags = merge(var.default_tags, {})
}

resource "aws_ssm_parameter" "snyk_ssm_db_user" {
  name        = "/snyk-${var.environment}/DB_USER"
  description = "Snyk Database Username"
  type        = "SecureString"
  value       = aws_db_instance.snyk_db.username

  tags = merge(var.default_tags, {})
}
resource "aws_ssm_parameter" "snyk_ssm_db_name" {
  name        = "/snyk-${var.environment}/DB_NAME"
  description = "Snyk Database Name"
  type        = "SecureString"
  value       = aws_db_instance.snyk_db.name

  tags = merge(var.default_tags, {
    environment = "${var.environment}"
  })
}

resource "aws_s3_bucket" "snyk_storage" {
  bucket = "snyk-storage-${var.environment}-demo"
  tags = merge(var.default_tags, {
    name = "snyk_blob_storage_${var.environment}"
  })
}

resource "aws_s3_bucket" "my-new-undeployed-bucket" {
  bucket = "snyk-public-${var.environment}-demo"
}

resource "aws_s3_bucket_public_access_block" "snyk_public" {
  bucket = aws_s3_bucket.my-new-undeployed-bucket.id

  block_public_acls   = false
  ignore_public_acls = var.public_ignore_acl
  block_public_policy = var.public_policy_control
}

resource "aws_s3_bucket_public_access_block" "snyk_private" {
  bucket = aws_s3_bucket.snyk_storage.id

  ignore_public_acls  = true
  block_public_acls   = true
  block_public_policy = true
}
