# Terraform Backend Configuration
# Stores state in S3 bucket created during AWS Bootstrap

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket         = "webwaka-terraform-state-us-east-1"
    key            = "production/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "webwaka-terraform-locks"
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = "WebWaka"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Phase       = "Phase1"
    }
  }
}
