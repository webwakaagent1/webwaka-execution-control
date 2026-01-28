# Phase 1, Session 7 Execution Prompt: Email & Notifications

**Date:** 2026-01-27  
**Issued By:** Manus AI (Coordinator Agent) on behalf of the Founder  
**Status:** ✅ **AUTHORIZED**

---

## 1. Executive Summary

This document authorizes the Implementation Agent to execute **Phase 1, Session 7: Email & Notifications**. The goal is to set up AWS SES for transactional emails and AWS SNS for push notifications.

**Prerequisite:** Session 5 (Serverless Backend API) must be complete.

---

## 2. Session 7: Email & Notifications

### Objective
Enable the platform to send transactional emails and push notifications.

### Tasks

1.  **Set up AWS SES (Simple Email Service):**
    *   Update Terraform to add an `aws_ses_domain_identity` resource for `webwaka.site`.
    *   Add the required DNS records (provided by the Terraform output) to Route 53 to verify the domain.
    *   Request to move SES out of the sandbox environment.
    *   Create a new Lambda function (or update the existing one) with an API endpoint (e.g., `/send-email`) that sends a test email using the SES `SendEmail` API.

2.  **Set up AWS SNS (Simple Notification Service):**
    *   Update Terraform to add an `aws_sns_topic` resource named `webwaka-notifications`.
    *   Create a new Lambda function (or update the existing one) with an API endpoint (e.g., `/send-notification`) that publishes a message to the SNS topic.

3.  **Deploy and Test:**
    *   Run the `terraform-apply` workflow.
    *   Test the `/send-email` endpoint to confirm an email is sent and received.
    *   Test the `/send-notification` endpoint and verify the message is published to the SNS topic in the AWS console.

4.  **Document Output:**
    *   Generate and commit a `PHASE_1_SESSION_7_COMPLETION_REPORT.md` detailing the SES and SNS setup, including the ARNs of the created resources.

### Exit Criteria
- ✅ The `webwaka.site` domain is verified in SES.
- ✅ SES is out of the sandbox.
- ✅ The backend can successfully send an email via the `/send-email` endpoint.
- ✅ The `webwaka-notifications` SNS topic is created.
- ✅ The backend can successfully publish a message to the SNS topic.
- ✅ A complete `PHASE_1_SESSION_7_COMPLETION_REPORT.md` is generated and committed.

---

**Proceed with execution once Session 6 is complete.**


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
