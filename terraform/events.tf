# EventBridge Event Bus
resource "aws_cloudwatch_event_bus" "webwaka" {
  name = "webwaka-event-bus-${var.environment}"

  tags = {
    Name        = "WebWaka Event Bus"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# SQS Queue for Event Processing
resource "aws_sqs_queue" "processing" {
  name                       = "webwaka-processing-queue-${var.environment}"
  visibility_timeout_seconds = 300
  message_retention_seconds  = 1209600 # 14 days
  receive_wait_time_seconds  = 20      # Long polling

  tags = {
    Name        = "WebWaka Processing Queue"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Dead Letter Queue for failed messages
resource "aws_sqs_queue" "processing_dlq" {
  name                      = "webwaka-processing-dlq-${var.environment}"
  message_retention_seconds = 1209600 # 14 days

  tags = {
    Name        = "WebWaka Processing DLQ"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Configure DLQ for main queue
resource "aws_sqs_queue_redrive_policy" "processing" {
  queue_url = aws_sqs_queue.processing.id

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.processing_dlq.arn
    maxReceiveCount     = 3
  })
}

# SQS Queue Policy to allow EventBridge to send messages
resource "aws_sqs_queue_policy" "processing" {
  queue_url = aws_sqs_queue.processing.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.processing.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_cloudwatch_event_rule.webwaka_events.arn
          }
        }
      }
    ]
  })
}

# EventBridge Rule to route events to SQS
resource "aws_cloudwatch_event_rule" "webwaka_events" {
  name           = "webwaka-events-rule-${var.environment}"
  description    = "Route WebWaka events to processing queue"
  event_bus_name = aws_cloudwatch_event_bus.webwaka.name

  event_pattern = jsonencode({
    source = ["com.webwaka.api"]
  })

  tags = {
    Name        = "WebWaka Events Rule"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# EventBridge Target to send events to SQS
resource "aws_cloudwatch_event_target" "sqs" {
  rule           = aws_cloudwatch_event_rule.webwaka_events.name
  event_bus_name = aws_cloudwatch_event_bus.webwaka.name
  target_id      = "webwaka-processing-queue"
  arn            = aws_sqs_queue.processing.arn
}

# Outputs
output "event_bus_name" {
  description = "Name of the EventBridge event bus"
  value       = aws_cloudwatch_event_bus.webwaka.name
}

output "event_bus_arn" {
  description = "ARN of the EventBridge event bus"
  value       = aws_cloudwatch_event_bus.webwaka.arn
}

output "processing_queue_url" {
  description = "URL of the processing queue"
  value       = aws_sqs_queue.processing.url
}

output "processing_queue_arn" {
  description = "ARN of the processing queue"
  value       = aws_sqs_queue.processing.arn
}
