# Phase 1, Session 8 Execution Prompt: Storage & CDN

**Date:** 2026-01-27  
**Issued By:** Manus AI (Coordinator Agent) on behalf of the Founder  
**Status:** ✅ **AUTHORIZED**

---

## 1. Executive Summary

This document authorizes the Implementation Agent to execute **Phase 1, Session 8: Storage & CDN**. The goal is to enable secure file uploads for users.

**Prerequisite:** Session 5 (Serverless Backend API) must be complete.

---

## 2. Session 8: Storage & CDN

### Objective
Implement a secure and scalable solution for user file uploads using AWS S3 and CloudFront.

### Tasks

1.  **Create an S3 Bucket for Uploads:**
    *   Update Terraform to add a new `aws_s3_bucket` resource named `webwaka-uploads`.
    *   Configure the bucket to be **private**. No public read access.
    *   Enable CORS to allow uploads from the `webwaka.site` domain.

2.  **Create a File Upload API:**
    *   Create a new Lambda function (or update the existing one) with an API endpoint (e.g., `/generate-upload-url`).
    *   This endpoint should accept a filename and file type as input.
    *   It should generate a **presigned S3 URL** that grants temporary `PUT` access to a specific key in the `webwaka-uploads` bucket.
    *   Return the presigned URL to the client.

3.  **Update the Frontend:**
    *   Add a file input and an upload button to the frontend application.
    *   When a user selects a file and clicks "Upload", the frontend should:
        1.  Call the `/generate-upload-url` endpoint to get a presigned URL.
        2.  Use the `fetch` API to `PUT` the file directly to the presigned URL.

4.  **Deploy and Test:**
    *   Run the `terraform-apply` workflow.
    *   Run the `frontend-ci.yml` workflow.
    *   Test the end-to-end file upload process from the browser.

5.  **Document Output:**
    *   Generate and commit a `PHASE_1_SESSION_8_COMPLETION_REPORT.md` detailing the S3 bucket setup and the new API endpoint.

### Exit Criteria
- ✅ The `webwaka-uploads` S3 bucket is created and private.
- ✅ The `/generate-upload-url` endpoint successfully returns a valid presigned URL.
- ✅ The frontend can successfully upload a file to S3 using the presigned URL.
- ✅ The uploaded file is visible in the S3 bucket in the AWS console.
- ✅ A complete `PHASE_1_SESSION_8_COMPLETION_REPORT.md` is generated and committed.

---

**Proceed with execution once Session 7 is complete.**


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
