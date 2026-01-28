# DynamoDB table for WebSocket connections
resource "aws_dynamodb_table" "websocket_connections" {
  name           = "webwaka-websocket-connections-${var.environment}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "connectionId"

  attribute {
    name = "connectionId"
    type = "S"
  }

  ttl {
    attribute_name = "ttl"
    enabled        = true
  }

  tags = {
    Name        = "WebWaka WebSocket Connections"
    Environment = var.environment
    Project     = "WebWaka"
  }
}

# WebSocket API
resource "aws_apigatewayv2_api" "websocket" {
  name                       = "webwaka-websocket-${var.environment}"
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"

  tags = {
    Name        = "WebWaka WebSocket API"
    Environment = var.environment
    Project     = "WebWaka"
  }
}

# WebSocket API Stage
resource "aws_apigatewayv2_stage" "websocket" {
  api_id      = aws_apigatewayv2_api.websocket.id
  name        = var.environment
  auto_deploy = true

  default_route_settings {
    logging_level            = "INFO"
    data_trace_enabled       = true
    detailed_metrics_enabled = true
  }

  tags = {
    Name        = "WebWaka WebSocket Stage"
    Environment = var.environment
    Project     = "WebWaka"
  }
}

# IAM Role for WebSocket Lambda functions
resource "aws_iam_role" "websocket_lambda" {
  name = "webwaka-websocket-lambda-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "WebWaka WebSocket Lambda Role"
    Environment = var.environment
    Project     = "WebWaka"
  }
}

# IAM Policy for WebSocket Lambda functions
resource "aws_iam_role_policy" "websocket_lambda" {
  name = "websocket-lambda-policy"
  role = aws_iam_role.websocket_lambda.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan"
        ]
        Resource = aws_dynamodb_table.websocket_connections.arn
      },
      {
        Effect = "Allow"
        Action = [
          "execute-api:ManageConnections"
        ]
        Resource = "arn:aws:execute-api:${var.aws_region}:*:${aws_apigatewayv2_api.websocket.id}/*"
      }
    ]
  })
}

# CloudWatch Log Groups for WebSocket Lambda functions
resource "aws_cloudwatch_log_group" "websocket_connect" {
  name              = "/aws/lambda/webwaka-websocket-connect"
  retention_in_days = 7

  tags = {
    Name        = "WebWaka WebSocket Connect Logs"
    Environment = var.environment
    Project     = "WebWaka"
  }
}

resource "aws_cloudwatch_log_group" "websocket_disconnect" {
  name              = "/aws/lambda/webwaka-websocket-disconnect"
  retention_in_days = 7

  tags = {
    Name        = "WebWaka WebSocket Disconnect Logs"
    Environment = var.environment
    Project     = "WebWaka"
  }
}

resource "aws_cloudwatch_log_group" "websocket_default" {
  name              = "/aws/lambda/webwaka-websocket-default"
  retention_in_days = 7

  tags = {
    Name        = "WebWaka WebSocket Default Logs"
    Environment = var.environment
    Project     = "WebWaka"
  }
}

# Outputs
output "websocket_api_id" {
  description = "WebSocket API ID"
  value       = aws_apigatewayv2_api.websocket.id
}

output "websocket_api_endpoint" {
  description = "WebSocket API endpoint"
  value       = aws_apigatewayv2_api.websocket.api_endpoint
}

output "websocket_url" {
  description = "WebSocket connection URL"
  value       = "${replace(aws_apigatewayv2_api.websocket.api_endpoint, "wss://", "wss://")}/${aws_apigatewayv2_stage.websocket.name}"
}

output "dynamodb_connections_table" {
  description = "DynamoDB connections table name"
  value       = aws_dynamodb_table.websocket_connections.name
}
