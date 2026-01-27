# Foundational Assumptions Validation

**Status:** 🔒 CANON-LOCKED  
**Authority:** Founder  
**Created:** 2026-01-27  
**Purpose:** Document validation procedures for the 15 foundational assumptions

---

## 1. Purpose

This document defines how the 15 foundational assumptions are validated to ensure the WebWaka platform remains aligned with its core principles throughout all phases of development.

Validation is divided into two categories:
1. **Automated Validation** — Performed by `scripts/validate-assumptions.sh` in the phase-gate workflow
2. **Manual Verification** — Performed by the Independent Verification Manus (IVM) during phase completion audits

---

## 2. Automated Validation

The following assumptions can be automatically validated by the validation script:

### Assumption #1: AWS-First Architecture

**Validation Method:** Code scanning

**Checks:**
- ✅ Scans `package.json` for non-AWS services (Firebase, Supabase, Google Cloud, Azure, Heroku, Netlify, Vercel)
- ✅ Scans `requirements.txt` for non-AWS services
- ✅ Verifies presence of AWS service usage (Cognito, Aurora, Fargate, etc.)

**Pass Criteria:**
- No non-AWS services detected in dependencies
- At least one AWS service is configured (in Phase 1+)

**Failure Action:**
- Block merge to `main`
- Require removal of non-AWS services

---

### Assumption #4: PWA-First Design

**Validation Method:** File and code scanning

**Checks:**
- ✅ Verifies presence of `manifest.json` file
- ✅ Verifies service worker implementation in codebase

**Pass Criteria:**
- `manifest.json` exists (required in Phase 1+)
- Service worker code detected (required in Phase 1+)

**Failure Action:**
- Warning in Phase 0 (acceptable)
- Block merge in Phase 1+ if missing

---

### Assumption #5: Offline-First Capability

**Validation Method:** Code scanning

**Checks:**
- ✅ Verifies IndexedDB usage in codebase
- ✅ Verifies offline handling code (e.g., `navigator.onLine`)

**Pass Criteria:**
- IndexedDB usage detected (required in Phase 1+)
- Offline handling code detected (required in Phase 1+)

**Failure Action:**
- Warning in Phase 0 (acceptable)
- Block merge in Phase 1+ if missing

---

### Assumption #8: Nigeria-First Design

**Validation Method:** Configuration scanning

**Checks:**
- ✅ Verifies Nigeria-specific configuration (Naira currency, NGN, etc.)
- ✅ Verifies AWS region is `us-east-1` (US East - N. Virginia, closest to Nigeria)

**Pass Criteria:**
- AWS region is `us-east-1`
- Nigeria-specific configuration present (in Phase 1+)

**Failure Action:**
- Warning if us-east-1 not configured
- Block merge if wrong region is used

---

### Assumption #15: Absolute State Persistence

**Validation Method:** Git status checking

**Checks:**
- ✅ Verifies no uncommitted changes exist
- ✅ Verifies local branch is in sync with remote

**Pass Criteria:**
- `git diff` returns no changes
- Local branch is not ahead of remote

**Failure Action:**
- Block merge to `main`
- Require commit and push of all changes

---

## 3. Manual Verification

The following assumptions require manual verification by the IVM:

### Assumption #2: Founder-Centric Governance

**Verification Method:** Document review and process audit

**IVM Checks:**
- ✅ Founder approval mechanism is defined and followed
- ✅ All CANON-LOCKED documents have Founder authority
- ✅ Phase-gate workflow requires Founder approval
- ✅ No phase transitions occur without Founder approval

**Evidence Required:**
- GitHub issues with `founder-approved` label
- Git tags for phase approvals
- Execution ledger entries documenting Founder decisions

**Pass Criteria:**
- All phase transitions have Founder approval
- Governance documents clearly state Founder authority

---

### Assumption #3: Phase-Gated Execution

**Verification Method:** Process audit and workflow review

**IVM Checks:**
- ✅ Phase-gate workflow is implemented and active
- ✅ Phases are executed sequentially (no skipping)
- ✅ Each phase has clear entry and exit criteria
- ✅ Exit criteria are SMART (Specific, Measurable, Achievable, Relevant, Time-bound)

**Evidence Required:**
- `.github/workflows/phase-gate.yml` exists and is active
- Execution ledger shows sequential phase progression
- Exit criteria are documented in `EXECUTION_PHASES.md`

**Pass Criteria:**
- No evidence of phase-skipping
- All phases have SMART exit criteria

---

### Assumption #6: Extensibility-First Architecture

**Verification Method:** Code review and architecture audit

**IVM Checks:**
- ✅ Plug-in system is implemented (Phase 1)
- ✅ Core platform is decoupled from industry-specific logic
- ✅ New features can be added without modifying core code
- ✅ API is designed for extensibility

**Evidence Required:**
- Plug-in system documentation
- Code examples showing plug-in usage
- Architecture diagrams showing extensibility points

**Pass Criteria:**
- Plug-in system exists and is functional (Phase 1+)
- At least one example plug-in is implemented (Phase 1+)

---

### Assumption #7: Partner-Branded Multi-Tenancy

**Verification Method:** Architecture review and configuration audit

**IVM Checks:**
- ✅ Multi-tenancy is implemented at the database level
- ✅ Partner-specific branding is supported
- ✅ Data isolation between partners is enforced
- ✅ Partner subdomain routing is implemented

**Evidence Required:**
- Database schema with tenant isolation
- Partner configuration system
- Subdomain routing configuration

**Pass Criteria:**
- Multi-tenancy is implemented (Phase 2+)
- Partner branding is configurable (Phase 2+)

---

### Assumption #9: AI-Augmented Operations

**Verification Method:** Feature review and integration audit

**IVM Checks:**
- ✅ AWS Bedrock integration is implemented
- ✅ AI features are used for operations (e.g., smart matching, recommendations)
- ✅ AI usage is cost-conscious (caching, rate limiting)

**Evidence Required:**
- Bedrock API integration code
- AI feature documentation
- Cost optimization strategies

**Pass Criteria:**
- Bedrock integration exists (Phase 1+)
- At least one AI feature is implemented (Phase 1+)

---

### Assumption #10: Event-Driven Architecture

**Verification Method:** Architecture review and code audit

**IVM Checks:**
- ✅ EventBridge is configured and used
- ✅ Services communicate via events (not direct API calls)
- ✅ Event schemas are documented
- ✅ Event handlers are idempotent

**Evidence Required:**
- EventBridge configuration
- Event schema documentation
- Event handler code

**Pass Criteria:**
- EventBridge is configured (Phase 1+)
- Core workflows use event-driven patterns (Phase 1+)

---

### Assumption #11: Transactional Integrity

**Verification Method:** Code review and database audit

**IVM Checks:**
- ✅ Database transactions are used for multi-step operations
- ✅ Saga pattern is implemented for distributed transactions
- ✅ Rollback mechanisms are in place
- ✅ Data consistency is maintained

**Evidence Required:**
- Transaction handling code
- Saga implementation (if applicable)
- Error handling and rollback logic

**Pass Criteria:**
- All multi-step operations use transactions (Phase 1+)
- Saga pattern is implemented where needed (Phase 3+)

---

### Assumption #12: Security-First Design

**Verification Method:** Security audit and code review

**IVM Checks:**
- ✅ AWS Cognito is used for authentication
- ✅ IAM roles follow least privilege principle
- ✅ Secrets are stored in AWS Secrets Manager (not hardcoded)
- ✅ HTTPS is enforced for all endpoints
- ✅ Input validation is implemented
- ✅ SQL injection prevention is in place

**Evidence Required:**
- Cognito configuration
- IAM policy documents
- Secrets Manager usage
- Security best practices documentation

**Pass Criteria:**
- All authentication goes through Cognito (Phase 1+)
- No hardcoded secrets in codebase
- HTTPS is enforced

---

### Assumption #13: Observability-First Operations

**Verification Method:** Monitoring and logging audit

**IVM Checks:**
- ✅ CloudWatch Logs are configured for all services
- ✅ CloudWatch Alarms are set up for critical metrics
- ✅ Distributed tracing is implemented (X-Ray)
- ✅ Dashboards are created for key metrics

**Evidence Required:**
- CloudWatch configuration
- Alarm definitions
- Dashboard screenshots or configuration

**Pass Criteria:**
- All services log to CloudWatch (Phase 1+)
- Critical alarms are configured (Phase 1+)

---

### Assumption #14: Cost-Conscious Optimization

**Verification Method:** Cost analysis and architecture review

**IVM Checks:**
- ✅ Aurora Serverless v2 is used (scales to zero)
- ✅ Fargate Spot instances are used for non-critical workloads
- ✅ S3 Intelligent-Tiering is configured
- ✅ Budget alerts are configured
- ✅ Free Tier usage is maximized

**Evidence Required:**
- AWS service configuration
- Budget alert configuration
- Cost optimization documentation

**Pass Criteria:**
- Budget alerts are configured (Phase 0+)
- Cost-conscious services are used (Phase 1+)

---

## 4. Validation Workflow

### 4.1. Automated Validation (Every Merge)

1. Developer creates pull request to `main`
2. Phase-gate workflow runs automatically
3. Validation script (`scripts/validate-assumptions.sh`) executes
4. If validation fails, merge is blocked
5. Developer fixes issues and re-submits
6. If validation passes, merge is allowed (subject to other checks)

### 4.2. Manual Verification (Phase Completion)

1. Manus agent completes phase and marks it as "complete" in execution ledger
2. Founder assigns Independent Verification Manus (IVM)
3. IVM reviews all deliverables and verifies manual assumptions
4. IVM creates verification report documenting findings
5. If issues are found, IVM reports them to Founder
6. Manus agent addresses issues
7. IVM re-verifies after fixes
8. If verification passes, IVM recommends Founder approval
9. Founder reviews and approves (or rejects) the phase

---

## 5. Validation Frequency

| Validation Type | Frequency | Enforced By |
|-----------------|-----------|-------------|
| Automated validation | Every merge to `main` | GitHub Actions |
| Manual verification | End of each phase | IVM |
| Spot checks | Random (Founder discretion) | Founder |

---

## 6. Validation Exceptions

### 6.1. Phase 0 Exceptions

**Acceptable in Phase 0:**
- No PWA manifest or service worker (not yet implemented)
- No IndexedDB usage (not yet implemented)
- No AWS services configured (infrastructure not yet provisioned)
- No Nigeria-specific configuration (not yet implemented)

**Required in Phase 0:**
- Absolute State Persistence (all work pushed to GitHub)
- Governance documents align with assumptions

### 6.2. Emergency Exceptions

If an assumption must be temporarily violated due to an emergency (e.g., critical bug fix), the Founder may grant a temporary exception:

1. Founder creates a GitHub issue documenting the exception
2. Issue must include:
   - Reason for exception
   - Duration of exception
   - Plan to restore compliance
3. Exception is tracked in execution ledger
4. Compliance must be restored before the next phase approval

---

## 7. Validation Reporting

### 7.1. Automated Validation Report

The validation script outputs:
- ✅ Passed checks (green)
- ✗ Failed checks (red)
- ⚠ Warnings (yellow)

Example output:
```
✓ No non-AWS services detected
✗ PWA manifest.json not found
⚠ IndexedDB not detected (acceptable in Phase 0)
```

### 7.2. Manual Verification Report

The IVM creates a comprehensive report including:
- Summary of findings
- Detailed analysis of each assumption
- Evidence reviewed
- Issues identified (CRITICAL, HIGH, MEDIUM)
- Recommendations
- Approval recommendation (approve / reject / conditional approval)

Report template: `reports/phase-N-verification-report.md`

---

## 8. Continuous Improvement

### 8.1. Adding New Automated Checks

As the platform evolves, new automated checks can be added to `scripts/validate-assumptions.sh`:

1. Identify a manual check that can be automated
2. Implement the check in the validation script
3. Test the check on existing codebase
4. Update this document to reflect the new automated check
5. Update the IVM checklist to remove the manual check

### 8.2. Refining Manual Verification

IVM feedback is used to refine manual verification procedures:

1. IVM documents challenges or ambiguities in verification
2. Founder reviews feedback
3. This document is updated with clarifications
4. Future IVMs use the improved procedures

---

## 9. Compliance

**This document is CANON-LOCKED.** Any changes require explicit Founder approval.

**Enforcement:** Automated validation is enforced by the phase-gate workflow. Manual verification is enforced by the Founder approval process.

---

## 10. Related Documents

- `FOUNDATIONAL_ASSUMPTIONS.md` — The 15 assumptions being validated
- `scripts/validate-assumptions.sh` — Automated validation script
- `VERIFICATION_STRATEGY.md` — Overall verification strategy
- `EXECUTION_PHASES.md` — Phase definitions and exit criteria

---

**End of Assumption Validation Documentation**
