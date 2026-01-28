# Email & Notifications Infrastructure
# AWS SES for transactional emails and AWS SNS for push notifications

# SES Domain Identity
resource "aws_ses_domain_identity" "webwaka" {
  domain = "webwaka.site"
}

# SES Domain Verification Record
resource "aws_route53_record" "ses_verification" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "_amazonses.${aws_ses_domain_identity.webwaka.domain}"
  type    = "TXT"
  ttl     = 600
  records = [aws_ses_domain_identity.webwaka.verification_token]
}

# SES Domain DKIM Records
resource "aws_ses_domain_dkim" "webwaka" {
  domain = aws_ses_domain_identity.webwaka.domain
}

resource "aws_route53_record" "ses_dkim" {
  count   = 3
  zone_id = aws_route53_zone.main.zone_id
  name    = "${element(aws_ses_domain_dkim.webwaka.dkim_tokens, count.index)}._domainkey.${aws_ses_domain_identity.webwaka.domain}"
  type    = "CNAME"
  ttl     = 600
  records = ["${element(aws_ses_domain_dkim.webwaka.dkim_tokens, count.index)}.dkim.amazonses.com"]
}

# SNS Topic for Notifications
resource "aws_sns_topic" "webwaka_notifications" {
  name         = "webwaka-notifications-${var.environment}"
  display_name = "WebWaka Platform Notifications"

  tags = {
    Name        = "WebWaka Notifications"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# SNS Topic Policy (allow Lambda to publish)
resource "aws_sns_topic_policy" "webwaka_notifications" {
  arn = aws_sns_topic.webwaka_notifications.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = [
          "SNS:Publish",
          "SNS:Subscribe"
        ]
        Resource = aws_sns_topic.webwaka_notifications.arn
      }
    ]
  })
}

# IAM Policy for Lambda to use SES and SNS
resource "aws_iam_policy" "lambda_ses_sns" {
  name        = "webwaka-lambda-ses-sns-${var.environment}"
  description = "Allow Lambda to send emails via SES and publish to SNS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ses:SendEmail",
          "ses:SendRawEmail"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = aws_sns_topic.webwaka_notifications.arn
      }
    ]
  })
}

# Attach SES/SNS policy to Lambda execution role
resource "aws_iam_role_policy_attachment" "lambda_ses_sns" {
  role       = aws_iam_role.lambda_execution.name
  policy_arn = aws_iam_policy.lambda_ses_sns.arn
}

# Outputs
output "ses_domain_identity_arn" {
  description = "ARN of the SES domain identity"
  value       = aws_ses_domain_identity.webwaka.arn
}

output "ses_verification_token" {
  description = "SES domain verification token"
  value       = aws_ses_domain_identity.webwaka.verification_token
}

output "ses_dkim_tokens" {
  description = "SES DKIM tokens for domain verification"
  value       = aws_ses_domain_dkim.webwaka.dkim_tokens
}

output "sns_topic_arn" {
  description = "ARN of the SNS notifications topic"
  value       = aws_sns_topic.webwaka_notifications.arn
}

output "sns_topic_name" {
  description = "Name of the SNS notifications topic"
  value       = aws_sns_topic.webwaka_notifications.name
}
