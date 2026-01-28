# Route53 Hosted Zone
# This must be created first before deploying frontend infrastructure

resource "aws_route53_zone" "main" {
  name    = "webwaka.site"
  comment = "WebWaka Platform hosted zone"

  tags = {
    Name        = "WebWaka Main Zone"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Output the nameservers
output "route53_nameservers" {
  description = "Nameservers for the Route53 hosted zone - configure these at your domain registrar"
  value       = aws_route53_zone.main.name_servers
}

output "route53_zone_id" {
  description = "Route53 hosted zone ID"
  value       = aws_route53_zone.main.zone_id
}
