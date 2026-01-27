# Platform Infrastructure

**Status:** 🔒 CANON-LOCKED  
**Authority:** Founder  
**Created:** 2026-01-26 (Phase 0 Remediation)

---

## 1. Purpose

This document defines the critical infrastructure decisions for the WebWaka platform, including domain names, SSL certificate management, environment naming, and deployment strategy. These decisions are required before Phase 1 can begin.

---

## 2. Domain Strategy

### 2.1. Primary Domain

**Development Domain:** webwaka.site  
**Production Domain:** webwaka.com (to be configured after Phase 1)

**Domain Registrar:** Namesilo  
**Registrar Account:** webwaka.agent.1@gmail.com

**Current Focus:** Development environment using webwaka.site

**DNS Provider:** AWS Route 53 (recommended for AWS-first architecture)

### 2.2. Subdomain Strategy

**Format:** `{environment}.{service}.{domain}`

**Development Environment (webwaka.site):**
- `dev.webwaka.site` (development frontend)
- `api.dev.webwaka.site` (development API)
- `*.dev.webwaka.site` (development services)

**Production Environment (webwaka.com - future):**
- `app.webwaka.com` (production frontend)
- `api.webwaka.com` (production API)
- `{partner-slug}.webwaka.com` (partner-branded frontends)

**Partner Subdomains:**
- `{partner-slug}.webwaka.com` (partner-branded frontend)
- Example: `acmecorp.webwaka.com`

**Custom Domains (for partners):**
- Partners can optionally use their own custom domains (e.g., `platform.acmecorp.com`)
- Requires CNAME record pointing to WebWaka infrastructure

---

## 3. SSL/TLS Certificate Management

### 3.1. Certificate Provider

**Provider:** AWS Certificate Manager (ACM)

**Why:** Free, auto-renewing, integrates seamlessly with AWS services (CloudFront, ALB, API Gateway)

### 3.2. Certificate Strategy

**Wildcard Certificates:**
- `*.webwaka.com` (covers all subdomains)
- `*.{partner-slug}.webwaka.com` (if partner subdomains are nested)

**Custom Domain Certificates:**
- Partners using custom domains must provide their own SSL certificates (or use ACM with DNS validation)

### 3.3. Certificate Renewal

- **Auto-renewal:** ACM automatically renews certificates before expiry
- **Monitoring:** Set up CloudWatch alarms to alert if certificate expiry is approaching (failsafe)

---

## 4. Environment Strategy

### 4.1. Environment Definitions

| Environment | Purpose | Deployment Trigger | Data | Access |
|-------------|---------|-------------------|------|--------|
| **Development** | Active development and testing | Continuous deployment from `develop` branch | Synthetic/test data | All developers |
| **Staging** | Pre-production testing and QA | Manual deployment from `main` branch | Anonymized production data (optional) | QA team + developers |
| **Production** | Live platform serving real users | Manual deployment with Founder approval | Real user data | Restricted (Founder + designated operators) |

### 4.2. Environment Isolation

- **Separate AWS accounts** for each environment (recommended for maximum isolation)
- **Separate VPCs** if using a single AWS account
- **Separate databases** for each environment (no shared databases)
- **Separate S3 buckets** for each environment

### 4.3. Environment Configuration

**Environment Variables:**
- Each environment has its own `.env` file (never committed to Git)
- Use AWS Secrets Manager or AWS Systems Manager Parameter Store for production secrets

**Configuration Files:**
- `config/development.ts`
- `config/staging.ts`
- `config/production.ts`

---

## 5. Deployment Strategy

### 5.1. Deployment Pipeline

**Development:**
1. Developer pushes to `develop` branch
2. GitHub Actions runs tests and linter
3. If tests pass, automatically deploy to development environment
4. Notify team via Slack/email (optional)

**Staging:**
1. Developer creates pull request from `develop` to `main`
2. Code review and approval
3. Merge to `main`
4. Manual trigger to deploy to staging
5. QA team tests staging environment
6. If QA passes, proceed to production

**Production:**
1. Founder approves production deployment
2. Manual trigger to deploy to production
3. Monitor deployment for errors
4. Rollback if critical issues are detected

### 5.2. Deployment Tools

**Infrastructure as Code:** AWS CDK (TypeScript) or Terraform

**CI/CD:** GitHub Actions

**Deployment Method:**
- **Backend:** AWS Fargate (containerized)
- **Frontend:** AWS Amplify (static site hosting)
- **Database:** AWS Aurora (managed database)

### 5.3. Rollback Strategy

**Automated Rollback:**
- If health checks fail after deployment, automatically rollback to previous version

**Manual Rollback:**
- Founder or designated operator can manually trigger rollback via GitHub Actions

**Database Rollback:**
- Database migrations are versioned and can be rolled back using Prisma or custom scripts

---

## 6. Monitoring & Logging

### 6.1. Monitoring Tools

**AWS CloudWatch:**
- Application logs
- Infrastructure metrics (CPU, memory, network)
- Custom metrics (API latency, error rates)

**AWS X-Ray:**
- Distributed tracing for API requests
- Performance bottleneck identification

**AWS CloudWatch Alarms:**
- Alert on critical errors (e.g., API error rate > 5%)
- Alert on performance degradation (e.g., API latency > 2 seconds)

### 6.2. Log Aggregation

**Centralized Logging:**
- All application logs sent to CloudWatch Logs
- Structured logging (JSON format) for easy parsing

**Log Retention:**
- Development: 7 days
- Staging: 30 days
- Production: 90 days (or as required by compliance)

---

## 7. Backup & Disaster Recovery

### 7.1. Database Backups

**Automated Backups:**
- AWS Aurora automatic backups (daily snapshots)
- Retention: 7 days (development), 30 days (production)

**Manual Backups:**
- Before major deployments or schema changes

**Point-in-Time Recovery:**
- Enabled for production database (can restore to any point within retention period)

### 7.2. Disaster Recovery Plan

**Recovery Time Objective (RTO):** 4 hours (maximum downtime)

**Recovery Point Objective (RPO):** 1 hour (maximum data loss)

**Disaster Recovery Steps:**
1. Identify the failure (monitoring alerts)
2. Assess the impact (partial or total outage)
3. Restore from backup (database, infrastructure)
4. Verify data integrity
5. Resume operations
6. Post-mortem analysis

---

## 8. Security & Compliance

### 8.1. Network Security

**VPC Configuration:**
- Private subnets for backend services (no direct internet access)
- Public subnets for load balancers and NAT gateways
- Security groups restrict traffic to only necessary ports

**DDoS Protection:**
- AWS Shield Standard (included with AWS)
- AWS WAF (Web Application Firewall) for advanced protection

### 8.2. Data Encryption

**Encryption at Rest:**
- All databases encrypted using AWS KMS
- All S3 buckets encrypted using AWS KMS

**Encryption in Transit:**
- All API traffic uses HTTPS (TLS 1.2+)
- All internal service communication uses TLS

### 8.3. Compliance

**GDPR Compliance:**
- User data can be exported and deleted on request
- Data residency requirements met (if applicable)

**PCI-DSS Compliance (if handling payments):**
- Use AWS-compliant services (e.g., AWS Lambda, AWS RDS)
- Follow PCI-DSS best practices for payment processing

---

## 9. Cost Management

### 9.1. Cost Monitoring

**AWS Cost Explorer:**
- Track spending by service, environment, and tag
- Set up budgets and alerts for cost overruns

**Cost Allocation Tags:**
- Tag all resources with `Environment`, `Project`, `Owner`
- Enable cost tracking by environment

### 9.2. Cost Optimization

**Right-Sizing:**
- Regularly review instance sizes and adjust based on usage

**Reserved Instances:**
- Purchase reserved instances for production workloads (up to 75% savings)

**Auto-Scaling:**
- Enable auto-scaling for Fargate services to scale down during low traffic

---

## 10. Founder Decisions Required

**Founder Decisions Provided (2026-01-27):**

1. ✅ **Primary domain name:**
   - Development: webwaka.site
   - Production: webwaka.com (future)

2. ✅ **Domain registrar:** Namesilo (webwaka.agent.1@gmail.com)

3. ✅ **AWS account:** webwaka.agent.1@gmail.com (development account)

4. ✅ **AWS region:** us-east-1 (US East - N. Virginia)
   - Chosen for lowest latency to Nigeria
   - Aligns with Nigeria-first design principle

5. ✅ **Environment strategy:** Single AWS account for development; separate account for production (future)

6. ✅ **Deployment approval process:**
   - Development: Automatic deployment (no approval required)
   - Production: Founder approval required with clear guides

7. ✅ **Budget limits:** USD $200/month for development

**All required information has been provided. Phase 1 can begin.**

**Detailed configuration documented in:** `AWS_BOOTSTRAP_CONFIG.md`

---

## 11. Document Updates

This document may only be updated by the Founder or with explicit Founder approval.

---

**End of Platform Infrastructure**
