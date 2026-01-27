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
