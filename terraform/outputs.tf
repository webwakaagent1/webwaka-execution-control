# Terraform Outputs

# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

# Subnet Outputs
output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "database_subnet_ids" {
  description = "IDs of database subnets"
  value       = aws_subnet.database[*].id
}

# NAT Gateway Outputs
output "nat_gateway_ids" {
  description = "IDs of NAT Gateways"
  value       = aws_nat_gateway.main[*].id
}

output "nat_gateway_ips" {
  description = "Elastic IPs of NAT Gateways"
  value       = aws_eip.nat[*].public_ip
}

# Security Group Outputs
output "alb_security_group_id" {
  description = "ID of ALB security group"
  value       = aws_security_group.alb.id
}

output "app_security_group_id" {
  description = "ID of application security group"
  value       = aws_security_group.app.id
}

output "database_security_group_id" {
  description = "ID of database security group"
  value       = aws_security_group.database.id
}

output "cache_security_group_id" {
  description = "ID of cache security group"
  value       = aws_security_group.cache.id
}

output "bastion_security_group_id" {
  description = "ID of bastion security group"
  value       = aws_security_group.bastion.id
}

# Internet Gateway Output
output "internet_gateway_id" {
  description = "ID of Internet Gateway"
  value       = aws_internet_gateway.main.id
}

# Route Table Outputs
output "public_route_table_id" {
  description = "ID of public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "IDs of private route tables"
  value       = aws_route_table.private[*].id
}

output "database_route_table_id" {
  description = "ID of database route table"
  value       = aws_route_table.database.id
}

# VPC Flow Log Outputs
output "vpc_flow_log_id" {
  description = "ID of VPC Flow Log"
  value       = aws_flow_log.main.id
}

output "vpc_flow_log_group_name" {
  description = "Name of CloudWatch Log Group for VPC Flow Logs"
  value       = aws_cloudwatch_log_group.vpc_flow_log.name
}

# Database outputs
output "database_cluster_endpoint" {
  description = "Aurora PostgreSQL cluster endpoint"
  value       = aws_rds_cluster.postgresql.endpoint
}

output "database_reader_endpoint" {
  description = "Aurora PostgreSQL cluster reader endpoint"
  value       = aws_rds_cluster.postgresql.reader_endpoint
}

output "database_port" {
  description = "Database port"
  value       = aws_rds_cluster.postgresql.port
}

output "database_name" {
  description = "Database name"
  value       = aws_rds_cluster.postgresql.database_name
}

output "database_cluster_id" {
  description = "Database cluster identifier"
  value       = aws_rds_cluster.postgresql.id
}

# Cognito outputs
output "cognito_user_pool_id" {
  description = "ID of the Cognito User Pool"
  value       = aws_cognito_user_pool.main.id
}

output "cognito_user_pool_arn" {
  description = "ARN of the Cognito User Pool"
  value       = aws_cognito_user_pool.main.arn
}

output "cognito_user_pool_endpoint" {
  description = "Endpoint of the Cognito User Pool"
  value       = aws_cognito_user_pool.main.endpoint
}

output "cognito_web_client_id" {
  description = "ID of the Cognito Web Client"
  value       = aws_cognito_user_pool_client.web.id
}

output "cognito_domain" {
  description = "Cognito User Pool Domain"
  value       = aws_cognito_user_pool_domain.main.domain
}

output "cognito_identity_pool_id" {
  description = "ID of the Cognito Identity Pool"
  value       = aws_cognito_identity_pool.main.id
}

# ECS/Fargate outputs
output "ecs_cluster_id" {
  description = "ID of the ECS cluster"
  value       = aws_ecs_cluster.main.id
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.main.arn
}

output "alb_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  value       = aws_lb.main.zone_id
}

output "ecr_repository_url" {
  description = "URL of the ECR repository for API images"
  value       = aws_ecr_repository.api.repository_url
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.api.name
}
