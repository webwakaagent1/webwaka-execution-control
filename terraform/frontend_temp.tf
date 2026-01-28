# Temporary Frontend Configuration (Without CloudFront)
# This configuration uses S3 static website hosting directly
# CloudFront will be added once AWS account is verified

# S3 Bucket for Frontend
resource "aws_s3_bucket" "frontend" {
  bucket = "webwaka-frontend-${var.environment}"

  tags = {
    Name        = "WebWaka Frontend"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket for Frontend Website Configuration
resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# Make bucket publicly accessible for website hosting
resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "frontend_public_read" {
  bucket = aws_s3_bucket.frontend.id
  depends_on = [aws_s3_bucket_public_access_block.frontend]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.frontend.arn}/*"
      }
    ]
  })
}

# Output the S3 website URL
output "frontend_website_url" {
  description = "S3 website URL for the frontend (temporary, until CloudFront is enabled)"
  value       = aws_s3_bucket_website_configuration.frontend.website_endpoint
}

output "frontend_website_url_http" {
  description = "Full HTTP URL for the frontend"
  value       = "http://${aws_s3_bucket_website_configuration.frontend.website_endpoint}"
}
