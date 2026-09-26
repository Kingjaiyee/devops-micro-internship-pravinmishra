terraform {
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
      Project = "tf-drift-lab"
      Owner   = "Victor Durojaiye"
    }
  }
}

# A VPC, a subnet and a security group. All three are free of charge,
# which keeps this drift lab at zero cost.
resource "aws_vpc" "lab" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "tf-drift-lab-vpc"
  }
}

resource "aws_subnet" "lab" {
  vpc_id            = aws_vpc.lab.id
  cidr_block        = var.subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "tf-drift-lab-subnet"
  }
}

# The ingress rules are declared inline on purpose. Inline rules are
# authoritative, so Terraform will detect and plan to remove any rule added
# to this group outside Terraform. That is what makes out-of-band drift
# visible in the plan.
resource "aws_security_group" "lab" {
  name        = "tf-drift-lab-sg"
  description = "Drift lab security group. SSH from the operator IP only."
  vpc_id      = aws_vpc.lab.id

  ingress {
    description = "SSH from operator IP only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-drift-lab-sg"
  }
}

output "vpc_id" {
  value = aws_vpc.lab.id
}

output "subnet_id" {
  value = aws_subnet.lab.id
}

output "security_group_id" {
  value = aws_security_group.lab.id
}
