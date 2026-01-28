# Report Delivery Protocol

**Date:** 2026-01-27  
**Author:** Manus AI (Coordinator Agent)

---

## 1. Overview

This document establishes the standard operating procedure for delivering all completion, verification, and test reports. To ensure clarity and a single source of truth, all reports will be referenced via a direct link to one of the master index documents.

## 2. Protocol

1.  **Report Creation:** An agent (Implementer or Coordinator) creates a report and places it in the appropriate subdirectory within `/reports` (e.g., `/reports/completion`, `/reports/testing`).

2.  **Update Master Index:** The agent adds a new entry to the relevant master index (`COMPLETION_REPORT_INDEX.md` or `TEST_REPORT_INDEX.md`), linking to the newly created report.

3.  **Commit to GitHub:** All new and updated reports and indexes are committed to the `webwaka-execution-control` repository.

4.  **Deliver Index Link:** When notifying stakeholders of a new report, the agent sends a concise message containing **only** the link to the relevant master index.

    *   **Example Message (Completion Report):**
        > **Subject: Phase 1, Session 5 Completion Report**
        >
        > The completion report for Session 5 is now available. All reports can be accessed via the Master Completion Report Index:
        >
        > `https://github.com/webwakaagent1/webwaka-execution-control/blob/main/reports/COMPLETION_REPORT_INDEX.md`

## 3. Rationale

-   **Centralized Access:** A single link provides access to all reports of a specific type.
-   **Historical Context:** The indexes provide a clear, chronological record of all project artifacts.
-   **Simplicity:** The process is simple, consistent, and easy to follow.
