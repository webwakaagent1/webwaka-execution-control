# Phase 1 Execution Prompt

**Phase:** 1 - Core Infrastructure  
**Status:** TEMPLATE (To be issued by Founder after Phase 0 approval)  
**Authority:** Founder

---

## Purpose

This document is the **execution prompt** for Phase 1. It will be issued by the Founder after Phase 0 is approved and all remediation is complete.

**DO NOT BEGIN PHASE 1 UNTIL THIS PROMPT IS OFFICIALLY ISSUED BY THE FOUNDER.**

---

## Phase 1 Scope

**Objective:** Establish the core AWS infrastructure and foundational services required for all subsequent phases.

**Duration:** 3-6 months (estimated)

**Deliverables:**
1. AWS account setup and configuration
2. AWS Cognito (Authentication)
3. AWS Aurora PostgreSQL (Database)
4. AWS Fargate (Backend Hosting)
5. AWS Amplify (Frontend Hosting)
6. AWS SES (Email)
7. AWS SNS (Push Notifications)
8. AWS S3 + CloudFront (Storage)
9. AWS EventBridge (Events)
10. AWS SQS (Queues)
11. AWS Bedrock (AI - cross-region in us-east-1)
12. Service Workers + IndexedDB (Offline)
13. PWA Manifest + Install Prompt
14. Extensibility Framework (Plug-in system)

---

## Entry Criteria

**Phase 1 may NOT begin until:**
1. ✅ Phase 0 is complete
2. ✅ Phase 0 independent verification passes
3. ✅ Phase 0 Founder approval is granted
4. ✅ All CRITICAL and HIGH-priority findings are remediated
5. ✅ This execution prompt is officially issued by the Founder

---

## Execution Instructions

### 1. AWS Account Information

**AWS credentials are stored in GitHub Secrets and will be automatically available to the deployment pipeline.**

**Provided by Founder (2026-01-27):**

- **AWS Account:** webwaka.agent.1@gmail.com
- **AWS Region (Primary):** us-east-1 (US East - N. Virginia)
- **AWS Region (Bedrock):** us-east-1 (N. Virginia) — Bedrock is NOT available in us-east-1
- **AWS Access Key ID:** Stored in GitHub Secret `AWS_ACCESS_KEY_ID`
- **AWS Secret Access Key:** Stored in GitHub Secret `AWS_SECRET_ACCESS_KEY`
- **AWS Account ID:** Stored in GitHub Secret `AWS_ACCOUNT_ID`

**IAM Setup:**
The Founder has completed (or will complete) the AWS IAM setup per `AWS_IAM_SETUP_GUIDE.md`, including:
- Root account MFA enabled
- IAM admin user created (`webwaka-founder-admin`)
- IAM deployment user created (`webwaka-deployment-user`)
- Budget alerts configured ($200/month)
- CloudTrail enabled for audit logging

**Security Note:**
- All AWS credentials are stored in GitHub Secrets (encrypted)
- Never commit credentials to GitHub in plain text
- Access credentials via environment variables in GitHub Actions:
  ```yaml
  env:
    AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
    AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    AWS_REGION: ${{ secrets.AWS_REGION }}
    AWS_ACCOUNT_ID: ${{ secrets.AWS_ACCOUNT_ID }}
  ```

**Cross-Region Architecture:**

**IMPORTANT:** AWS Bedrock is NOT available in us-east-1. You MUST use us-east-1 for Bedrock API calls.

**Implementation:**
- All services (Cognito, Aurora, Fargate, etc.) use us-east-1
- Bedrock API calls use us-east-1
- Bedrock calls MUST be asynchronous to mitigate cross-region latency (~200-300ms)
- Use SQS queues to decouple Bedrock calls from user-facing requests
- Implement caching for common AI responses

**Example:**
```python
import boto3
from botocore.config import Config

# Bedrock client (us-east-1)
bedrock_config = Config(region_name='us-east-1')
bedrock_client = boto3.client('bedrock-runtime', config=bedrock_config)

# All other services (us-east-1)
default_config = Config(region_name='us-east-1')
cognito_client = boto3.client('cognito-idp', config=default_config)
```

See `AWS_BOOTSTRAP_CONFIG.md` Section 8.1 for complete cross-region architecture details.

### 2. Repository Setup

**Create a new repository:**
- **Name:** `webwaka-platform`
- **Description:** WebWaka Platform - Core Infrastructure and Application Code
- **Visibility:** Private (recommended)
- **Initialize with:** README.md, .gitignore (Node.js), LICENSE (if applicable)

### 3. Technology Stack

**Backend:**
- **Language:** TypeScript
- **Runtime:** Node.js 22.x
- **Framework:** Fastify or Express
- **ORM:** Prisma
- **Database:** AWS Aurora PostgreSQL

**Frontend:**
- **Language:** TypeScript
- **Framework:** React 18+
- **Build Tool:** Vite
- **Styling:** TailwindCSS
- **State Management:** Zustand or Jotai

**Infrastructure:**
- **IaC Tool:** AWS CDK (TypeScript) or Terraform
- **CI/CD:** GitHub Actions
- **Monitoring:** AWS CloudWatch

### 4. Build Order (Phase 1 Sub-Phases)

**Phase 1.1: AWS Account Setup (Week 1)**
- Set up AWS account
- Configure IAM roles and policies
- Set up billing alerts
- Configure CloudWatch logging

**Phase 1.2: Database Infrastructure (Week 2-3)**
- Provision AWS Aurora PostgreSQL
- Configure VPC and security groups
- Set up database backups
- Create initial schema with Prisma

**Phase 1.3: Authentication (Week 4-5)**
- Set up AWS Cognito user pools
- Configure OAuth flows
- Implement authentication API
- Test authentication flow

**Phase 1.4: Backend API (Week 6-8)**
- Set up AWS Fargate
- Deploy backend API
- Implement health checks
- Configure auto-scaling

**Phase 1.5: Frontend Hosting (Week 9-10)**
- Set up AWS Amplify
- Deploy frontend application
- Configure custom domain (if applicable)
- Test deployment pipeline

**Phase 1.6: Email & Notifications (Week 11-12)**
- Set up AWS SES
- Set up AWS SNS
- Implement email templates
- Implement push notification service

**Phase 1.7: Storage & CDN (Week 13-14)**
- Set up AWS S3
- Configure CloudFront CDN
- Implement file upload API
- Test file delivery

**Phase 1.8: Event-Driven Architecture (Week 15-16)**
- Set up AWS EventBridge
- Set up AWS SQS
- Implement event publishing
- Implement event consumers

**Phase 1.9: PWA & Offline (Week 17-20)**
- Implement Service Workers
- Implement IndexedDB caching
- Create PWA manifest
- Implement install prompt
- Test offline functionality

**Phase 1.10: Integration & Testing (Week 21-24)**
- End-to-end integration testing
- Performance testing
- Security testing
- Documentation

### 5. Exit Criteria

**Phase 1 is complete when:**
1. All AWS services are provisioned and configured
2. Authentication flow works end-to-end
3. Backend API is deployed and accessible
4. Frontend is deployed and accessible
5. Email and push notifications work
6. File upload and delivery work
7. Event-driven architecture is functional
8. PWA is installable and works offline
9. All tests pass
10. All documentation is complete
11. Independent verification passes
12. Founder approval is granted

### 6. Verification

**Self-Verification:**
- Manus creates a Phase 1 Verification Report
- Report includes evidence of all exit criteria met
- Report includes test results and screenshots

**Independent Verification:**
- Founder requests independent verification from a separate Manus agent
- IVM reviews all artifacts and produces an independent verification report
- IVM identifies all findings (CRITICAL, HIGH, MEDIUM, LOW)

**Founder Approval:**
- Manus creates a GitHub Issue titled "Phase 1 Approval Request"
- Founder reviews and grants approval (or requests changes)

---

## Constraints

**MUST:**
- Use AWS-native services (per Foundational Assumption #1)
- Design for max-scale from day one (per Foundational Assumption #2)
- Make every surface PWA-installable (per Foundational Assumption #4)
- Implement offline-first for core actions (per Foundational Assumption #5)
- Follow all 15 foundational assumptions

**MUST NOT:**
- Use third-party SaaS services (except justified exceptions)
- Skip any sub-phases
- Proceed without AWS account information
- Commit AWS credentials to GitHub

---

## STOP Conditions

**Stop immediately and escalate if:**
- AWS account information is not provided
- Any foundational assumption is violated
- Any blocking issue is encountered
- Budget is exceeded (if applicable)
- Security vulnerability is discovered

---

## Notes

**This is a TEMPLATE. The Founder will issue the official Phase 1 Execution Prompt after Phase 0 is approved.**

---

**End of Phase 1 Execution Prompt (TEMPLATE)**
