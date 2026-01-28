# Bedrock Processor Lambda
resource "aws_lambda_function" "bedrock_processor" {
  filename         = "${path.module}/../bedrock-processor.zip"
  function_name    = "webwaka-bedrock-processor"
  role             = aws_iam_role.bedrock_processor.arn
  handler          = "index.handler"
  source_code_hash = filebase64sha256("${path.module}/../bedrock-processor.zip")
  runtime          = "nodejs20.x"
  timeout          = 60
  memory_size      = 512

  environment {
    variables = {
      EVENT_BUS_NAME = aws_cloudwatch_event_bus.webwaka.name
      AWS_REGION     = var.aws_region
    }
  }

  tags = {
    Name        = "WebWaka Bedrock Processor"
    Environment = var.environment
    Project     = "WebWaka"
  }
}

# IAM Role for Bedrock Processor
resource "aws_iam_role" "bedrock_processor" {
  name = "webwaka-bedrock-processor-${var.environment}"

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
    Name        = "WebWaka Bedrock Processor Role"
    Environment = var.environment
    Project     = "WebWaka"
  }
}

# IAM Policy for Bedrock Processor
resource "aws_iam_role_policy" "bedrock_processor" {
  name = "bedrock-processor-policy"
  role = aws_iam_role.bedrock_processor.id

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
          "bedrock:InvokeModel"
        ]
        Resource = "arn:aws:bedrock:us-east-1::foundation-model/*"
      },
      {
        Effect = "Allow"
        Action = [
          "events:PutEvents"
        ]
        Resource = aws_cloudwatch_event_bus.webwaka.arn
      },
      {
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = aws_sqs_queue.ai_requests.arn
      }
    ]
  })
}

# CloudWatch Log Group for Bedrock Processor
resource "aws_cloudwatch_log_group" "bedrock_processor" {
  name              = "/aws/lambda/webwaka-bedrock-processor"
  retention_in_days = 7

  tags = {
    Name        = "WebWaka Bedrock Processor Logs"
    Environment = var.environment
    Project     = "WebWaka"
  }
}

# SQS Queue for AI Requests
resource "aws_sqs_queue" "ai_requests" {
  name                       = "webwaka-ai-requests-${var.environment}"
  visibility_timeout_seconds = 90
  message_retention_seconds  = 3600

  tags = {
    Name        = "WebWaka AI Requests Queue"
    Environment = var.environment
    Project     = "WebWaka"
  }
}

# EventBridge Rule for AI Requests
resource "aws_cloudwatch_event_rule" "ai_requests" {
  name           = "webwaka-ai-requests-${var.environment}"
  event_bus_name = aws_cloudwatch_event_bus.webwaka.name

  event_pattern = jsonencode({
    source      = ["com.webwaka.api"]
    detail-type = ["ai.text.generation.requested"]
  })

  tags = {
    Name        = "WebWaka AI Requests Rule"
    Environment = var.environment
    Project     = "WebWaka"
  }
}

# EventBridge Target for AI Requests (to SQS)
resource "aws_cloudwatch_event_target" "ai_requests" {
  rule           = aws_cloudwatch_event_rule.ai_requests.name
  event_bus_name = aws_cloudwatch_event_bus.webwaka.name
  target_id      = "ai-requests-queue"
  arn            = aws_sqs_queue.ai_requests.arn
}

# SQS Queue Policy for EventBridge
resource "aws_sqs_queue_policy" "ai_requests" {
  queue_url = aws_sqs_queue.ai_requests.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.ai_requests.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_cloudwatch_event_rule.ai_requests.arn
          }
        }
      }
    ]
  })
}

# Lambda Event Source Mapping for Bedrock Processor
resource "aws_lambda_event_source_mapping" "bedrock_processor" {
  event_source_arn = aws_sqs_queue.ai_requests.arn
  function_name    = aws_lambda_function.bedrock_processor.arn
  batch_size       = 1
}

# Result Pusher Lambda
resource "aws_lambda_function" "result_pusher" {
  filename         = "${path.module}/../result-pusher.zip"
  function_name    = "webwaka-result-pusher"
  role             = aws_iam_role.result_pusher.arn
  handler          = "index.handler"
  source_code_hash = filebase64sha256("${path.module}/../result-pusher.zip")
  runtime          = "nodejs20.x"
  timeout          = 30

  environment {
    variables = {
      CONNECTIONS_TABLE  = aws_dynamodb_table.websocket_connections.name
      WEBSOCKET_ENDPOINT = "${replace(aws_apigatewayv2_api.websocket.api_endpoint, "wss://", "https://")}/${aws_apigatewayv2_stage.websocket.name}"
      AWS_REGION         = var.aws_region
    }
  }

  tags = {
    Name        = "WebWaka Result Pusher"
    Environment = var.environment
    Project     = "WebWaka"
  }
}

# IAM Role for Result Pusher
resource "aws_iam_role" "result_pusher" {
  name = "webwaka-result-pusher-${var.environment}"

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
    Name        = "WebWaka Result Pusher Role"
    Environment = var.environment
    Project     = "WebWaka"
  }
}

# IAM Policy for Result Pusher
resource "aws_iam_role_policy" "result_pusher" {
  name = "result-pusher-policy"
  role = aws_iam_role.result_pusher.id

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
          "dynamodb:GetItem"
        ]
        Resource = aws_dynamodb_table.websocket_connections.arn
      },
      {
        Effect = "Allow"
        Action = [
          "execute-api:ManageConnections"
        ]
        Resource = "arn:aws:execute-api:${var.aws_region}:*:${aws_apigatewayv2_api.websocket.id}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = aws_sqs_queue.ai_results.arn
      }
    ]
  })
}

# CloudWatch Log Group for Result Pusher
resource "aws_cloudwatch_log_group" "result_pusher" {
  name              = "/aws/lambda/webwaka-result-pusher"
  retention_in_days = 7

  tags = {
    Name        = "WebWaka Result Pusher Logs"
    Environment = var.environment
    Project     = "WebWaka"
  }
}

# SQS Queue for AI Results
resource "aws_sqs_queue" "ai_results" {
  name                       = "webwaka-ai-results-${var.environment}"
  visibility_timeout_seconds = 60
  message_retention_seconds  = 3600

  tags = {
    Name        = "WebWaka AI Results Queue"
    Environment = var.environment
    Project     = "WebWaka"
  }
}

# EventBridge Rule for AI Results
resource "aws_cloudwatch_event_rule" "ai_results" {
  name           = "webwaka-ai-results-${var.environment}"
  event_bus_name = aws_cloudwatch_event_bus.webwaka.name

  event_pattern = jsonencode({
    source      = ["com.webwaka.bedrock"]
    detail-type = ["ai.text.generation.succeeded"]
  })

  tags = {
    Name        = "WebWaka AI Results Rule"
    Environment = var.environment
    Project     = "WebWaka"
  }
}

# EventBridge Target for AI Results (to SQS)
resource "aws_cloudwatch_event_target" "ai_results" {
  rule           = aws_cloudwatch_event_rule.ai_results.name
  event_bus_name = aws_cloudwatch_event_bus.webwaka.name
  target_id      = "ai-results-queue"
  arn            = aws_sqs_queue.ai_results.arn
}

# SQS Queue Policy for AI Results
resource "aws_sqs_queue_policy" "ai_results" {
  queue_url = aws_sqs_queue.ai_results.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.ai_results.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_cloudwatch_event_rule.ai_results.arn
          }
        }
      }
    ]
  })
}

# Lambda Event Source Mapping for Result Pusher
resource "aws_lambda_event_source_mapping" "result_pusher" {
  event_source_arn = aws_sqs_queue.ai_results.arn
  function_name    = aws_lambda_function.result_pusher.arn
  batch_size       = 1
}
