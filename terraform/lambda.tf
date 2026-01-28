# Lambda Function for Backend API

# IAM Role for Lambda
resource "aws_iam_role" "lambda_exec" {
  name = "webwaka-lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

  tags = {
    Name        = "webwaka-lambda-exec-role"
    Environment = var.environment
    Project     = "WebWaka"
  }
}

# Attach basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_exec.name
}

# Attach VPC execution policy (for accessing RDS)
resource "aws_iam_role_policy_attachment" "lambda_vpc" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  role       = aws_iam_role.lambda_exec.name
}

# Lambda Function
# Note: backend.zip must be pre-built with: cd backend && zip -r ../backend.zip . -x ".git/*" ".gitignore"
resource "aws_lambda_function" "api" {
  filename         = "${path.module}/../backend.zip"
  function_name    = "webwaka-api"
  role            = aws_iam_role.lambda_exec.arn
  handler         = "index.handler"
  source_code_hash = filebase64sha256("${path.module}/../backend.zip")
  runtime         = "nodejs20.x"
  timeout         = 30
  memory_size     = 512

  environment {
    variables = {
      NODE_ENV           = var.environment
      DB_HOST            = aws_rds_cluster.postgresql.endpoint
      DB_NAME            = var.database_name
      DB_USER            = var.database_master_username
      SNS_TOPIC_ARN      = aws_sns_topic.webwaka_notifications.arn
      UPLOADS_BUCKET_NAME = aws_s3_bucket.uploads.id
    }
  }

  # VPC configuration temporarily disabled for testing
  # vpc_config {
  #   subnet_ids         = aws_subnet.private[*].id
  #   security_group_ids = [aws_security_group.app.id]
  # }

  tags = {
    Name        = "webwaka-api"
    Environment = var.environment
    Project     = "WebWaka"
  }
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/webwaka-api"
  retention_in_days = 7

  tags = {
    Name        = "webwaka-lambda-logs"
    Environment = var.environment
    Project     = "WebWaka"
  }
}

# Lambda Permission for API Gateway
resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}
