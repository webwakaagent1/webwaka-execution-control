# Phase 1, Session 6 Execution Prompt: Frontend Hosting

**Date:** 2026-01-27  
**Issued By:** Manus AI (Coordinator Agent) on behalf of the Founder  
**Status:** ✅ **AUTHORIZED**

---

## 1. Executive Summary

This document authorizes the Implementation Agent to execute **Phase 1, Session 6: Frontend Hosting**. The goal is to deploy a placeholder frontend application and configure a CI/CD pipeline for it.

**Prerequisite:** Session 5 (Serverless Backend API) must be complete, as the frontend will need to call the API.

---

## 2. Session 6: Frontend Hosting

### Objective
Deploy a simple, static frontend application using AWS S3 and CloudFront, and establish a CI/CD pipeline for automatic deployments.

### Tasks

1.  **Create a Placeholder Frontend Application:**
    *   Create a new directory `frontend/`.
    *   Inside `frontend/`, create a simple React application using Vite (`pnpm create vite . --template react-ts`).
    *   The application should have a single page that makes a `fetch` request to the API Gateway endpoint created in Session 5 and displays the "Hello World" message.

2.  **Update Terraform Configuration:**
    *   Add a new Terraform module (`frontend.tf`) for the frontend infrastructure.
    *   Define an `aws_s3_bucket` resource to host the static website files.
    *   Configure the bucket for public read access and static website hosting.
    *   Define an `aws_cloudfront_distribution` resource to act as a CDN for the S3 bucket, enabling HTTPS and caching.
    *   Define an `aws_route53_record` to point the `webwaka.site` domain to the CloudFront distribution.

3.  **Create a CI/CD Workflow:**
    *   Create a new GitHub Actions workflow (`.github/workflows/frontend-ci.yml`) that:
        *   Builds the React application (`pnpm install && pnpm run build`).
        *   Syncs the contents of the `dist/` directory to the S3 bucket.
        *   Invalidates the CloudFront cache to ensure the latest version is served.

4.  **Deploy the Frontend:**
    *   Run the `terraform-apply` workflow to create the S3 and CloudFront resources.
    *   Run the `frontend-ci.yml` workflow to deploy the initial version of the placeholder application.

5.  **Document Output:**
    *   Generate and commit a `PHASE_1_SESSION_6_COMPLETION_REPORT.md` with the website URL (`https://webwaka.site`) and other relevant details.

### Exit Criteria
- ✅ The S3 bucket and CloudFront distribution are created.
- ✅ The `webwaka.site` domain resolves to the CloudFront distribution.
- ✅ The placeholder React application is deployed and accessible via `https://webwaka.site`.
- ✅ The frontend successfully calls the backend API and displays the result.
- ✅ The `frontend-ci.yml` workflow runs successfully on push to `main`.
- ✅ A complete `PHASE_1_SESSION_6_COMPLETION_REPORT.md` is generated and committed.

---

**Proceed with execution once Session 5 is complete.**
