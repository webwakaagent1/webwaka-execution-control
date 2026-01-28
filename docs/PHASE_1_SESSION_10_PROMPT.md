# Phase 1, Session 10 Execution Prompt: AI Integration

**Date:** 2026-01-27  
**Issued By:** Manus AI (Coordinator Agent) on behalf of the Founder  
**Status:** ✅ **AUTHORIZED**

---

## 1. Executive Summary

This document authorizes the Implementation Agent to execute **Phase 1, Session 10: AI Integration**. The goal is to integrate AWS Bedrock for generative AI capabilities, using a cross-region, asynchronous pattern.

**Prerequisite:** Session 9 (Event-Driven Architecture) must be complete.

---

## 2. Session 10: AI Integration

### Objective
Integrate AWS Bedrock to provide AI-powered features, ensuring the architecture handles the cross-region requirement gracefully.

### Tasks

1.  **Create an AI Request API:**
    *   Create a new Lambda function (or update the existing one) with an API endpoint (e.g., `/generate-text`).
    *   This endpoint should accept a prompt from the user.
    *   Instead of calling Bedrock directly, it should publish an event to the `webwaka-event-bus` with a `detail-type` of `ai.text.generation.requested` and the user's prompt in the `detail`.

2.  **Create a Bedrock-Invoking Lambda:**
    *   Create a new Lambda function named `bedrock-processor`.
    *   Configure this Lambda to be triggered by events with the `ai.text.generation.requested` detail type.
    *   **Crucially**, configure the Boto3 client within this Lambda to use the `us-east-1` region for Bedrock API calls.
    *   The Lambda should call the Bedrock API (e.g., using the Claude model) with the prompt from the event.
    *   After receiving the response from Bedrock, it should publish a new event to the event bus with a `detail-type` of `ai.text.generation.succeeded` and the generated text.

3.  **Create a WebSocket API for Real-time Updates:**
    *   Update Terraform to add an `aws_apigatewayv2_api` for a **WebSocket API**.
    *   Create routes for `$connect`, `$disconnect`, and `$default`.
    *   Create Lambda functions to handle these routes, storing connection IDs in a DynamoDB table.

4.  **Push Results to Client:**
    *   Create a final Lambda function, `result-pusher`, that is triggered by the `ai.text.generation.succeeded` event.
    *   This Lambda should retrieve the connection ID from the event and use the API Gateway Management API to push the generated text back to the correct client over the WebSocket connection.

5.  **Deploy and Test:**
    *   Run the `terraform-apply` workflow.
    *   Use a tool like `wscat` to connect to the WebSocket API.
    *   Call the `/generate-text` HTTP endpoint.
    *   Verify that the generated text is received over the WebSocket connection.

6.  **Document Output:**
    *   Generate and commit a `PHASE_1_SESSION_10_COMPLETION_REPORT.md` detailing the entire asynchronous AI workflow, including the WebSocket API endpoint.

### Exit Criteria
- ✅ The `/generate-text` endpoint successfully publishes an event.
- ✅ The `bedrock-processor` Lambda is triggered and successfully calls the Bedrock API in `us-east-1`.
- ✅ The WebSocket API is functional.
- ✅ The generated text is successfully pushed back to the client over the WebSocket.
- ✅ A complete `PHASE_1_SESSION_10_COMPLETION_REPORT.md` is generated and committed.

---

**Proceed with execution once Session 9 is complete.**


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
