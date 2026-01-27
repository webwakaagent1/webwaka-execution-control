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
