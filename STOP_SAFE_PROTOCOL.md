# STOP_SAFE_PROTOCOL.md

**Status:** 🔒 CANON-LOCKED  
**Authority:** Founder

---

## 1. Purpose

This document defines the **STOP-SAFE protocol**, a mandatory procedure for safely pausing or stopping execution when a critical problem is detected. Its purpose is to prevent catastrophic failures, data loss, or security breaches.

---

## 2. Triggering a STOP-SAFE Condition

Any operator (Manus or human) may trigger a STOP-SAFE condition if they detect any of the following:

- **Critical Bug:** A bug that causes data corruption, security vulnerabilities, or system instability.
- **Security Vulnerability:** Any potential for unauthorized access, data leakage, or denial of service.
- **Contradiction with Foundational Assumptions:** Any deviation from the 10 canonically locked assumptions.
- **Governance Violation:** Any violation of the rules defined in `GOVERNANCE.md`.
- **Unforeseen Technical Debt:** Discovery of a design flaw that will create significant future problems.
- **Loss of Confidence:** If an operator loses confidence in the current execution path for any reason.

---

## 3. STOP-SAFE Procedure

When a STOP-SAFE condition is triggered, the operator must immediately:

1. **HALT ALL WORK:** Stop all active tasks and processes.
2. **ISOLATE THE PROBLEM:** Prevent the problem from spreading.
3. **PUSH ALL WORK TO GITHUB:** Commit and push all local changes to a new branch named `stop-safe-<timestamp>`.
4. **CREATE A STOP-SAFE REPORT:** Create a new file named `stop-safe-report-<timestamp>.md` in the `reports/` directory.
5. **NOTIFY THE FOUNDER:** Escalate the STOP-SAFE report to the Founder for review.

---

## 4. STOP-SAFE Report Format

The STOP-SAFE report must include:

- **Timestamp:** The date and time the condition was triggered.
- **Operator:** The name of the operator who triggered the condition.
- **Condition:** The specific STOP-SAFE condition that was triggered.
- **Description:** A detailed description of the problem.
- **Impact Assessment:** An assessment of the potential impact of the problem.
- **Proposed Solution:** A proposed solution to the problem.
- **Link to Branch:** A link to the `stop-safe-<timestamp>` branch.

---

## 5. Resuming Execution

Execution may only be resumed after:

1. The Founder has reviewed the STOP-SAFE report.
2. The proposed solution has been approved by the Founder.
3. The solution has been implemented and verified.
4. The `stop-safe-<timestamp>` branch has been merged into `main`.
5. The Founder has given explicit approval to resume execution.

---

## 6. Document Updates

This document may only be updated by the Founder.

---

**End of STOP_SAFE_PROTOCOL.md**
