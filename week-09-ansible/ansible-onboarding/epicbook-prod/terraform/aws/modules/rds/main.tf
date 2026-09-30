# Spans both private subnets, which RDS requires for a DB subnet group.
resource "aws_db_subnet_group" "epicbook" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

resource "aws_db_instance" "epicbook" {
  identifier     = "${var.project_name}-mysql"
  engine         = "mysql"
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class

  # Never fall into paid RDS Extended Support
  engine_lifecycle_support = "open-source-rds-extended-support-disabled"

  allocated_storage = var.db_allocated_storage
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = var.db_name
  username = var.db_username

  # Write-only: sent to AWS, never saved in Terraform state
  password_wo         = var.db_password
  password_wo_version = var.db_password_version

  db_subnet_group_name   = aws_db_subnet_group.epicbook.name
  vpc_security_group_ids = [var.security_group_id]

  # The database is reachable only from inside the VPC.
  publicly_accessible = false

  # Lab settings so that terraform destroy removes everything cleanly
  # and leaves no billable snapshot behind.
  skip_final_snapshot     = true
  backup_retention_period = 0
  deletion_protection     = false
  apply_immediately       = true

  tags = {
    Name = "${var.project_name}-mysql"
  }
}
