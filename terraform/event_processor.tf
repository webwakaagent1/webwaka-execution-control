# IAM Role for Event Processor Lambda
resource "aws_iam_role" "event_processor" {
  name = "webwaka-event-processor-role"

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
    Name        = "webwaka-event-processor-role"
    Environment = var.environment
    Project     = "WebWaka"
  }
}

# Attach basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "event_processor_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.event_processor.name
}

# IAM Policy for Event Processor to read from SQS
resource "aws_iam_policy" "event_processor_sqs" {
  name        = "webwaka-event-processor-sqs-policy"
  description = "Allow Event Processor Lambda to read from SQS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = aws_sqs_queue.processing.arn
      }
    ]
  })
}

# Attach SQS policy to Event Processor role
resource "aws_iam_role_policy_attachment" "event_processor_sqs" {
  policy_arn = aws_iam_policy.event_processor_sqs.arn
  role       = aws_iam_role.event_processor.name
}

# Event Processor Lambda Function
resource "aws_lambda_function" "event_processor" {
  filename         = "${path.module}/../event-processor.zip"
  function_name    = "webwaka-event-processor"
  role            = aws_iam_role.event_processor.arn
  handler         = "index.handler"
  source_code_hash = filebase64sha256("${path.module}/../event-processor.zip")
  runtime         = "nodejs20.x"
  timeout         = 60
  memory_size     = 256

  environment {
    variables = {
      NODE_ENV = var.environment
    }
  }

  tags = {
    Name        = "webwaka-event-processor"
    Environment = var.environment
    Project     = "WebWaka"
  }
}

# CloudWatch Log Group for Event Processor
resource "aws_cloudwatch_log_group" "event_processor" {
  name              = "/aws/lambda/webwaka-event-processor"
  retention_in_days = 7

  tags = {
    Name        = "webwaka-event-processor-logs"
    Environment = var.environment
    Project     = "WebWaka"
  }
}

# SQS Event Source Mapping
resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.processing.arn
  function_name    = aws_lambda_function.event_processor.arn
  batch_size       = 10
  enabled          = true

  # Optional: Configure partial batch response
  function_response_types = ["ReportBatchItemFailures"]
}

# Output
output "event_processor_function_name" {
  description = "Name of the event processor Lambda function"
  value       = aws_lambda_function.event_processor.function_name
}

output "event_processor_function_arn" {
  description = "ARN of the event processor Lambda function"
  value       = aws_lambda_function.event_processor.arn
}
