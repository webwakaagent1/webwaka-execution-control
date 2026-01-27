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
**Region:** us-east-1 (US East - N. Virginia)  
**Purpose:** Development and testing environment

**Why US East (us-east-1)?**
- All AWS services available (no development blockers)
- Lower costs (10-15% savings vs us-east-1)
- Best documentation and community support
- CloudFront CDN provides edge caching in Lagos for low-latency static assets
- Acceptable API latency (150-200ms) for business application use case
- Offline-first design minimizes server dependency

**Founder Decision:** Approved on 2026-01-27 (see FOUNDER_DECISION_AWS_REGION.md)

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

**Primary Region:** us-east-1 (US East - N. Virginia)

**Why us-east-1?**
- All AWS services available (including Bedrock, latest features)
- Lower costs compared to other regions
- CloudFront CDN provides edge caching in Lagos for Nigerian users
- Acceptable latency for business applications (150-200ms for API calls)
- Offline-first design minimizes impact of latency

**Service Availability in us-east-1:**

| Service | Available in us-east-1? | Notes |
|---------|--------------------------|-------|
| **Cognito** | ✅ Yes | User pool will be created in us-east-1 |
| **Aurora PostgreSQL** | ✅ Yes | Serverless v2 available |
| **Fargate** | ✅ Yes | ECS cluster will be in us-east-1 |
| **Amplify** | ✅ Yes | Global service, uses closest region |
| **SES** | ✅ Yes | Email sending available |
| **SNS** | ✅ Yes | Push notifications available |
| **S3** | ✅ Yes | Bucket will be in us-east-1 |
| **CloudFront** | ✅ Yes | Global CDN with Lagos edge location |
| **EventBridge** | ✅ Yes | Event bus available |
| **SQS** | ✅ Yes | Message queues available |
| **Bedrock** | ✅ Yes | All models available |
| **Secrets Manager** | ✅ Yes | Secrets storage available |
| **CloudWatch** | ✅ Yes | Monitoring and logging available |
| **Route 53** | ✅ Yes | Global DNS service |

**CloudFront CDN Strategy for Nigerian Users:**

Since the primary region is us-east-1, we will use CloudFront CDN to provide low-latency access for Nigerian users:

**CloudFront Configuration:**
- **Origin:** S3 bucket in us-east-1 (for static assets)
- **Edge Location:** Lagos, Nigeria (CloudFront PoP available)
- **Cache Behavior:** Aggressive caching for static assets (24-hour TTL)

**Performance Characteristics:**

| Asset Type | Latency from Nigeria | Notes |
|------------|---------------------|-------|
| Static Assets (CSS, JS, images) | ~20-50ms | Cached at Lagos edge |
| API Calls (dynamic data) | ~150-200ms | Direct to us-east-1 |
| Offline Actions | 0ms | Local-first PWA |
| Bedrock AI Calls | ~300-500ms | Asynchronous, non-blocking |

**Mitigation Strategies for API Latency:**

1. **Offline-First Design:**
   - Core actions work offline (POS, lead capture, inventory)
   - Sync happens in background
   - User never waits for server

2. **Aggressive Caching:**
   - Cache API responses in service worker
   - Cache TTL: 5 minutes for dynamic data, 24 hours for static data
   - Reduces server round-trips

3. **Asynchronous AI Processing:**
   - All Bedrock API calls are asynchronous
   - Use SQS queues to decouple AI from user requests
   - User receives immediate response, AI processes in background

4. **Optimistic UI Updates:**
   - Update UI immediately (assume success)
   - Sync to server in background
   - Rollback if server rejects

**Implementation Details:**

```python
# Example: All services in us-east-1
import boto3
from botocore.config import Config

# Configure all clients for us-east-1
default_config = Config(region_name='us-east-1')

bedrock_client = boto3.client('bedrock-runtime', config=default_config)
cognito_client = boto3.client('cognito-idp', config=default_config)
aurora_client = boto3.client('rds', config=default_config)
s3_client = boto3.client('s3', config=default_config)
```

**Cost Implications:**
- CloudFront data transfer: $0.085 per GB (first 10 TB)
- Estimated monthly cost: $10-15 (assuming 100-200 GB of static assets)
- No cross-region data transfer costs (all services in us-east-1)
- Total savings vs us-east-1: ~$20-30/month

**Future Optimization:**
- Monitor actual latency metrics from Nigerian users
- Consider Aurora Global Database with read replicas in us-east-1 if needed
- Evaluate cost/performance tradeoff based on real data

---

### 8.2. AWS Services to Provision (Phase 1)

| Service | Purpose | Configuration |
|---------|---------|---------------|
| **Cognito** | Authentication | User pool in us-east-1 |
| **Aurora PostgreSQL** | Database | Serverless v2, Multi-AZ |
| **Fargate** | Backend hosting | ECS cluster in us-east-1 |
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
- [ ] Region confirmed: us-east-1 (US East - N. Virginia)

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
