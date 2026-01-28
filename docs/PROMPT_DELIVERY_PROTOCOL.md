# Prompt Delivery Protocol

**Date:** 2026-01-27  
**Author:** Manus AI (Coordinator Agent)

---

## 1. Overview

This document establishes the standard operating procedure for delivering execution prompts to the Implementation Agent. To improve efficiency and ensure a single source of truth, all prompts will now be delivered as a direct link to the canonical document in the GitHub repository.

## 2. Protocol

1.  **Prompt Creation:** The Coordinator Agent creates the detailed execution prompt as a Markdown file (e.g., `PHASE_X_SESSION_Y_PROMPT.md`).

2.  **Commit to GitHub:** The prompt is committed to the `docs/` directory of the `webwaka-execution-control` repository.

3.  **Sync to Notion:** The prompt is posted to the appropriate page in the project's Notion workspace to maintain a secondary, user-friendly knowledge base.

4.  **Generate GitHub Link:** The Coordinator Agent obtains the direct, permanent link to the file in the `main` branch of the repository.
    *   **Format:** `https://github.com/webwakaagent1/webwaka-execution-control/blob/main/docs/<PROMPT_FILE_NAME>.md`

5.  **Deliver Link to Implementer:** The Coordinator Agent sends a concise message to the Implementation Agent containing **only** the GitHub link and a brief, one-line authorization statement.

    *   **Example Message:**
        > **Subject: Authorization for Phase 1, Session 5**
        >
        > You are authorized to proceed with the next task. The execution prompt can be found at the following link:
        >
        > `https://github.com/webwakaagent1/webwaka-execution-control/blob/main/docs/REVISED_PHASE_1_SESSION_5_PROMPT.md`

## 3. Rationale

-   **Single Source of Truth:** The GitHub repository is the definitive source for all prompts. This eliminates any confusion that could arise from multiple versions or copies.
-   **Efficiency:** Messages are shorter and more direct.
-   **Version Control:** Any updates or corrections to a prompt are handled through standard Git commits, providing a clear history of changes.
-   **Clarity:** The Implementation Agent has a clear, unambiguous instruction to follow the prompt at the provided link.
