# Execution Ledger Standards

**Status:** 🔒 CANON-LOCKED  
**Authority:** Founder  
**Created:** 2026-01-27  
**Purpose:** Define the structure and format of the Execution Ledger

---

## 1. Purpose

This document defines the mandatory structure and format for the **Execution Ledger** (`EXECUTION_LEDGER.md`). The ledger is the single source of truth for tracking phase progress, approval status, and execution history.

The ledger must be **machine-readable** to enable automated phase-gate enforcement via GitHub Actions.

---

## 2. Mandatory Structure

The `EXECUTION_LEDGER.md` file MUST contain:

1. **YAML Front Matter** (machine-readable metadata)
2. **Execution History** (human-readable chronological log)

---

## 3. YAML Front Matter Format

The YAML front matter MUST be enclosed in `---` delimiters at the top of the file and contain the following mandatory fields:

```yaml
---
current_phase: "Phase N"
phase_status: "in_progress" | "complete" | "approved"
approval_issue_number: null | "#42"
last_updated: "YYYY-MM-DD"
---
```

### 3.1. Field Definitions

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `current_phase` | String | ✅ Yes | The phase currently being executed (e.g., "Phase 0", "Phase 1") |
| `phase_status` | Enum | ✅ Yes | Status of the current phase: `in_progress`, `complete`, or `approved` |
| `approval_issue_number` | String or null | ✅ Yes | GitHub issue number with `founder-approved` label (e.g., "#42"), or `null` if not yet approved |
| `last_updated` | Date | ✅ Yes | Date of last ledger update in `YYYY-MM-DD` format |

### 3.2. Phase Status Values

| Status | Meaning |
|--------|---------|
| `in_progress` | Phase is currently being implemented |
| `complete` | Phase implementation is complete, awaiting independent verification and Founder approval |
| `approved` | Phase has been verified and approved by Founder via GitHub issue |

### 3.3. Example YAML Front Matter

**Phase in progress:**
```yaml
---
current_phase: "Phase 1"
phase_status: "in_progress"
approval_issue_number: null
last_updated: "2026-01-27"
---
```

**Phase complete, awaiting approval:**
```yaml
---
current_phase: "Phase 1"
phase_status: "complete"
approval_issue_number: null
last_updated: "2026-02-15"
---
```

**Phase approved:**
```yaml
---
current_phase: "Phase 1"
phase_status: "approved"
approval_issue_number: "#5"
last_updated: "2026-02-20"
---
```

---

## 4. Execution History Format

After the YAML front matter, the ledger MUST contain a chronological log of all significant execution events.

### 4.1. Entry Format

Each entry MUST follow this format:

```markdown
### [YYYY-MM-DD] Event Title

**Phase:** Phase N  
**Status:** in_progress | complete | approved  
**Actor:** Founder | Manus Agent | IVM  

Description of the event, including:
- What was accomplished
- Any decisions made
- Links to relevant commits, issues, or documents
```

### 4.2. Example Execution History

```markdown
## Execution History

### [2026-01-27] Phase 0 Initiated

**Phase:** Phase 0  
**Status:** in_progress  
**Actor:** Manus Agent  

Phase 0 (Execution Control & Governance) has been initiated. All governance documents are being created.

**Deliverables:**
- FOUNDATIONAL_ASSUMPTIONS.md
- GOVERNANCE.md
- EXECUTION_PHASES.md
- VERIFICATION_STRATEGY.md

---

### [2026-01-27] Phase 0 Remediation Completed

**Phase:** Phase 0  
**Status:** complete  
**Actor:** Manus Agent  

All 18 blocking issues from the Independent Verification Report have been resolved.

**Commits:**
- c854be7: Fix CRITICAL #1 and #2
- ba74c3b: Fix 6 HIGH-priority issues
- e77606f: Add final completion report

**Documents Created:**
- AWS_BOOTSTRAP_CONFIG.md
- AWS_IAM_SETUP_GUIDE.md
- REPOSITORY_STANDARDS.md
- PLATFORM_INFRASTRUCTURE.md

---

### [2026-01-28] Phase 0 Approved by Founder

**Phase:** Phase 0  
**Status:** approved  
**Actor:** Founder  

Phase 0 has been approved by the Founder after successful independent verification.

**Approval Issue:** #3  
**IVM Report:** reports/phase-0-verification-report.md  
**Next Phase:** Phase 1 (Core Infrastructure)
```

---

## 5. Phase Transition Rules

### 5.1. Starting a New Phase

When starting a new phase:

1. Update `current_phase` to the new phase (e.g., "Phase 1")
2. Set `phase_status` to `"in_progress"`
3. Set `approval_issue_number` to `null`
4. Update `last_updated` to the current date
5. Add an execution history entry documenting the phase start

### 5.2. Completing a Phase

When a phase is technically complete:

1. Set `phase_status` to `"complete"`
2. Update `last_updated` to the current date
3. Add an execution history entry documenting the completion
4. Request independent verification from IVM

### 5.3. Approving a Phase

When the Founder approves a phase:

1. Set `phase_status` to `"approved"`
2. Set `approval_issue_number` to the GitHub issue number (e.g., `"#5"`)
3. Update `last_updated` to the current date
4. Add an execution history entry documenting the approval

---

## 6. Automated Phase-Gate Enforcement

The phase-gate workflow (`.github/workflows/phase-gate.yml`) MUST:

1. **Parse the YAML front matter** from `EXECUTION_LEDGER.md`
2. **Extract the current phase** from the `current_phase` field
3. **Verify sequential phase order:**
   - If current phase is "Phase N", verify that "Phase N-1" is marked as `"approved"` in the execution history
4. **Check for Founder approval:**
   - If `phase_status` is `"complete"` or `"approved"`, verify that `approval_issue_number` is not `null`
   - Verify that the GitHub issue exists and has the `founder-approved` label
5. **Block merges** if any verification fails

---

## 7. Validation Rules

### 7.1. YAML Front Matter Validation

The phase-gate workflow MUST validate:

- ✅ YAML front matter exists and is valid YAML
- ✅ All 4 mandatory fields are present
- ✅ `current_phase` matches the pattern `"Phase N"` where N is 0-5
- ✅ `phase_status` is one of: `"in_progress"`, `"complete"`, `"approved"`
- ✅ `approval_issue_number` is either `null` or matches the pattern `"#N"` where N is a number
- ✅ `last_updated` is a valid date in `YYYY-MM-DD` format

### 7.2. Phase Transition Validation

The phase-gate workflow MUST validate:

- ✅ Phase transitions are sequential (cannot skip from Phase 0 to Phase 2)
- ✅ Previous phase is marked as `"approved"` before starting the next phase
- ✅ Approval issue exists and has the `founder-approved` label

---

## 8. Example Complete Ledger

```markdown
---
current_phase: "Phase 1"
phase_status: "in_progress"
approval_issue_number: null
last_updated: "2026-01-28"
---

# Execution Ledger

**Purpose:** Track phase progress, approval status, and execution history for the WebWaka platform.

**Authority:** This ledger is the single source of truth for phase status. Only the Founder or authorized Manus agents may update it.

---

## Current Phase Status

**Phase:** Phase 1 — Core Infrastructure  
**Status:** In Progress  
**Started:** 2026-01-28  
**Expected Completion:** 2026-04-28  

---

## Execution History

### [2026-01-27] Phase 0 Initiated

**Phase:** Phase 0  
**Status:** in_progress  
**Actor:** Manus Agent  

Phase 0 (Execution Control & Governance) has been initiated.

---

### [2026-01-27] Phase 0 Remediation Completed

**Phase:** Phase 0  
**Status:** complete  
**Actor:** Manus Agent  

All 18 blocking issues from the Independent Verification Report have been resolved.

**Commits:** c854be7, ba74c3b, e77606f

---

### [2026-01-28] Phase 0 Approved by Founder

**Phase:** Phase 0  
**Status:** approved  
**Actor:** Founder  

Phase 0 has been approved by the Founder after successful independent verification.

**Approval Issue:** #3

---

### [2026-01-28] Phase 1 Initiated

**Phase:** Phase 1  
**Status:** in_progress  
**Actor:** Manus Agent  

Phase 1 (Core Infrastructure) has been initiated. AWS infrastructure provisioning will begin.

**Deliverables:**
- AWS Cognito user pool
- AWS Aurora PostgreSQL database
- AWS Fargate ECS cluster
- AWS Amplify frontend hosting
- PWA with offline support
- Extensibility framework

---

## Phase Approval History

| Phase | Status | Approval Issue | Approval Date |
|-------|--------|----------------|---------------|
| Phase 0 | ✅ Approved | #3 | 2026-01-28 |
| Phase 1 | ⏳ In Progress | — | — |
| Phase 2 | ⏸️ Not Started | — | — |
| Phase 3 | ⏸️ Not Started | — | — |
| Phase 4 | ⏸️ Not Started | — | — |
| Phase 5 | ⏸️ Not Started | — | — |

---

**End of Execution Ledger**
```

---

## 9. Ledger Update Responsibilities

### 9.1. Manus Agent Responsibilities

The implementing Manus agent MUST:

- Update the ledger when starting a new phase
- Update the ledger when completing a phase
- Add execution history entries for significant milestones
- Update `last_updated` with every change

### 9.2. Founder Responsibilities

The Founder MUST:

- Update the ledger when approving a phase
- Set `approval_issue_number` to the approved GitHub issue
- Verify ledger accuracy before granting approval

### 9.3. IVM Responsibilities

The Independent Verification Manus (IVM) MUST:

- Verify ledger accuracy as part of phase verification
- Report any ledger inconsistencies in the verification report

---

## 10. Compliance

**This document is CANON-LOCKED.** Any changes require explicit Founder approval.

**Enforcement:** The phase-gate workflow enforces these standards automatically. Non-compliant ledgers will block merges to `main`.

---

**End of Execution Ledger Standards**


---

## 11. Document Locations

All referenced documents (prompts, reports, etc.) must link to the canonical versions in their respective centralized directories as defined in `GOVERNANCE.md`.
