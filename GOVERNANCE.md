# GOVERNANCE.md

**Status:** 🔒 CANON-LOCKED  
**Authority:** Founder  
**Operator:** Manus

---

## 1. Core Principles

This document defines the governance rules for the WebWaka execution system. All operators must adhere to these rules without exception.

### 1.1. GitHub as Single Source of Truth

- **All work must be in GitHub.** This includes code, documentation, plans, decisions, and reports.
- **If it's not in GitHub, it doesn't exist.** No local-only files, no verbal agreements, no side-channel communications.
- **The `main` branch is the only canonical truth.** All other branches are considered work in progress.

### 1.2. Absolute State Persistence Rule

⚠️ **NOTHING MAY EVER REMAIN LOCAL**

- At ANY pause, stop, context switch, or handover — ALL WORK MUST BE PUSHED TO GITHUB FIRST.
- This is a non-negotiable invariant.
- Failure to comply = execution failure.

### 1.3. Strict Sequential Execution

- Execution proceeds in strict sequential phases.
- No phase may be skipped.
- No phase may begin until the previous phase's exit criteria are met and approved.

### 1.4. Explicit Decision-Making

- All decisions must be documented in the `EXECUTION_LEDGER.md` before implementation.
- No operator may assume a decision that is not explicitly documented.
- Decisions with long-term architectural impact must be escalated to the Founder for approval.

### 1.5. Documentation as a Core Deliverable

- Documentation is not an afterthought; it is a core deliverable of every phase.
- All code must be accompanied by clear, concise documentation.
- All architectural decisions must be justified in writing.

---

## 2. Roles and Responsibilities

### 2.1. Founder

- **Authority:** The ultimate authority on all decisions.
- **Responsibilities:**
    - Approve or reject phase completion.
    - Make final decisions on escalated issues.
    - Set the overall vision and direction.

### 2.2. Manus (and other AI Operators)

- **Operator:** The primary execution agent.
- **Responsibilities:**
    - Execute the tasks defined in each phase.
    - Adhere to all governance rules.
    - Document all work in GitHub.
    - Escalate issues and decisions as required.
    - Maintain the integrity of the execution system.

---

## 3. Communication Protocol

### 3.1. Asynchronous by Default

- All communication should be asynchronous and documented in GitHub.
- Use GitHub issues for bug reports, feature requests, and questions.
- Use pull request comments for code review.
- Use `EXECUTION_LEDGER.md` for decision-making.

### 3.2. Synchronous for Emergencies

- Synchronous communication (e.g., chat) is reserved for emergencies only.
- All synchronous communication must be summarized and documented in GitHub immediately afterward.

---

## 4. Change Control Process

### 4.1. All Changes via Pull Request

- All changes to the `main` branch must be made via pull request.
- No direct commits to `main` are allowed.

### 4.2. Pull Request Requirements

- All pull requests must include:
    - A clear title and description.
    - A link to the relevant issue or task.
    - A summary of the changes made.
    - Evidence of successful verification.

### 4.3. Code Review

- All pull requests must be reviewed and approved by at least one other operator (if applicable) or the Founder.
- Code review should focus on:
    - Adherence to coding standards.
    - Correctness and completeness.
    - Documentation quality.
    - Performance and security.

---

## 5. STOP-SAFE Protocol

- Any operator may trigger a STOP-SAFE condition if they detect a problem.
- See `STOP_SAFE_PROTOCOL.md` for details.

---

## 6. Document Updates

- This document may only be updated by the Founder.
- All changes must be made via pull request and documented in the `EXECUTION_LEDGER.md`.

---

**End of GOVERNANCE.md**
