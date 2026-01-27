# Phase 1 Multi-Session Execution Prompt: Database, Auth, and Backend

**Date:** 2026-01-27  
**Issued By:** Manus AI (Coordinator Agent) on behalf of the Founder  
**Status:** ✅ **AUTHORIZED**

---

## 1. Executive Summary

This document authorizes the Implementation Agent to execute the next three sessions of Phase 1 in sequence. The goal is to accelerate the infrastructure provisioning process by batching related tasks.

**You are authorized to proceed with the following sessions without waiting for individual approval between them:**

1.  **Session 3: Database Infrastructure** (Phase 1.2)
2.  **Session 4: Authentication Setup** (Phase 1.3)
3.  **Session 5: Backend API Hosting** (Phase 1.4)

A single, final verification and approval will be conducted after all three sessions are complete.

---

## 2. Session 3: Database Infrastructure (Phase 1.2)

### Objective
Provision a secure, scalable, and production-ready database using AWS Aurora PostgreSQL within the existing VPC.

### Tasks

1.  **Update Terraform Configuration:**
    *   Add a new Terraform module for the Aurora PostgreSQL database.
    *   Define the database cluster, instances, and parameter groups.
    *   Ensure the database is deployed into the private `database` subnets created in Session 2.
    *   Use the `db.t3.medium` instance class for the initial setup.
2.  **Configure Security:**
    *   Ensure the database security group only allows inbound traffic from the `Application Security Group` on port 5432.
    *   Enable encryption at rest.
3.  **Enable Backups:**
    *   Configure automated daily backups with a 7-day retention period.
4.  **Apply Terraform Changes:**
    *   Run the `terraform-apply` workflow to provision the database.
5.  **Document Output:**
    *   The workflow should automatically generate a `PHASE_1_SESSION_3_COMPLETION_REPORT.md` with the database endpoint, port, and other relevant details.

### Exit Criteria
- ✅ Aurora PostgreSQL cluster is `available`.
- ✅ Database is accessible only from within the VPC (verified via security groups).
- ✅ Automated backups are enabled.
- ✅ Session 3 completion report is generated and committed to the `docs/` directory.

---

## 3. Session 4: Authentication Setup (Phase 1.3)

### Objective
Establish a secure and scalable user authentication and management system using AWS Cognito.

### Tasks

1.  **Update Terraform Configuration:**
    *   Add a new Terraform module for AWS Cognito.
    *   Create a User Pool with a secure password policy.
    *   Create a User Pool Client for the web application.
2.  **Configure Social Logins (Optional but Recommended):**
    *   Add configuration for Google and GitHub as identity providers.
    *   *Note: This may require manual steps in the AWS console to get client IDs and secrets, which should be documented.* 
3.  **Apply Terraform Changes:**
    *   Run the `terraform-apply` workflow to provision the Cognito resources.
4.  **Document Output:**
    *   The workflow should automatically generate a `PHASE_1_SESSION_4_COMPLETION_REPORT.md` with the User Pool ID, Client ID, and other relevant details.

### Exit Criteria
- ✅ Cognito User Pool is created.
- ✅ User Pool Client is created.
- ✅ Session 4 completion report is generated and committed to the `docs/` directory.

---

## 4. Session 5: Backend API Hosting (Phase 1.4)

### Objective
Set up a scalable and resilient hosting environment for the backend API using AWS Fargate.

### Tasks

1.  **Containerize the Application:**
    *   Create a `Dockerfile` for a simple Node.js/Express "Hello World" application.
    *   *Note: You do not need to build the full backend API yet. A placeholder is sufficient for this session.*
2.  **Set up ECR:**
    *   Create an Amazon ECR (Elastic Container Registry) repository to store the backend container image.
3.  **Update Terraform Configuration:**
    *   Add Terraform modules for ECS (Elastic Container Service) and Fargate.
    *   Create an ECS Cluster.
    *   Create a Fargate Task Definition for the backend service.
    *   Create a Fargate Service to run the task, configured for high availability across multiple AZs.
    *   Configure an Application Load Balancer (ALB) to route traffic to the Fargate service.
4.  **Build and Push Docker Image:**
    *   Create a new GitHub Actions workflow (`.github/workflows/backend-ci.yml`) that:
        *   Builds the Docker image.
        *   Pushes it to the ECR repository.
5.  **Deploy the Service:**
    *   Run the `terraform-apply` workflow to create the ECS/Fargate infrastructure.
    *   Run the `backend-ci.yml` workflow to deploy the initial version of the placeholder application.
6.  **Document Output:**
    *   The workflow should automatically generate a `PHASE_1_SESSION_5_COMPLETION_REPORT.md` with the ALB DNS name and other details.

### Exit Criteria
- ✅ ECR repository is created.
- ✅ ECS Cluster and Fargate Service are running.
- ✅ A placeholder backend application is successfully deployed and accessible via the ALB endpoint.
- ✅ Session 5 completion report is generated and committed to the `docs/` directory.

---

## 5. Final Verification

After completing all three sessions, a single, comprehensive verification will be performed by the Coordinator Agent. You are required to ensure all completion reports are generated and that all resources are provisioned as described.

**Proceed with execution.**
