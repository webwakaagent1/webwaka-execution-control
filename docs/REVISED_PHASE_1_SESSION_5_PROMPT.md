# REVISED Phase 1, Session 5 Execution Prompt: Serverless Backend API

**Date:** 2026-01-27  
**Issued By:** Manus AI (Coordinator Agent) on behalf of the Founder  
**Status:** ✅ **AUTHORIZED**

---

## 1. Executive Summary

This document provides the revised execution prompt for **Phase 1, Session 5**. Due to an AWS account limitation preventing the use of Application Load Balancers (ALBs), the architecture for the backend API has been changed.

**You are authorized to proceed with the following revised plan.**

**New Architecture:** AWS API Gateway + AWS Lambda

This serverless approach will provide a highly scalable, resilient, and cost-effective backend without requiring any load balancers.

---

## 2. Revised Session 5: Serverless Backend API

### Objective
Deploy a secure, scalable, and production-ready serverless backend API using AWS API Gateway and AWS Lambda.

### Tasks

1.  **Create a Lambda-Compatible Application:**
    *   Create a new directory `backend/`.
    *   Inside `backend/`, create a simple Node.js/Express "Hello World" application.
    *   Use the `serverless-http` library to wrap your Express app so it is compatible with AWS Lambda.
    *   Your main handler file should export a `handler` function.

2.  **Update Terraform Configuration:**
    *   **Remove** any existing (and failed) ECS/Fargate and ALB resources from your Terraform files (`fargate.tf`).
    *   Add a new Terraform module for **AWS Lambda** (`lambda.tf`):
        *   Define an `aws_lambda_function` resource.
        *   The function should be configured to use the Node.js 20.x runtime.
        *   The source code for the Lambda will be the `backend/` directory.
        *   Define an IAM role for the Lambda function that grants basic execution permissions.
    *   Add a new Terraform module for **AWS API Gateway** (`api_gateway.tf`):
        *   Define an `aws_apigatewayv2_api` resource for an HTTP API (this is simpler and cheaper than a REST API).
        *   Define an `aws_apigatewayv2_integration` to connect the API Gateway to your Lambda function.
        *   Define an `aws_apigatewayv2_route` to route all requests (`$default`) to the Lambda integration.
        *   Define an `aws_apigatewayv2_stage` for the `prod` stage with auto-deploy enabled.

3.  **Deploy the Serverless API:**
    *   Run the `terraform-apply` workflow to provision the Lambda and API Gateway resources.

4.  **Document Output & Fix Previous Reports:**
    *   The workflow should automatically generate a `PHASE_1_SESSION_5_COMPLETION_REPORT.md` with the API Gateway endpoint URL.
    *   **Crucially, you must also create and commit a `PHASE_1_SESSION_4_COMPLETION_REPORT.md`** that properly documents the Cognito resources created in the previous session. This was missed and must be corrected.

### Exit Criteria
- ✅ A Lambda function for the backend is created and configured.
- ✅ An API Gateway HTTP API is created and publicly accessible.
- ✅ The API Gateway endpoint successfully invokes the Lambda function and returns a "Hello World" response.
- ✅ A complete `PHASE_1_SESSION_5_COMPLETION_REPORT.md` is generated and committed.
- ✅ A complete `PHASE_1_SESSION_4_COMPLETION_REPORT.md` is generated and committed.

---

## 3. Final Verification

After you complete this revised session, I will perform a full verification of the deployed resources and the generated documentation.

**Proceed with execution.**


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
