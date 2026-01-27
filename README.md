# WebWaka Execution Control

**Status:** 🔒 CANON-LOCKED  
**Authority:** Founder  
**Operator:** Manus  
**Phase:** Phase 0 — Execution Control & Governance

---

## Purpose

This repository is the **canonical execution brain** of WebWaka. It contains:

- **Governance documents** — Rules, protocols, and decision-making frameworks
- **Phase definitions** — Strict sequential execution phases with entry/exit criteria
- **Verification strategy** — How to validate that each phase is complete
- **STOP-SAFE protocol** — When and how to stop execution safely
- **Execution ledger** — Record of all decisions, changes, and progress

**This repository does NOT contain:**
- ❌ Product code
- ❌ Infrastructure provisioning code
- ❌ AWS configuration
- ❌ Business logic implementation

---

## Absolute State Persistence Rule

⚠️ **NOTHING MAY EVER REMAIN LOCAL**

From this point forward:
1. At ANY pause, stop, context switch, or handover — ALL WORK MUST BE PUSHED TO GITHUB FIRST.
2. There must be NO uncommitted files, NO local-only drafts, NO "to be pushed later" work.
3. GitHub is the only memory.
4. If work is not pushed, it is considered non-existent.

This rule applies:
- Even if work is incomplete
- Even if work is exploratory
- Even if work is blocked
- Even if you are awaiting approval

📌 No reminders will be given. This is a standing invariant.

Failure to comply = execution failure.

---

## Repository Structure

```
webwaka-execution-control/
├── README.md                           # This file
├── GOVERNANCE.md                       # Core governance rules
├── EXECUTION_PHASES.md                 # Sequential phase definitions
├── VERIFICATION_STRATEGY.md            # How to verify completion
├── STOP_SAFE_PROTOCOL.md               # When and how to stop safely
├── FOUNDATIONAL_ASSUMPTIONS.md         # Locked architectural assumptions
├── EXECUTION_LEDGER.md                 # Decision and progress log
├── PHASE_0_COMPLETION_CRITERIA.md      # Phase 0 exit criteria
├── phases/                             # Detailed phase documents
│   ├── PHASE_1_CORE_INFRASTRUCTURE.md
│   ├── PHASE_2_PLATFORM_PRIMITIVES.md
│   └── PHASE_3_INDUSTRY_SUITES.md
├── decisions/                          # Founder decision records
│   └── FOUNDER_DECISIONS_LOCKED.md
└── reports/                            # STOP condition reports
    └── .gitkeep
```

---

## Core Principles

1. **AWS-First, Single-Bill Architecture**
2. **Max-Scale-First Design** (1,000+ partners, 1M+ tenants, 100M+ users)
3. **Platform-for-Platforms Vision** (not vertical SaaS)
4. **PWA-First by Default** (every surface must be PWA-installable)
5. **Offline-First for Core Actions** (5 core actions: POS, lead capture, inventory, affiliate, field data)
6. **Push Notifications as Core Platform Primitive**
7. **AI as Core Platform Primitive**
8. **Recursive System Usage** (all primitives usable at all levels)
9. **Partner Pricing Autonomy**
10. **Platform Extensibility & Future-Proofing**

---

## 🛠️ Ledger Automation Script (`scripts/ledger.py`)

This script is the central tool for managing the `EXECUTION_LEDGER.md` file. It has been significantly enhanced with new features for improved usability and safety.

### New Features:

1.  **Detailed Validation Error Messages:** Provides clear, actionable feedback when validation rules are violated, helping users quickly understand and resolve issues.
2.  **Dry-Run Mode:** Allows you to preview the effects of `update` and `approve` commands without making any permanent changes to the `EXECUTION_LEDGER.md` file. This is ideal for testing and verifying commands before execution.
3.  **Rollback Functionality:** Automatically creates backups of the `EXECUTION_LEDGER.md` file before any write operation. You can easily revert to the most recent previous state if an error occurs or a change needs to be undone.

### Usage:

```bash
python scripts/ledger.py <command> [arguments]
```

#### Commands:

-   **`update --phase <PHASE> --status <STATUS> [--details <DETAILS>] [--dry-run]`**
    -   Updates the status of a specific phase in the ledger.
    -   `--phase`: The name of the phase (e.g., "Phase 0").
    -   `--status`: The new status (e.g., "not_started", "in_progress", "complete", "approved").
    -   `--details`: (Optional) Additional information about the update.
    -   `--dry-run`: (Optional) Preview changes without saving them.

-   **`approve --phase <PHASE> --issue <ISSUE_NUMBER> [--dry-run]`**
    -   Records Founder approval for a phase, linking to a GitHub issue.
    -   `--phase`: The name of the phase being approved.
    -   `--issue`: The GitHub issue number associated with the approval.
    -   `--dry-run`: (Optional) Preview changes without saving them.

-   **`validate`**
    -   Validates the structure and content of the `EXECUTION_LEDGER.md` file.
    -   Provides detailed error messages for any inconsistencies.

-   **`get-current-phase`**
    -   Retrieves and prints the current active phase and its status from the ledger.

-   **`rollback`**
    -   Reverts the `EXECUTION_LEDGER.md` file to its most recent previous version using the latest backup.
    -   A pre-rollback backup is automatically created for safety.

-   **`list-backups`**
    -   Lists all available backups of the `EXECUTION_LEDGER.md` file, including their creation timestamps and sizes.

## How to Use This Repository

### For AI Operators (Manus, Emergent, etc.)

1. **Read GOVERNANCE.md first** — Understand the rules
2. **Read EXECUTION_PHASES.md** — Understand the phases
3. **Read FOUNDATIONAL_ASSUMPTIONS.md** — Understand the locked decisions
4. **Follow the current phase** — Do not skip ahead
5. **Update EXECUTION_LEDGER.md** — Record all decisions and progress
6. **Commit and push** — Before any pause or stop

### For Human Reviewers (Founder, etc.)

1. **Review EXECUTION_LEDGER.md** — See what has been done
2. **Review reports/** — See any STOP conditions
3. **Approve or reject** — Provide feedback in GitHub issues or comments

---

## Current Status

**Phase:** Phase 0 — Execution Control & Governance  
**Status:** In Progress  
**Last Updated:** 2026-01-26

---

## 🌐 Access & Documentation

-   **Approval Dashboard:** [https://webwakaagent1.github.io/webwaka-approval-dashboard/](https://webwakaagent1.github.io/webwaka-approval-dashboard/)
-   **Notion Documentation Index:** [https://www.notion.so/2f5fb70870b58187a44af7ec2dd5fe44](https://www.notion.so/2f5fb70870b58187a44af7ec2dd5fe44)
-   **GitHub Repository:** [https://github.com/webwakaagent1/webwaka-execution-control](https://github.com/webwakaagent1/webwaka-execution-control)

## ⚠️ Critical Setup for Full Automation

To fully enable the automation system, the Founder must perform these one-time actions:

1.  **Add AWS Credentials to GitHub Secrets:** Configure `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` in the repository secrets to enable AWS infrastructure provisioning.
2.  **Approve Phase 0:** Use the Approval Dashboard to officially approve Phase 0, which will trigger the next phase of automation.

## Links

- **WebWaka Re-Founding Blueprint:** https://github.com/webwakaagent1/webwaka-refounding-documents
- **WebWaka Execution Control:** https://github.com/webwakaagent1/webwaka-execution-control (this repository)

---

**End of README**
