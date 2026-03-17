terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # 1. Tell terraform to use remote state (state migration) 
  backend "s3" {
    bucket       = "our-terraform-state-bucket-333"
    key          = "s3/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}

# 2. Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
