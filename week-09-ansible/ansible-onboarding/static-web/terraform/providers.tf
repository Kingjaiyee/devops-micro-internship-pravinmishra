terraform {
  required_version = ">= 1.9.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Credentials come from AWS_PROFILE (set by lab.env), never from this file.
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = var.project_name
      Owner     = "victor-durojaiye"
      ManagedBy = "terraform"
      Course    = "dmi-cohort-3-week-9"
    }
  }
}
