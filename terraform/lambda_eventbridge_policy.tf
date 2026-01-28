# IAM Policy for Lambda to publish events to EventBridge
resource "aws_iam_policy" "lambda_eventbridge" {
  name        = "webwaka-lambda-eventbridge-policy"
  description = "Allow Lambda to publish events to EventBridge"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "events:PutEvents"
        ]
        Resource = aws_cloudwatch_event_bus.webwaka.arn
      }
    ]
  })
}

# Attach the policy to the Lambda execution role
resource "aws_iam_role_policy_attachment" "lambda_eventbridge" {
  policy_arn = aws_iam_policy.lambda_eventbridge.arn
  role       = aws_iam_role.lambda_exec.name
}
