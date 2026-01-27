# Reports Directory

**Purpose:** This directory contains STOP-SAFE reports and phase verification reports as defined in the governance documents.

---

## Report Types

### 1. STOP-SAFE Reports

**Purpose:** Document emergency stops triggered by the STOP-SAFE protocol.

**Naming Convention:** `stop-safe-report-<timestamp>.md`

**Example:** `stop-safe-report-2026-01-27-143022.md`

**When Created:**
- When a STOP condition is triggered (see `STOP_SAFE_PROTOCOL.md`)
- When a Manus agent encounters a blocking issue
- When a critical governance violation is detected

**Contents:**
- Timestamp of stop
- Reason for stop
- Triggering condition
- Current phase and status
- Recommended remediation
- Escalation path

---

### 2. Phase Verification Reports

**Purpose:** Document independent verification findings for each phase.

**Naming Convention:** `phase-<N>-verification-report-<date>.md`

**Example:** `phase-0-verification-report-2026-01-27.md`

**When Created:**
- At the end of each phase by the Independent Verification Manus (IVM)
- After remediation to verify fixes

**Contents:**
- Phase number and name
- Verification date
- IVM agent identifier
- Summary of findings (CRITICAL, HIGH, MEDIUM, LOW)
- Detailed analysis of each finding
- Evidence reviewed
- Recommendations
- Approval recommendation (approve / reject / conditional approval)

---

## Directory Structure

```
reports/
├── README.md (this file)
├── stop-safe-report-YYYY-MM-DD-HHMMSS.md
├── phase-0-verification-report-YYYY-MM-DD.md
├── phase-1-verification-report-YYYY-MM-DD.md
├── phase-2-verification-report-YYYY-MM-DD.md
└── ...
```

---

## Access Control

**Who Can Create Reports:**
- Manus agents (STOP-SAFE reports)
- Independent Verification Manus (phase verification reports)
- Founder (any report type)

**Who Can Read Reports:**
- Founder (all reports)
- Manus agents (all reports)
- Public (if repository is public)

---

## Report Retention

**Retention Policy:**
- All reports are retained indefinitely
- Reports are never deleted (audit trail)
- Reports are committed to Git (version controlled)

---

## Related Documents

- `STOP_SAFE_PROTOCOL.md` — Defines when STOP-SAFE reports are required
- `VERIFICATION_STRATEGY.md` — Defines verification procedures
- `GOVERNANCE.md` — Defines independent verification requirements

---

**End of Reports Directory README**
