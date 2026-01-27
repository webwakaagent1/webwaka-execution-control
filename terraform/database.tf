# Aurora PostgreSQL Database Configuration
# Session 3: Database Infrastructure

# Database subnet group
resource "aws_db_subnet_group" "database" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name        = "${var.project_name}-db-subnet-group"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Aurora PostgreSQL cluster
resource "aws_rds_cluster" "postgresql" {
  cluster_identifier      = "${var.project_name}-postgres-cluster"
  engine                  = "aurora-postgresql"
  engine_version          = "15"
  database_name           = var.database_name
  master_username         = var.database_master_username
  master_password         = var.database_master_password
  
  db_subnet_group_name    = aws_db_subnet_group.database.name
  vpc_security_group_ids  = [aws_security_group.database.id]
  
  # Backup configuration
  backup_retention_period = 7
  preferred_backup_window = "03:00-04:00"
  
  # Maintenance window
  preferred_maintenance_window = "mon:04:00-mon:05:00"
  
  # Encryption
  storage_encrypted = true
  kms_key_id        = aws_kms_key.rds.arn
  
  # Deletion protection
  deletion_protection = true
  skip_final_snapshot = false
  final_snapshot_identifier = "${var.project_name}-postgres-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  
  # Enable CloudWatch logs
  enabled_cloudwatch_logs_exports = ["postgresql"]
  
  tags = {
    Name        = "${var.project_name}-postgres-cluster"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Aurora PostgreSQL cluster instances
resource "aws_rds_cluster_instance" "postgresql" {
  count              = 2  # Primary + 1 read replica for HA
  identifier         = "${var.project_name}-postgres-instance-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.postgresql.id
  instance_class     = var.database_instance_class
  engine             = aws_rds_cluster.postgresql.engine
  engine_version     = aws_rds_cluster.postgresql.engine_version
  
  # Performance Insights
  performance_insights_enabled = true
  performance_insights_retention_period = 7
  
  # Monitoring
  monitoring_interval = 60
  monitoring_role_arn = aws_iam_role.rds_monitoring.arn
  
  tags = {
    Name        = "${var.project_name}-postgres-instance-${count.index + 1}"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# KMS key for RDS encryption
resource "aws_kms_key" "rds" {
  description             = "KMS key for RDS encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = {
    Name        = "${var.project_name}-rds-kms-key"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_kms_alias" "rds" {
  name          = "alias/${var.project_name}-rds"
  target_key_id = aws_kms_key.rds.key_id
}

# IAM role for RDS enhanced monitoring
resource "aws_iam_role" "rds_monitoring" {
  name = "${var.project_name}-rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-rds-monitoring-role"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "rds_monitoring" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# CloudWatch alarm for high CPU
resource "aws_cloudwatch_metric_alarm" "database_cpu" {
  alarm_name          = "${var.project_name}-database-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors database CPU utilization"
  alarm_actions       = []  # Add SNS topic ARN here if needed

  dimensions = {
    DBClusterIdentifier = aws_rds_cluster.postgresql.id
  }

  tags = {
    Name        = "${var.project_name}-database-high-cpu-alarm"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# CloudWatch alarm for low storage
resource "aws_cloudwatch_metric_alarm" "database_storage" {
  alarm_name          = "${var.project_name}-database-low-storage"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "10737418240"  # 10 GB in bytes
  alarm_description   = "This metric monitors database free storage space"
  alarm_actions       = []  # Add SNS topic ARN here if needed

  dimensions = {
    DBClusterIdentifier = aws_rds_cluster.postgresql.id
  }

  tags = {
    Name        = "${var.project_name}-database-low-storage-alarm"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
