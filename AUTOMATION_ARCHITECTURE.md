# WebWaka Automation Architecture

**Status:** 🔧 IMPLEMENTATION PLAN  
**Authority:** Manus Agent (with Founder approval)  
**Created:** 2026-01-27  
**Purpose:** Complete automation of AWS setup, EXECUTION_LEDGER, and Phase approvals

---

## 1. Executive Summary

This document outlines a comprehensive automation strategy to minimize manual work for the non-technical Founder. The automation covers:

1. **AWS Region Optimization** - Switch from `us-east-1` to `us-east-1` for full service availability
2. **AWS Infrastructure Automation** - Automated provisioning using Terraform with GitHub Actions
3. **EXECUTION_LEDGER Automation** - Automated phase tracking and status updates
4. **Founder Approval Automation** - Simple web-based approval dashboard (no GitHub knowledge required)
5. **Security Automation** - Automated credential rotation and secret management

**Key Principle:** The Founder should only need to:
- Approve phases via a simple web dashboard
- Provide 2FA codes when needed
- Review automated reports

---

## 2. AWS Region Change: us-east-1 → us-east-1

### 2.1. Rationale for Change

**Current Region:** `us-east-1` (Cape Town)
- ✅ Lower latency for Nigeria
- ❌ Limited service availability (missing services can block development)
- ❌ Higher costs for some services
- ❌ Fewer availability zones (only 3)

**Recommended Region:** `us-east-1` (N. Virginia)
- ✅ All AWS services available (including latest features)
- ✅ Lowest costs (AWS's primary region)
- ✅ 6 availability zones (better redundancy)
- ✅ Best documentation and community support
- ⚠️ Higher latency for Nigeria (~150-200ms vs ~50ms)

**Alternative:** `eu-west-1` (Ireland)
- ✅ All services available
- ✅ Moderate latency to Nigeria (~100ms)
- ✅ GDPR-compliant (if needed for European partners)
- ⚠️ Slightly higher costs than us-east-1

### 2.2. Latency Mitigation Strategy

Even with `us-east-1`, we can maintain good performance for Nigerian users:

1. **CloudFront CDN** - Cache static assets at edge locations (Lagos has a CloudFront PoP)
2. **Aurora Global Database** - Read replicas in `us-east-1` for low-latency reads
3. **S3 Transfer Acceleration** - Faster uploads from Nigeria
4. **API Gateway Edge-Optimized** - Route requests through nearest edge location
5. **Progressive Web App** - Offline-first design reduces server round-trips

**Expected User Experience:**
- Static assets: ~20-50ms (cached at Lagos edge)
- API calls: ~150-200ms (acceptable for business apps)
- Offline actions: 0ms (local-first)

### 2.3. Cost Comparison

| Service | us-east-1 | us-east-1 | Savings |
|---------|------------|-----------|---------|
| Aurora Serverless v2 | $0.12/ACU-hour | $0.12/ACU-hour | $0 |
| Fargate (1 vCPU, 2GB) | $0.04856/hour | $0.04048/hour | 17% |
| S3 Standard Storage | $0.023/GB | $0.023/GB | $0 |
| Data Transfer Out | $0.154/GB | $0.09/GB | 42% |
| CloudFront | Same pricing globally | Same | $0 |

**Estimated Monthly Savings:** $20-30 (10-15% of $200 budget)

### 2.4. Recommendation

**Use `us-east-1` for development** with CloudFront CDN for Nigerian users.

**Rationale:**
- Full service availability prevents development blockers
- Cost savings increase runway
- Latency is acceptable with CDN
- Can add `us-east-1` read replicas in production if needed

---

## 3. AWS Infrastructure Automation

### 3.1. Automation Goals

1. **Zero Manual AWS Console Work** - Everything via Infrastructure as Code (IaC)
2. **One-Click Provisioning** - Single GitHub Actions workflow deploys everything
3. **Automatic Rollback** - Failed deployments automatically roll back
4. **Cost Monitoring** - Automated budget alerts and cost reports

### 3.2. Technology Stack

**Infrastructure as Code:** Terraform (not AWS CDK)
- ✅ More mature and stable
- ✅ Better state management
- ✅ Cloud-agnostic (can add other clouds later)
- ✅ Better for multi-environment management

**CI/CD:** GitHub Actions
- ✅ Already integrated with repository
- ✅ Free for public repos (2,000 minutes/month for private)
- ✅ Native GitHub integration

**Secret Management:** AWS Secrets Manager + GitHub Secrets
- ✅ Automatic rotation
- ✅ Audit logging
- ✅ Fine-grained access control

### 3.3. Automated Workflows

#### Workflow 1: `aws-bootstrap.yml`
**Trigger:** Manual (Founder clicks "Run workflow" button)
**Purpose:** Initial AWS setup (runs once)
**Steps:**
1. Validate AWS credentials
2. Enable MFA on root account (interactive, requires Founder 2FA)
3. Create IAM admin user
4. Create IAM deployment user
5. Configure budget alerts
6. Enable CloudTrail
7. Create S3 bucket for Terraform state
8. Output credentials to GitHub Secrets

**Founder Action:** Click "Run workflow" and provide 2FA codes when prompted

#### Workflow 2: `terraform-plan.yml`
**Trigger:** Pull request to `main` branch
**Purpose:** Preview infrastructure changes
**Steps:**
1. Run `terraform plan`
2. Post plan output as PR comment
3. Estimate cost changes
4. Check for security issues

**Founder Action:** Review plan in PR comments

#### Workflow 3: `terraform-apply.yml`
**Trigger:** Push to `main` branch (after PR merge)
**Purpose:** Apply infrastructure changes
**Steps:**
1. Run `terraform apply`
2. Run smoke tests
3. Update EXECUTION_LEDGER.md
4. Post deployment report to GitHub issue
5. Send email notification to Founder

**Founder Action:** None (automatic after PR approval)

#### Workflow 4: `cost-report.yml`
**Trigger:** Daily at 9:00 AM (Founder's timezone)
**Purpose:** Monitor AWS costs
**Steps:**
1. Fetch AWS Cost Explorer data
2. Generate cost report
3. Compare to budget ($200/month)
4. Create GitHub issue if >80% of budget
5. Send email summary to Founder

**Founder Action:** Review daily email

### 3.4. Terraform Module Structure

```
terraform/
├── modules/
│   ├── networking/          # VPC, subnets, security groups
│   ├── database/            # Aurora PostgreSQL
│   ├── compute/             # Fargate, ECS
│   ├── storage/             # S3, CloudFront
│   ├── auth/                # Cognito
│   ├── monitoring/          # CloudWatch, X-Ray
│   └── budget/              # Budget alerts
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   └── prod/                # Future
└── backend.tf               # S3 backend for state
```

---

## 4. EXECUTION_LEDGER Automation

### 4.1. Current Problem

The `EXECUTION_LEDGER.md` is manually updated, which is:
- ❌ Error-prone (humans forget to update)
- ❌ Inconsistent (different agents use different formats)
- ❌ Not auditable (no automatic verification)

### 4.2. Automation Solution

**Approach:** Treat EXECUTION_LEDGER as a database, not a document.

#### Component 1: Ledger API (Python Script)
```python
# scripts/ledger.py
def update_phase_status(phase, status, actor, details):
    """Update ledger with new phase status"""
    
def get_current_phase():
    """Get current phase from ledger"""
    
def validate_phase_transition(from_phase, to_phase):
    """Ensure phases are not skipped"""
    
def record_approval(phase, issue_number, approver):
    """Record Founder approval"""
```

#### Component 2: GitHub Actions Integration

**Workflow: `update-ledger.yml`**
```yaml
name: Update Execution Ledger
on:
  workflow_call:
    inputs:
      phase:
        required: true
      status:
        required: true
      details:
        required: false

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - name: Update ledger
        run: |
          python scripts/ledger.py update \
            --phase "${{ inputs.phase }}" \
            --status "${{ inputs.status }}" \
            --details "${{ inputs.details }}"
      
      - name: Commit changes
        run: |
          git config user.name "WebWaka Bot"
          git config user.email "webwaka.agent.1@gmail.com"
          git add EXECUTION_LEDGER.md
          git commit -m "chore: update ledger - ${{ inputs.phase }} → ${{ inputs.status }}"
          git push
```

#### Component 3: Automatic Triggers

The ledger is automatically updated when:
1. ✅ PR is merged → Update phase status to "in_progress"
2. ✅ Terraform apply completes → Update phase status to "complete"
3. ✅ Verification report is created → Update phase status to "awaiting_approval"
4. ✅ Founder approves → Update phase status to "approved"

### 4.3. Ledger Validation

**Automated Checks:**
- ✅ Phase order is sequential (no skipping)
- ✅ All required fields are present
- ✅ Dates are in correct format
- ✅ Status transitions are valid
- ✅ Approval issues exist and have correct label

**Workflow: `validate-ledger.yml`**
- Runs on every commit
- Blocks PR if validation fails

---

## 5. Founder Approval Dashboard

### 5.1. Problem with Current Approach

The current approval process requires Founder to:
- ❌ Understand GitHub issues
- ❌ Know how to add labels
- ❌ Edit EXECUTION_LEDGER.md manually
- ❌ Understand git commits

**This is too technical for a non-technical Founder.**

### 5.2. Solution: Web-Based Approval Dashboard

**Technology:** Simple static website hosted on GitHub Pages
- ✅ No server required (free)
- ✅ Automatically deployed
- ✅ Mobile-friendly
- ✅ Secure (GitHub OAuth)

**URL:** `https://webwakaagent1.github.io/webwaka-approval-dashboard/`

### 5.3. Dashboard Features

#### Page 1: Current Phase Status
```
┌─────────────────────────────────────────┐
│  WebWaka Project Dashboard              │
├─────────────────────────────────────────┤
│  Current Phase: Phase 0                 │
│  Status: ✅ Complete (Awaiting Approval)│
│  Started: 2026-01-26                    │
│  Completed: 2026-01-27                  │
│                                          │
│  [View Details] [Approve Phase]         │
└─────────────────────────────────────────┘
```

#### Page 2: Phase Details
```
┌─────────────────────────────────────────┐
│  Phase 0: Execution Control             │
├─────────────────────────────────────────┤
│  Exit Criteria: 8/8 ✅                  │
│  ✅ All documents created               │
│  ✅ Independent verification passed     │
│  ✅ All blocking issues resolved        │
│  ...                                    │
│                                          │
│  Documents Created: 20+                 │
│  [View on GitHub]                       │
│                                          │
│  Verification Reports: 2                │
│  [View Report #1] [View Report #2]      │
│                                          │
│  [Approve Phase 0] [Request Changes]    │
└─────────────────────────────────────────┘
```

#### Page 3: Approval Confirmation
```
┌─────────────────────────────────────────┐
│  Approve Phase 0?                       │
├─────────────────────────────────────────┤
│  By approving, you confirm:             │
│  ✅ All exit criteria are met           │
│  ✅ All documents have been reviewed    │
│  ✅ Ready to proceed to Phase 1         │
│                                          │
│  Approval Code: ______                  │
│  (Check your email for code)            │
│                                          │
│  [Cancel] [Confirm Approval]            │
└─────────────────────────────────────────┘
```

### 5.4. Approval Flow

1. Founder receives email: "Phase 0 is ready for approval"
2. Founder clicks link in email → Opens dashboard
3. Founder reviews phase details
4. Founder clicks "Approve Phase"
5. System sends 2FA code to Founder's email
6. Founder enters code
7. System automatically:
   - Creates GitHub issue with `founder-approved` label
   - Updates EXECUTION_LEDGER.md
   - Commits changes
   - Triggers next phase workflow
   - Sends confirmation email

**Founder Action:** Click approve button and enter 2FA code (30 seconds)

---

## 6. Security Automation

### 6.1. Credential Rotation

**Problem:** The handover document contains exposed credentials.

**Solution:** Automated credential rotation

#### Workflow: `rotate-credentials.yml`
**Trigger:** Manual or scheduled (monthly)
**Steps:**
1. Generate new AWS access keys
2. Update GitHub Secrets
3. Deactivate old keys (after 24-hour grace period)
4. Rotate database passwords
5. Generate new API keys
6. Update AWS Secrets Manager
7. Send rotation report to Founder

### 6.2. Secret Management

**All secrets stored in:**
1. **AWS Secrets Manager** - For application secrets
2. **GitHub Secrets** - For CI/CD secrets
3. **Never in code or documents**

**Automated Secret Injection:**
- Terraform reads from AWS Secrets Manager
- GitHub Actions reads from GitHub Secrets
- Applications read from AWS Secrets Manager at runtime

---

## 7. Implementation Plan

### Phase 1: Foundation (Day 1)
1. ✅ Create this architecture document
2. ⏳ Update FOUNDATIONAL_ASSUMPTIONS.md (change region to us-east-1)
3. ⏳ Update AWS_BOOTSTRAP_CONFIG.md (change region to us-east-1)
4. ⏳ Create Terraform module structure
5. ⏳ Create ledger automation scripts
6. ⏳ Commit all changes

### Phase 2: AWS Bootstrap Automation (Day 2)
1. ⏳ Create `aws-bootstrap.yml` workflow
2. ⏳ Test with Founder's AWS account
3. ⏳ Verify IAM users are created correctly
4. ⏳ Verify budget alerts work
5. ⏳ Store credentials in GitHub Secrets

### Phase 3: Terraform Infrastructure (Day 3)
1. ⏳ Write Terraform modules (networking, database, compute, etc.)
2. ⏳ Create `terraform-plan.yml` workflow
3. ⏳ Create `terraform-apply.yml` workflow
4. ⏳ Test in dev environment
5. ⏳ Document for Founder

### Phase 4: Ledger Automation (Day 4)
1. ⏳ Write `scripts/ledger.py`
2. ⏳ Create `update-ledger.yml` workflow
3. ⏳ Create `validate-ledger.yml` workflow
4. ⏳ Integrate with other workflows
5. ⏳ Test automatic updates

### Phase 5: Approval Dashboard (Day 5)
1. ⏳ Create approval dashboard repository
2. ⏳ Build dashboard UI (HTML/CSS/JS)
3. ⏳ Integrate with GitHub API
4. ⏳ Add 2FA approval flow
5. ⏳ Deploy to GitHub Pages
6. ⏳ Test with Founder

### Phase 6: Testing & Documentation (Day 6)
1. ⏳ End-to-end testing of all workflows
2. ⏳ Create Founder quick-start guide
3. ⏳ Record demo videos
4. ⏳ Update all documentation
5. ⏳ Request Founder approval

---

## 8. Success Metrics

**Automation is successful if:**
1. ✅ Founder can approve phases in <1 minute (vs 30+ minutes manually)
2. ✅ EXECUTION_LEDGER updates automatically (0 manual edits)
3. ✅ AWS infrastructure provisions in <10 minutes (vs hours manually)
4. ✅ Zero AWS Console access required by Founder
5. ✅ All credentials are rotated automatically
6. ✅ Founder receives daily cost reports (no surprises)
7. ✅ Phase transitions are validated automatically (no skipping)

---

## 9. Founder Approval Required

**This automation plan requires Founder approval for:**
1. ✅ Region change: `us-east-1` → `us-east-1`
2. ✅ Use of Terraform for infrastructure
3. ✅ Creation of approval dashboard
4. ✅ Automated credential rotation
5. ✅ Daily cost report emails

**Approval Method:** 
- Founder reviews this document
- Founder approves via approval dashboard (once built)
- OR Founder replies "approved" in chat

---

## 10. Next Steps

**Immediate Actions:**
1. ⏳ Get Founder approval for this automation plan
2. ⏳ Update region in all documents
3. ⏳ Begin implementation (Phase 1)

**Timeline:**
- Day 1-2: Foundation + AWS Bootstrap
- Day 3-4: Terraform + Ledger Automation  
- Day 5-6: Approval Dashboard + Testing
- Day 7: Founder approval + Phase 1 kickoff

**Total Time:** 7 days to full automation

---

**END OF AUTOMATION ARCHITECTURE**
