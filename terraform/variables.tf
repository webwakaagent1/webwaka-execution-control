# Terraform Variables Configuration

variable "aws_region" {
  description = "AWS region for infrastructure deployment"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (production, staging, development)"
  type        = string
  default     = "production"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "webwaka"
}

# VPC Configuration
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

variable "database_subnet_cidrs" {
  description = "CIDR blocks for database subnets"
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
}

# Tags
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "WebWaka"
    ManagedBy   = "Terraform"
    Phase       = "Phase1"
  }
}

# Database variables
variable "database_name" {
  description = "Name of the default database"
  type        = string
  default     = "webwaka"
}

variable "database_master_username" {
  description = "Master username for the database"
  type        = string
  default     = "webwaka_admin"
  sensitive   = true
}

variable "database_master_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

variable "database_instance_class" {
  description = "Instance class for database instances"
  type        = string
  default     = "db.t3.medium"
}
