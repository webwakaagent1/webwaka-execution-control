# Phase 1, Session 9 Execution Prompt: Event-Driven Architecture

**Date:** 2026-01-27  
**Issued By:** Manus AI (Coordinator Agent) on behalf of the Founder  
**Status:** ✅ **AUTHORIZED**

---

## 1. Executive Summary

This document authorizes the Implementation Agent to execute **Phase 1, Session 9: Event-Driven Architecture**. The goal is to establish a decoupled, asynchronous processing system using AWS EventBridge and SQS.

**Prerequisite:** Session 5 (Serverless Backend API) must be complete.

---

## 2. Session 9: Event-Driven Architecture

### Objective
Implement a robust event-driven architecture to enable asynchronous communication between different parts of the platform.

### Tasks

1.  **Create an Event Bus and Queue:**
    *   Update Terraform to add an `aws_cloudwatch_event_bus` resource named `webwaka-event-bus`.
    *   Update Terraform to add an `aws_sqs_queue` resource named `webwaka-processing-queue`.

2.  **Create an Event Rule:**
    *   Add an `aws_cloudwatch_event_rule` that listens for events with a specific `source` (e.g., `com.webwaka.api`) on the event bus.
    *   Configure an `aws_cloudwatch_event_target` to send matching events to the `webwaka-processing-queue`.

3.  **Create an Event Publisher:**
    *   Create a new Lambda function (or update the existing one) with an API endpoint (e.g., `/publish-event`).
    *   This endpoint should publish a sample event to the `webwaka-event-bus` using the EventBridge `PutEvents` API.

4.  **Create an Event Consumer:**
    *   Create a new Lambda function named `event-processor`.
    *   Configure an `aws_lambda_event_source_mapping` to trigger the `event-processor` Lambda function when messages arrive in the `webwaka-processing-queue`.
    *   The `event-processor` Lambda should simply log the event it receives to CloudWatch Logs.

5.  **Deploy and Test:**
    *   Run the `terraform-apply` workflow.
    *   Call the `/publish-event` endpoint.
    *   Verify in CloudWatch Logs that the `event-processor` Lambda was invoked and logged the correct event.

6.  **Document Output:**
    *   Generate and commit a `PHASE_1_SESSION_9_COMPLETION_REPORT.md` detailing the event bus, queue, and new Lambda functions.

### Exit Criteria
- ✅ The `webwaka-event-bus` and `webwaka-processing-queue` are created.
- ✅ The EventBridge rule correctly routes events from the bus to the queue.
- ✅ The `/publish-event` endpoint successfully publishes an event.
- ✅ The `event-processor` Lambda is triggered by the SQS message and logs the event.
- ✅ A complete `PHASE_1_SESSION_9_COMPLETION_REPORT.md` is generated and committed.

---

**Proceed with execution once Session 8 is complete.**
