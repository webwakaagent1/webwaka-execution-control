# IAM Policy for Lambda to generate presigned URLs for uploads bucket
resource "aws_iam_policy" "lambda_s3_uploads" {
  name        = "webwaka-lambda-s3-uploads-policy"
  description = "Allow Lambda to generate presigned URLs for uploads bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Resource = "${aws_s3_bucket.uploads.arn}/*"
      }
    ]
  })
}

# Attach the policy to the Lambda execution role
resource "aws_iam_role_policy_attachment" "lambda_s3_uploads" {
  policy_arn = aws_iam_policy.lambda_s3_uploads.arn
  role       = aws_iam_role.lambda_exec.name
}
