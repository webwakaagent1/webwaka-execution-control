# Analysis: Backend Hosting Alternatives to Application Load Balancer (ALB)

**Date:** 2026-01-27  
**Author:** Manus AI (Coordinator Agent)

---

## 1. Problem Statement

The AWS account for the WebWaka project has a service limitation that **prevents the creation of Application Load Balancers (ALBs)**. This directly blocks the original plan for Session 5, which was to use an ALB to route traffic to a backend API running on AWS Fargate.

This document analyzes viable alternative architectures to provide a scalable, secure, and production-ready public endpoint for the backend API without using an ALB.

---

## 2. Evaluated Alternatives

Three primary alternatives were considered to replace the ALB + Fargate architecture.

### Option 1: AWS API Gateway + AWS Lambda

This is a fully serverless approach where API Gateway acts as the front door to the application, and backend code runs as individual AWS Lambda functions.

- **How it Works:** API Gateway receives HTTP requests and triggers a specific Lambda function to process it. The Lambda function contains the business logic (e.g., the Node.js/Express code, adapted to a Lambda handler).
- **ALB Requirement:** None. This architecture completely bypasses the need for any load balancer.

### Option 2: AWS API Gateway + Fargate via VPC Link

This architecture uses API Gateway as the front door but integrates it with the Fargate service running in a private VPC. This requires a Network Load Balancer (NLB).

- **How it Works:** API Gateway routes requests through a VPC Link to a Network Load Balancer (NLB), which then distributes traffic to the Fargate tasks.
- **ALB Requirement:** No ALB is needed, but it **requires an NLB**. This is a critical dependency that may also be restricted by the account limitation.

### Option 3: EC2 Instance with Reverse Proxy (e.g., Nginx)

This is a traditional IaaS (Infrastructure as a Service) approach where a virtual server runs a web server that proxies requests to the backend application.

- **How it Works:** A public-facing EC2 instance runs Nginx, which listens for requests and forwards them to the backend application (which could be running on the same instance or on Fargate).
- **ALB Requirement:** None, but it introduces significant management overhead.

---

## 3. Comparison and Trade-offs

| Feature | API Gateway + Lambda | API Gateway + Fargate (NLB) | EC2 + Nginx |
| :--- | :--- | :--- | :--- |
| **Scalability** | ✅ Excellent (Automatic) | ✅ Excellent (Automatic) | ❌ Poor (Manual) |
| **Management** | ✅ Excellent (Serverless) | 🟡 Good (Managed Containers) | ❌ Poor (Self-Managed VM) |
| **Cost (Low Traffic)** | ✅ Excellent (Pay-per-request) | 🟡 Good (Always-on cost) | 🟡 Good (Always-on cost) |
| **Backend Refactoring** | 🟡 **Required** (Adapt to Lambda handler) | ✅ **None** (Runs standard container) | ✅ **None** (Runs standard container) |
| **Single Point of Failure** | No | No | Yes (unless manually configured for HA) |
| **Alignment with Goals** | Aligns with "max-scale" and modern cloud-native principles. | Aligns with "max-scale" but depends on NLB availability. | Misaligned with "max-scale" and introduces management burden. |

---

## 4. Recommendation

Given the hard constraint of no ALBs, the best path forward is the fully serverless approach.

**Primary Recommendation: Adopt the AWS API Gateway + AWS Lambda architecture.**

**Justification:**
1.  **No Load Balancer Dependency:** This architecture is the only one that is guaranteed to work without requiring any type of load balancer (ALB or NLB).
2.  **Superior Scalability & Resilience:** It is inherently highly available and scales automatically from zero to thousands of requests per second, aligning perfectly with the "max-scale from day one" foundational assumption.
3.  **Cost-Effective:** The pay-per-request model is extremely cost-effective, especially in the early stages of the project.
4.  **Security:** It integrates seamlessly with AWS Cognito (from Session 4) for securing API endpoints.

The primary trade-off is the need to refactor the backend application code to fit the AWS Lambda handler pattern. This is a standard and well-documented process for Node.js applications and represents a one-time effort that enables a more robust and scalable long-term architecture.

**Secondary Option (Contingent):**
If it is confirmed that **only ALBs are restricted but NLBs are allowed**, then `API Gateway + Fargate via VPC Link` becomes a viable, and perhaps simpler, option as it would not require backend code refactoring. However, proceeding with this option carries the risk of being blocked again if NLBs are also restricted.

**Final Conclusion:** To de-risk the project and ensure forward progress, the **API Gateway + Lambda** pattern is the most strategic choice.
