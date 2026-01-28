# Coordinator Handover Package: WebWaka Project

**Date:** 2026-01-27  
**Author:** Manus AI (Previous Coordinator Agent)  
**Status:** ✅ **Ready for Handover**

---

## 1. Introduction & Purpose

This document is the official handover package for the role of **Coordinator Agent** for the WebWaka project. Its purpose is to provide you with all the necessary context, history, technical details, and procedural knowledge required to seamlessly take over the coordination and management of the project's execution.

Your primary responsibility as the new Coordinator is to **prepare and issue execution prompts** for the Implementation Agent, **verify the completed work**, and **serve as the main point of contact for the Founder**.

---

## 2. Project Overview

- **Project Name:** WebWaka
- **Objective:** To build a highly scalable, multi-tenant, PWA-first "platform for platforms."
- **Guiding Principles:** The project is strictly governed by the 15 **Foundational Assumptions** outlined in `FOUNDATIONAL_ASSUMPTIONS.md`. You must read and internalize these principles, as they dictate all major architectural decisions.

---

## 3. Current Status (As of 2026-01-27)

- **Current Phase:** Phase 1 - Core Infrastructure
- **Source of Truth:** The `EXECUTION_LEDGER.md` file in the root of the GitHub repository is the definitive source for phase status and history.

### Completed Work:

- **Phase 0: Governance & Execution Control:** Fully complete and approved.
- **Phase 1, Session 1: AWS Bootstrap:** Complete. (IAM, S3 state bucket, CloudTrail)
- **Phase 1, Session 2: Core Network:** Complete. (VPC, Subnets, NAT Gateways)

### Work in Progress / Next Steps:

The project is currently at the start of a multi-session execution for the remainder of Phase 1. A series of prompts have been prepared to take the project from Session 5 through Session 13.

**Your immediate task is to issue the `REVISED_PHASE_1_SESSION_5_PROMPT.md` to the Implementation Agent and begin coordinating the execution of the remaining Phase 1 tasks.**

---

## 4. Key Information & Locations

> **This is the single source of truth for document locations. All other documents must and will be updated to reflect this structure.**

| Resource | Location | Master Index / Link |
| :--- | :--- | :--- |
| **All Code** | `/` | `https://github.com/webwakaagent1/webwaka-execution-control` |
| **Core Governance** | `/` | N/A |
| **Execution Prompts** | `/docs` | `docs/PHASE_1_PROMPT_LINKS.md` |
| **Handover Packages** | `/handover` | `handover/HANDOVER_INDEX.md` |
| **Completion Reports** | `/reports/completion` | `reports/COMPLETION_REPORT_INDEX.md` |
| **Test Reports** | `/reports/testing` | `reports/TEST_REPORT_INDEX.md` |
| **Project Knowledge Base** | Notion | N/A |

---






---

## 5. Critical Technical Details & Constraints

### AWS Account & Credentials

- **Access:** All AWS credentials (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`) are stored as **GitHub Secrets**. They are automatically available to all GitHub Actions workflows. **You will not find them in plain text.**
- **Region:** The primary deployment region is `us-east-1` (N. Virginia).

### CRITICAL: Application Load Balancer (ALB) Limitation

> **This is the most important constraint you must be aware of.** The AWS account has a service limitation that **prevents the creation of Application Load Balancers**. This forced a major architectural pivot.

- **Original Plan:** Fargate + ALB
- **New Architecture:** **API Gateway + Lambda**

All backend services must be exposed via API Gateway and run as Lambda functions. Do not attempt to create or prompt for the creation of an ALB. The analysis for this decision is in `ALB_ALTERNATIVES_ANALYSIS.md`.

### CRITICAL: Cross-Region Architecture for AWS Bedrock

- **Constraint:** AWS Bedrock is not available in the primary region (`us-east-1`).
- **Solution:** All Bedrock API calls **must** be made to the `us-east-1` region. The architecture designed in Session 10 uses an asynchronous, event-driven pattern with SQS to handle this cross-region communication without impacting user-facing latency.

---

## 6. Your Role: The Coordinator Workflow

Your job follows a clear, cyclical pattern:

1.  **Prepare the Prompt:** Based on the `EXECUTION_PHASES.md`, create a detailed execution prompt for the next session (or batch of sessions). All prompts I have just created are in the `docs/` directory.
2.  **Issue the Prompt:** Commit the prompt to the `docs/` directory in GitHub and post it to the Notion workspace. Inform the Founder that a new task is ready for the Implementation Agent.
3.  **Await Completion:** The Implementation Agent will execute the task and commit a completion report to the `docs/` directory.
4.  **Verify the Work:** This is your most critical function.
    *   Pull the latest changes from GitHub.
    *   Read the completion report.
    *   **Independently verify** the provisioned resources in the AWS console (using the AWS CLI in the sandbox).
    *   **Verify the documentation.** Ensure the completion report is accurate and that all required documents were created.
5.  **Report to Founder:**
    *   If verification passes, create a **Verification Report**, commit it, and inform the Founder that the session is complete and ready for their final approval.
    *   If verification fails, create a **Verification Report** detailing the failures and recommend a remediation plan. Prepare a new, targeted prompt for the Implementation Agent to fix the issues.

### Tools at Your Disposal

- **Shell (`shell` tool):** Your primary tool for interacting with `git`, the AWS CLI, and `manus-mcp-cli`.
- **File System (`file` tool):** For reading and writing all documents and prompts.
- **Notion MCP (`manus-mcp-cli`):** Use this to interact with the Notion workspace for posting documents and searching for information. You can list tools with `manus-mcp-cli tool list --server notion`.

---

## 7. Handover Checklist for New Coordinator

- [ ] I have read and understood this entire document.
- [ ] I have read and understood the 15 `FOUNDATIONAL_ASSUMPTIONS.md`.
- [ ] I have reviewed the `EXECUTION_LEDGER.md` to understand the project's history.
- [ ] I understand the critical **ALB limitation** and the pivot to a serverless architecture.
- [ ] I understand the **cross-region requirement** for AWS Bedrock.
- [ ] I am ready to issue the `REVISED_PHASE_1_SESSION_5_PROMPT.md` and coordinate the remainder of Phase 1.

**You are now the Coordinator. Good luck.**


---

## 8. UPDATE: Streamlined Prompt Delivery Protocol

To improve efficiency and maintain a single source of truth, the process for delivering prompts to the Implementation Agent has been updated.

**The New Protocol:** Instead of sending the full text of a prompt, the Coordinator will now send a direct GitHub link to the prompt file.

Your workflow for issuing a prompt is now:

1.  **Prepare and Commit:** Create the prompt and commit it to the `docs/` directory in GitHub.
2.  **Generate Link:** Obtain the direct file link from the GitHub repository.
3.  **Deliver Link:** Send a concise message to the Implementation Agent containing only the link and a brief authorization statement.

This ensures the Implementation Agent always works from the canonical version of the prompt stored in the version-controlled repository.

**Reference:** For full details, see the `PROMPT_DELIVERY_PROTOCOL.md` document and `PHASE_1_PROMPT_LINKS.md` for a quick reference of all Phase 1 prompt links.


---

## 9. UPDATE: Centralized Reporting System

To further streamline documentation, all completion, verification, and test reports have been centralized into a new `/reports` directory with master index files.

**The New System:**

-   **Completion/Verification Reports:** All are now located in `/reports/completion` and indexed in `reports/COMPLETION_REPORT_INDEX.md`.
-   **Test Reports:** All will be located in `/reports/testing` and indexed in `reports/TEST_REPORT_INDEX.md`.

When you create or receive a report, your workflow is:

1.  **Place the Report:** Add the new report file to the correct subdirectory in `/reports`.
2.  **Update the Index:** Add a new row to the corresponding master index file with a link to the new report.
3.  **Deliver Index Link:** When notifying stakeholders, send a link to the master index, not the individual report.

**Reference:** For full details, see the `reports/REPORT_DELIVERY_PROTOCOL.md` document.


---

# MANDATORY: Documentation Structure Enforcement

**This is a mandatory directive for all agents (Coordinator, Implementer, Verifier). Failure to comply is a STOP condition.**

---

## 1. The Rule: Use the Centralized Structure

All documentation created or updated during this project **MUST** adhere to the centralized documentation structure. This is not a suggestion; it is a hard requirement.

**You are required to place all new documents in their correct locations and update the corresponding master index file.**

## 2. The Structure

| Resource Category | Directory Location | Master Index File (to be updated) |
| :--- | :--- | :--- |
| 📜 **Execution Prompts** | `/docs` | `docs/PHASE_1_PROMPT_LINKS.md` |
| 🤝 **Handover Packages** | `/handover` | `handover/HANDOVER_INDEX.md` |
| ✅ **Completion Reports** | `/reports/completion` | `reports/COMPLETION_REPORT_INDEX.md` |
| 🧪 **Test Reports** | `/reports/testing` | `reports/TEST_REPORT_INDEX.md` |

## 3. Your Responsibility

- **Before creating a new document:** Check the table above to identify the correct directory.
- **After creating a new document:**
    1. Place the file in the correct directory.
    2. **Open the corresponding Master Index file** and add a new row with the link to your new document.
- **When referencing any document:** Always link to the master index first, not the individual file. For example, refer to the "Completion Report Index" instead of a specific report file.

## 4. Why This is Mandatory

This system ensures a **single source of truth** and prevents documentation chaos. It allows any agent or human to find any document at any time without ambiguity.

**Compliance with this directive will be verified as part of every task completion.**

---

*This enforcement notice is automatically included in all execution prompts and core governance documents.*
