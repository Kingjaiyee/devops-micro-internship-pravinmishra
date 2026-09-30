terraform {
  # Write-only arguments (password_wo) need Terraform 1.11 or later
  required_version = ">= 1.11.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Credentials come from the terraform-dmi profile through AWS_PROFILE.
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project = var.project_name
      Owner   = "Victor Durojaiye"
    }
  }
}

# Network module: VPC, subnets, gateway, routing and security groups.
module "network" {
  source = "./modules/network"

  project_name       = var.project_name
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  private_db_a_cidr  = var.private_db_a_cidr
  private_db_b_cidr  = var.private_db_b_cidr
  public_subnet_az   = var.public_subnet_az
  private_db_a_az    = var.private_db_a_az
  private_db_b_az    = var.private_db_b_az
  my_ip_cidr         = var.my_ip_cidr
}

# EC2 module: the EpicBook application server in the public subnet.
# Ansible configures it after Terraform creates it.
module "ec2" {
  source = "./modules/ec2"

  project_name      = var.project_name
  instance_type     = var.instance_type
  public_key_path   = var.public_key_path
  subnet_id         = module.network.public_subnet_id
  security_group_id = module.network.ec2_security_group_id
}

# RDS module: private managed MySQL database.
module "rds" {
  source = "./modules/rds"

  project_name         = var.project_name
  db_subnet_ids        = module.network.private_db_subnet_ids
  security_group_id    = module.network.rds_security_group_id
  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = var.db_password
  db_password_version  = var.db_password_version
  db_instance_class    = var.db_instance_class
  db_engine_version    = var.db_engine_version
  db_allocated_storage = var.db_allocated_storage
}
