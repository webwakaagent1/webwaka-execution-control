# AWS Bootstrap Configuration

**Status:** 🔒 CANON-LOCKED  
**Authority:** Founder  
**Created:** 2026-01-27  
**Environment:** Development

---

## 1. Purpose

This document contains the bootstrap configuration for the WebWaka platform's AWS infrastructure. This information is required to begin Phase 1 implementation.

⚠️ **SECURITY NOTE:** This document contains sensitive configuration information. In production, this should be stored in AWS Secrets Manager or a secure vault.

---

## 2. Domain Configuration

### 2.1. Development Domain

**Domain:** webwaka.site  
**Registrar:** Namesilo  
**Registrar Account:** webwaka.agent.1@gmail.com  
**Purpose:** Development environment

**DNS Strategy:**
- `dev.webwaka.site` — Development frontend
- `api.dev.webwaka.site` — Development API
- `*.dev.webwaka.site` — Development services

### 2.2. Production Domain (Future)

**Domain:** webwaka.com  
**Status:** To be configured in production phase  
**Purpose:** Production environment

**DNS Strategy:**
- `app.webwaka.com` — Production frontend
- `api.webwaka.com` — Production API
- `{partner-slug}.webwaka.com` — Partner-branded frontends

---

## 3. AWS Account Configuration

### 3.1. Development Account

**Account Email:** webwaka.agent.1@gmail.com  
**Account Type:** Development  
**Region:** af-south-1 (Africa - Cape Town)  
**Purpose:** Development and testing environment

**Why Africa - Cape Town (af-south-1)?**
- Lowest latency for Nigeria-based users
- Aligns with Nigeria-first design principle
- Supports all required AWS services (Cognito, Aurora, Fargate, Amplify, Bedrock, etc.)

### 3.2. Production Account (Future)

**Status:** To be created after successful Phase 1 completion  
**Purpose:** Production environment with separate billing and security boundaries

---

## 4. Budget Configuration

### 4.1. Development Budget

**Monthly Limit:** USD $200  
**Alert Thresholds:**
- 50% ($100) — Warning alert
- 75% ($150) — High alert
- 90% ($180) — Critical alert
- 100% ($200) — Budget exceeded

**Alert Recipients:**
- webwaka.agent.1@gmail.com

**Budget Actions:**
- At 100%: Send critical alert (manual review required)
- No automatic resource shutdown (to prevent development disruption)

### 4.2. Cost Optimization Strategy

**Free Tier Usage:**
- Maximize AWS Free Tier for first 12 months
- Aurora Serverless v2 (pay-per-use, scales to zero)
- Fargate Spot instances for non-critical workloads
- S3 Intelligent-Tiering for storage optimization

**Expected Monthly Costs (Development):**
- Aurora Serverless v2: $20-40
- Fargate: $30-50
- Amplify: $0-10 (Free Tier)
- Cognito: $0-5 (Free Tier)
- S3 + CloudFront: $5-15
- SES: $0-5 (Free Tier)
- Bedrock: $10-30 (usage-based)
- Other services: $10-20
- **Total Estimated:** $75-175/month

---

## 5. IAM Configuration

### 5.1. Deployment User

**Purpose:** Programmatic access for CI/CD deployments from GitHub Actions

**User Name:** `webwaka-deployment-user`

**Permissions Required:**
- Full access to ECS/Fargate (deploy backend)
- Full access to Amplify (deploy frontend)
- Full access to S3 (upload assets)
- Full access to CloudFront (invalidate cache)
- Read access to Secrets Manager (retrieve secrets)
- Full access to CloudWatch Logs (view logs)
- Full access to EventBridge (manage events)
- Full access to SQS (manage queues)

**Managed Policies:**
- `AmazonECS_FullAccess`
- `AWSAmplifyFullAccess`
- `AmazonS3FullAccess`
- `CloudFrontFullAccess`
- `SecretsManagerReadWrite`
- `CloudWatchLogsFullAccess`
- `AmazonEventBridgeFullAccess`
- `AmazonSQSFullAccess`

**Access Type:**
- Programmatic access (Access Key ID + Secret Access Key)
- No console access required

**Security:**
- Access keys stored in GitHub Secrets
- Keys rotated every 90 days
- MFA required for sensitive operations (manual)

### 5.2. Admin User (Founder)

**Purpose:** Console access for infrastructure management and monitoring

**User Name:** `webwaka-founder-admin`

**Permissions:**
- AdministratorAccess (full control)

**Access Type:**
- Console access (username + password)
- MFA required (recommended)

**Security:**
- Strong password (minimum 16 characters)
- MFA enabled (Google Authenticator or hardware token)
- Session timeout: 12 hours

---

## 6. Deployment Approval Process

### 6.1. Development Deployments

**Approval Required:** No (automatic deployment from `develop` branch)

**Process:**
1. Developer pushes to `develop` branch
2. GitHub Actions runs tests
3. If tests pass, automatically deploy to development environment
4. Notify team via Slack/email (optional)

### 6.2. Production Deployments (Future)

**Approval Required:** Yes (Founder approval)

**Process:**
1. Developer creates pull request from `develop` to `main`
2. Code review and approval
3. Merge to `main`
4. Founder reviews deployment plan
5. Founder approves deployment via GitHub issue comment
6. GitHub Actions deploys to production
7. Monitor deployment for errors
8. Rollback if critical issues detected

**Approval Format:**
```
/approve-deployment phase-N
```

---

## 7. Security Configuration

### 7.1. Root Account Security

**Root Account Email:** webwaka.agent.1@gmail.com

**Security Measures:**
- ✅ Strong password (16+ characters)
- ⏳ MFA enabled (to be configured in Phase 1)
- ⏳ Root access keys deleted (to be verified in Phase 1)
- ⏳ CloudTrail enabled (to be configured in Phase 1)
- ⏳ AWS Config enabled (to be configured in Phase 1)

### 7.2. IAM Best Practices

**Enforced Policies:**
- Require MFA for sensitive operations
- Enforce password complexity (minimum 16 characters)
- Rotate access keys every 90 days
- Use IAM roles for EC2/Fargate (no hardcoded credentials)
- Enable CloudTrail for audit logging
- Use AWS Secrets Manager for application secrets

---

## 8. Service Configuration

### 8.1. Service Availability and Cross-Region Architecture

**Primary Region:** af-south-1 (Africa - Cape Town)

**Why af-south-1?**
- Lowest latency for Nigeria-based users (~50-100ms)
- Aligns with Nigeria-first design principle (Assumption #8)
- Supports most required AWS services

**Service Availability in af-south-1:**

| Service | Available in af-south-1? | Notes |
|---------|--------------------------|-------|
| **Cognito** | ✅ Yes | User pool will be created in af-south-1 |
| **Aurora PostgreSQL** | ✅ Yes | Serverless v2 available |
| **Fargate** | ✅ Yes | ECS cluster will be in af-south-1 |
| **Amplify** | ✅ Yes | Global service, uses closest region |
| **SES** | ✅ Yes | Email sending available |
| **SNS** | ✅ Yes | Push notifications available |
| **S3** | ✅ Yes | Bucket will be in af-south-1 |
| **CloudFront** | ✅ Yes | Global CDN service |
| **EventBridge** | ✅ Yes | Event bus available |
| **SQS** | ✅ Yes | Message queues available |
| **Bedrock** | ❌ **NO** | **Not available in af-south-1** |
| **Secrets Manager** | ✅ Yes | Secrets storage available |
| **CloudWatch** | ✅ Yes | Monitoring and logging available |
| **Route 53** | ✅ Yes | Global DNS service |

**Cross-Region Architecture for Bedrock:**

Since AWS Bedrock is NOT available in af-south-1, we will use a cross-region architecture:

**Bedrock Region:** us-east-1 (N. Virginia)

**Why us-east-1?**
- Bedrock is available in us-east-1
- Largest AWS region with most services
- Stable and reliable

**Latency Implications:**
- Cross-region API calls from af-south-1 to us-east-1: ~200-300ms additional latency
- Total Bedrock API latency: ~500-800ms (including model inference time)

**Mitigation Strategies:**

1. **Asynchronous Processing:**
   - All Bedrock API calls will be asynchronous (non-blocking)
   - Use SQS queues to decouple Bedrock calls from user-facing requests
   - User receives immediate response, AI processing happens in background

2. **Caching:**
   - Cache common AI responses in Aurora or ElastiCache
   - Reduce Bedrock API calls for frequently requested operations
   - Cache TTL: 24 hours for static content, 1 hour for dynamic content

3. **Batch Processing:**
   - Group multiple AI requests into batches
   - Process batches during off-peak hours
   - Reduces per-request overhead

4. **Fallback Mechanisms:**
   - If Bedrock API fails or times out, use cached responses
   - Graceful degradation: Show "AI temporarily unavailable" message
   - Retry failed requests with exponential backoff

**Implementation Details:**

```python
# Example: Asynchronous Bedrock API call
import boto3
from botocore.config import Config

# Configure Bedrock client for us-east-1
bedrock_config = Config(
    region_name='us-east-1',
    connect_timeout=5,
    read_timeout=60,
    retries={'max_attempts': 3}
)

bedrock_client = boto3.client('bedrock-runtime', config=bedrock_config)

# All other services use af-south-1
default_config = Config(region_name='af-south-1')
cognito_client = boto3.client('cognito-idp', config=default_config)
aurora_client = boto3.client('rds', config=default_config)
```

**Cost Implications:**
- Cross-region data transfer: $0.02 per GB (af-south-1 → us-east-1)
- Estimated monthly cost: $5-10 (assuming 250-500 GB of AI request/response data)
- This is within the $200/month budget

**Alternative Considered:**
- Using OpenAI API instead of Bedrock: Rejected due to Assumption #1 (AWS-First)
- Using eu-west-1 for Bedrock: Rejected due to higher latency to Nigeria (~250ms vs ~200ms)

**Future Optimization:**
- If Bedrock becomes available in af-south-1, migrate immediately
- Monitor AWS service announcements for af-south-1 region updates

---

### 8.2. AWS Services to Provision (Phase 1)

| Service | Purpose | Configuration |
|---------|---------|---------------|
| **Cognito** | Authentication | User pool in af-south-1 |
| **Aurora PostgreSQL** | Database | Serverless v2, Multi-AZ |
| **Fargate** | Backend hosting | ECS cluster in af-south-1 |
| **Amplify** | Frontend hosting | Connected to GitHub |
| **SES** | Email | Verified domain: webwaka.site |
| **SNS** | Push notifications | Topic for user notifications |
| **S3** | File storage | Bucket: webwaka-dev-assets |
| **CloudFront** | CDN | Distribution for S3 bucket |
| **EventBridge** | Event routing | Default event bus |
| **SQS** | Message queues | Standard queues |
| **Bedrock** | AI models | Claude 3 Sonnet access |
| **Secrets Manager** | Secrets storage | Database credentials, API keys |

### 8.3. Service Limits

**Request Increases (if needed):**
- Fargate vCPU limit: Default 40 vCPUs (sufficient for development)
- Aurora connections: Default 100 (sufficient for development)
- SES sending limit: Request production access if needed

---

## 9. Monitoring & Alerting

### 9.1. CloudWatch Alarms

**Critical Alarms:**
- API error rate > 5%
- Database CPU > 80%
- Fargate service unhealthy
- Budget threshold exceeded

**Alert Destinations:**
- Email: webwaka.agent.1@gmail.com
- SNS topic: `webwaka-dev-alerts`

### 9.2. Logging

**Log Groups:**
- `/aws/ecs/webwaka-dev-api` — Backend API logs
- `/aws/amplify/webwaka-dev-web` — Frontend build logs
- `/aws/lambda/webwaka-dev-*` — Lambda function logs

**Retention:**
- Development: 7 days
- Production: 90 days (future)

---

## 10. Backup & Disaster Recovery

### 10.1. Database Backups

**Aurora Automated Backups:**
- Retention: 7 days
- Backup window: 02:00-04:00 UTC (low traffic period)
- Point-in-time recovery enabled

**Manual Snapshots:**
- Before major schema changes
- Before production deployments (future)

### 10.2. Recovery Objectives

**Development Environment:**
- RTO (Recovery Time Objective): 4 hours
- RPO (Recovery Point Objective): 1 hour

**Production Environment (Future):**
- RTO: 1 hour
- RPO: 5 minutes

---

## 11. Phase 1 Bootstrap Checklist

**Before starting Phase 1 implementation, verify:**

- [ ] AWS account accessible (webwaka.agent.1@gmail.com)
- [ ] Root account MFA enabled
- [ ] IAM deployment user created (`webwaka-deployment-user`)
- [ ] IAM admin user created (`webwaka-founder-admin`)
- [ ] Access keys generated for deployment user
- [ ] Access keys stored in secure location (GitHub Secrets)
- [ ] Budget alerts configured ($200 monthly limit)
- [ ] CloudTrail enabled for audit logging
- [ ] Domain webwaka.site accessible in Namesilo
- [ ] DNS hosted zone created in Route 53
- [ ] Region confirmed: af-south-1 (Africa - Cape Town)

---

## 12. Next Steps

**Phase 1 Implementation:**
1. Use this configuration to bootstrap AWS infrastructure
2. Follow `PHASE_1_EXECUTION_PROMPT.md` for step-by-step implementation
3. Provision all services listed in Section 8.1
4. Configure monitoring and alerting per Section 9
5. Verify all exit criteria in `EXECUTION_PHASES.md`

**Security Hardening:**
- Enable MFA on all IAM users
- Delete root access keys
- Enable AWS Config for compliance monitoring
- Set up AWS GuardDuty for threat detection

---

## 13. Document Updates

This document may only be updated by the Founder or with explicit Founder approval.

**Credentials Management:**
- Root credentials: Stored securely by Founder
- IAM credentials: Stored in GitHub Secrets (for deployment user)
- Database credentials: Stored in AWS Secrets Manager (to be created in Phase 1)

---

**End of AWS Bootstrap Configuration**
