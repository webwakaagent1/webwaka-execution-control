# Foundational Assumptions (Canonically Corrected)

**Status:** 🔒 CANONICALLY LOCKED  
**Authority:** Founder  
**Source:** WebWaka Platform Re-Founding Blueprint v5.0, Section 1  
**Last Updated:** 2026-01-28 (Canonical Correction Pass)

---

## Purpose

This document contains the **15 canonically locked foundational assumptions** that govern all WebWaka architecture, tooling, and execution decisions. These assumptions are **non-negotiable** and must be enforced by all operators (Manus, Emergent, Replit).

**Absolute Rule:** Any deviation from these assumptions is a STOP condition and must be escalated immediately to the Founder.

---

## The 15 Foundational Assumptions

### Assumption #1: AWS-First, Single-Bill Architecture

**Statement:** WebWaka will be built AWS-first, with a strong preference for AWS-native services over third-party platforms wherever viable.

**Rationale:** AWS provides a comprehensive ecosystem of services that can scale to meet WebWaka's needs (1,000+ partners, 1M+ tenants, 100M+ users). Using AWS-native services ensures a single bill, simplified operations, and better cost control.

**Implications:**
- **Auth:** AWS Cognito
- **Database:** AWS Aurora PostgreSQL
- **Backend Hosting:** AWS Fargate
- **Frontend Hosting:** AWS Amplify
- **Email:** AWS SES
- **SMS:** AWS SNS
- **Storage:** AWS S3 + CloudFront
- **Analytics:** AWS CloudWatch + Athena + QuickSight
- **Background Jobs:** AWS Lambda
- **Error Tracking:** AWS CloudWatch + X-Ray
- **Queues:** AWS SQS
- **Events:** AWS EventBridge
- **AI:** AWS Bedrock (primary), OpenAI (fallback)

**Exceptions:**
- **Prisma (ORM):** No AWS-native alternative (application-level tool).
- **Africa's Talking (WhatsApp):** AWS does not provide WhatsApp messaging (required for Nigerian market).

---

### Assumption #2: Max-Scale-First Design

**Statement:** WebWaka is designed for maximum scale from day one. Architecture is not phased; only implementation is.

**Rationale:** WebWaka is a Platform for Building Platforms. It must support 1,000+ partners, 1M+ tenants, and 100M+ users. Designing for scale from day one avoids costly refactoring later.

**Scale Assumptions:**
- **Partners:** 1,000+
- **Tenants:** 1,000,000+
- **End Users:** 100,000,000+
- **Transactions:** 1B+ per month
- **Events:** 10B+ per month

---

### Assumption #3: Platform-for-Platforms Vision (WebWaka Builds, Partners Deploy)

**Statement:** WebWaka is not a vertical SaaS. It is a meta-platform that enables partners to deploy and sell their own SaaS businesses. **WebWaka builds everything centrally.** Partners do NOT build, develop, or author features.

**Rationale:** WebWaka's business model is partner-led scale. Partners are the primary customers, not end users. WebWaka builds canonical suites, modules, and capabilities, which partners then deploy, configure, brand, price, and sell.

---

### Assumption #4: PWA-First by Default

**Statement:** Every dashboard, client app, and surface MUST be PWA-installable by default. No WebWaka surface is "web-only." Installability is a baseline requirement.

**Rationale:** Nigeria's mobile-first reality requires PWA-first design. PWAs provide app-like experiences without app store friction, data costs, or device storage constraints.

---

### Assumption #5: Offline-First for Core Actions

**Statement:** Offline capability is MANDATORY for core actions, not optional. Core actions must function offline and sync later. Graceful degradation is required where full offline is not possible.

**Core Actions (Must Work Offline):**
1. POS transactions
2. Lead capture
3. Inventory updates
4. Affiliate link generation
5. Field data collection

**Rationale:** Nigeria's intermittent connectivity reality requires offline-first design.

---

### Assumption #6: Push Notifications as Core Platform Primitive

**Statement:** Push notifications are a first-class system primitive, recursively usable across all hierarchy levels. They are not a "nice-to-have" or UI feature.

**Rationale:** Push notifications are critical for engagement, retention, and real-time communication.

---

### Assumption #7: AI as Core Platform Primitive

**Statement:** AI is a first-class platform primitive, equal to Auth, Billing, and Affiliates. AI is not a feature; it is a core system that integrates with Events, Workflows, Permissions, and Cost Attribution.

**Rationale:** AI is critical for automation, intelligence, and partner differentiation.

**Implications:**
- One unified AI orchestration layer (not separate bots)
- Multi-model support (AWS Bedrock preferred)
- Role-based AI behavior
- Event-driven AI triggers
- Cost attribution per tenant
- Offline-aware AI patterns

---

### Assumption #8: Recursive System Usage Principle

**Statement:** Any system WebWaka uses internally must be available for partners and clients to use for their own platforms.

**Rationale:** WebWaka is a Platform for Building Platforms. Partners must be able to deploy the same systems WebWaka uses to their own clients.

**Examples:**
- If WebWaka uses CRM internally, partners can deploy CRM for their clients
- If WebWaka uses AI orchestration internally, partners can deploy AI for their clients
- If WebWaka uses affiliate tracking internally, partners can deploy affiliate tracking for their clients

---

### Assumption #9: Partner Pricing Autonomy

**Statement:** Partners have full control over their pricing. They set their own retail prices for clients, independent of WebWaka's wholesale prices.

**Rationale:** Partners are the primary customers. They must be able to set their own prices to compete in their markets.

**Implications:**
- Hierarchical pricing model (Global → Partner → Contract → Org)
- Partners can markup WebWaka's wholesale prices
- Partners can offer discounts to their clients
- WebWaka does not control partner pricing

---

### Assumption #10: Configurable Multi-Level Affiliate System

**Statement:** The affiliate system is configurable per partner, per contract, per use case. Level depth is variable (up to 10 levels), not hardcoded.

**Rationale:** Different partners have different affiliate needs. The system must support variable depth and configurable commission structures.

**Implications:**
- Closure table pattern for affiliate hierarchy
- Configurable commission percentages
- Hierarchical override model (Global → Partner → Contract → Org)
- Platform-managed payouts

---

### Assumption #11: Composable Primitives Architecture

**Statement:** WebWaka is built from composable primitives, not monolithic features. Primitives can be combined to create industry-specific suites.

**Rationale:** Composable primitives enable flexibility, extensibility, and future-proofing.

**Examples of Primitives:**
- Auth, Billing, CRM, Inventory, POS, Site Builder, Forms, Automation, Notifications, Analytics, AI, Affiliate, Messaging, Calendar, Reporting

**Examples of Suites (Compositions):**
- Commerce Suite = POS + Inventory + Billing + Analytics
- Education Suite = CRM + Calendar + Forms + Messaging
- Health Suite = CRM + Calendar + Billing + Messaging

---

### Assumption #12: Tenant-Scoped Identity & Data Ownership

**Statement:** User identity is tenant-scoped, not global. Each tenant owns its own data and has full export rights.

**Rationale:** Tenants must own their data and be able to export it at any time.

**Implications:**
- Users can have different identities across tenants
- Tenants can export all their data in standard formats
- Tenants can delete their data at any time
- WebWaka does not own tenant data

---

### Assumption #13: Shared Database + Row-Level Security

**Statement:** WebWaka uses a shared database with row-level security (RLS) for tenant isolation, not separate databases per tenant.

**Rationale:** Separate databases per tenant do not scale to 1M+ tenants. Shared database with RLS is the only viable approach for max-scale-first design.

**Implications:**
- All tenant data is stored in a single Aurora PostgreSQL database
- Row-level security policies enforce tenant isolation
- Every table has a `tenant_id` column
- All queries are automatically filtered by `tenant_id`

---

### Assumption #14: Platform Kill-Switch Authority

**Statement:** WebWaka retains the authority to disable a partner or tenant account for fraud, abuse, or legal reasons.

**Rationale:** WebWaka must be able to protect the platform and other users.

**Implications:**
- WebWaka can disable accounts without prior notice
- WebWaka can suspend accounts pending investigation
- WebWaka can terminate accounts for terms of service violations
- Disabled accounts can be re-enabled after remediation

---

### Assumption #15: Platform Extensibility & Future-Proofing

**Statement:** Every system, module, service, UI, workflow, AI capability, and integration built today MUST be designed such that unknown future capabilities can be added later as plug-ins, without breaking, refactoring, or rewriting existing systems. **WebWaka builds all extensions; partners do not build plugins.**

**Rationale:** WebWaka is designed to evolve for 10–20 years. The platform must be extensible, composable, and future-proof.

**Implications:**
- Event-driven architecture (all systems communicate via events)
- Plug-in system (all features are plug-ins)
- Contracts and interfaces (all APIs are versioned)
- Backward compatibility (old plug-ins must continue to work)
- No closed systems (everything is extensible)

---

## Enforcement

**These assumptions are enforced by:**
1. **Governance rules** in `GOVERNANCE.md`
2. **Phase verification** in `VERIFICATION_STRATEGY.md`
3. **Independent audits** by separate Manus agents
4. **Founder approval** required for phase advancement

**Violation of any assumption is a STOP condition.**

---

**End of Foundational Assumptions**


---

## 16. Addendum: Documentation Structure

To uphold Assumption #15 (Single Source of Truth), the project's documentation is organized into a strict, centralized structure. This is not an assumption but a governing principle derived from it.

| Resource | Location | Master Index / Link |
| :--- | :--- | :--- |
| **Execution Prompts** | `/docs` | `docs/PHASE_1_PROMPT_LINKS.md` |
| **Handover Packages** | `/handover` | `handover/HANDOVER_INDEX.md` |
| **Completion Reports** | `/reports/completion` | `reports/COMPLETION_REPORT_INDEX.md` |
| **Test Reports** | `/reports/testing` | `reports/TEST_REPORT_INDEX.md` |

Refer to `GOVERNANCE.md` and the **Coordinator Handover Package** for complete details.
