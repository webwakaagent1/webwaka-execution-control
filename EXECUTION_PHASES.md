# Execution Phases

**Status:** 🔒 CANON-LOCKED  
**Authority:** Founder  
**Last Updated:** 2026-01-26 (Phase 0 Remediation)

---

## 1. Purpose

This document defines the **strictly sequential execution phases** for the WebWaka platform. Each phase represents a major milestone and has explicit entry criteria, exit criteria, and completion verification requirements.

**Key Principle:** No phase may begin until the previous phase is 100% complete, independently verified, and approved by the Founder.

---

## 2. Phase Sequencing Rules

1. **Phases MUST be executed sequentially** (no skipping, no parallel execution)
2. **Phase N+1 cannot begin until Phase N is complete**
3. **Phase N is complete when:**
   - All exit criteria are met
   - Independent verification passes (no CRITICAL or HIGH findings)
   - Founder approval is granted
4. **Technical enforcement:** GitHub Actions workflow (`phase-gate.yml`) enforces phase sequencing

---

## 3. Phase 0: Execution Control & Governance

**Status:** ✅ COMPLETE (Pending Founder Approval)

**Objective:** Build the system that will execute WebWaka, NOT the product itself.

**Duration:** 1-2 weeks

**Entry Criteria:**
- Founder issues Phase 0 execution prompt

**Deliverables:**
1. `webwaka-execution-control` GitHub repository
2. GOVERNANCE.md (governance rules)
3. FOUNDATIONAL_ASSUMPTIONS.md (15 canonically locked assumptions)
4. EXECUTION_LEDGER.md (decision and progress log template)
5. EXECUTION_PHASES.md (phase definitions)
6. VERIFICATION_STRATEGY.md (verification methods)
7. STOP_SAFE_PROTOCOL.md (stop-safe protocol)
8. PHASE_1_EXECUTION_PROMPT.md (Phase 1 template)
9. Phase-gate automation (GitHub Actions workflow)

**Exit Criteria:**
1. All required documents exist in the repository
2. All documents are internally consistent (no contradictions)
3. All documents are consistent with each other
4. All documents align with the 15 foundational assumptions
5. All documents align with the WebWaka Platform Re-Founding Blueprint v5.0
6. All governance mechanisms are defined and enforceable
7. Independent verification passes (no CRITICAL or HIGH findings)
8. Founder approval is granted

**Verification Method:** Non-code phase verification (see VERIFICATION_STRATEGY.md Section 3.1)

---

## 4. Phase 1: Core Infrastructure

**Status:** ⏳ AWAITING PHASE 0 APPROVAL

**Objective:** Establish the core AWS infrastructure and foundational services required for all subsequent phases.

**Duration:** 3-6 months

**Entry Criteria:**
1. Phase 0 is complete (all exit criteria met)
2. Phase 0 independent verification passes
3. Phase 0 Founder approval is granted
4. Founder issues Phase 1 execution prompt with AWS account information

**Deliverables:**
1. `webwaka-platform` GitHub repository (private)
2. AWS account setup and configuration
3. AWS Cognito (Authentication)
4. AWS Aurora PostgreSQL (Database)
5. AWS Fargate (Backend Hosting)
6. AWS Amplify (Frontend Hosting)
7. AWS SES (Email)
8. AWS SNS (Push Notifications)
9. AWS S3 + CloudFront (Storage)
10. AWS EventBridge (Events)
11. AWS SQS (Queues)
12. AWS Bedrock (AI)
13. Service Workers + IndexedDB (Offline)
14. PWA Manifest + Install Prompt
15. Extensibility Framework (Plug-in system)

**Exit Criteria:**

**Technical Exit Criteria (1-13):** These must be met for the phase to be "technically complete."

1. **AWS Infrastructure:** All 12 AWS services (Cognito, Aurora, Fargate, Amplify, SES, SNS, S3, CloudFront, EventBridge, SQS, Bedrock, Secrets Manager) are provisioned, configured, and verified via AWS Console
2. **Authentication:** User can register, log in, log out, and reset password via Cognito; JWT tokens are validated on all API requests; session management works correctly
3. **Backend API:** At least 5 core API endpoints (auth, health check, user profile, tenant context, event publish) are deployed to Fargate, return correct responses, and have response times < 500ms
4. **Frontend:** PWA is deployed to Amplify, accessible via HTTPS, loads in < 3 seconds, and passes Lighthouse PWA audit with score ≥ 90
5. **Email & Notifications:** SES can send transactional emails (registration, password reset); SNS can send push notifications; delivery rate ≥ 95%
6. **File Storage:** S3 can accept file uploads; CloudFront can serve files; upload and download work for files up to 100MB
7. **Event-Driven Architecture:** EventBridge can receive and route events; SQS can queue and process events; at least 3 event types are defined and working
8. **AI Orchestration:** AI orchestration layer can invoke at least one model (e.g., Bedrock Claude); API response time < 5 seconds; error handling works correctly
9. **PWA & Offline:** PWA is installable on mobile and desktop; service worker caches critical assets; at least 3 core actions work offline (e.g., view contacts, create lead, view inventory)
10. **Extensibility:** Plug-in system can load, initialize, and execute at least one basic plug-in; plug-in API is documented
11. **Test Coverage:** Unit test coverage ≥ 80% for all new code; integration tests cover all API endpoints; E2E tests cover critical user flows (register, login, create tenant)
12. **Documentation:** README.md, API documentation, deployment guide, and architecture diagrams are complete and accurate
13. **Independent Verification:** Independent verification report shows zero CRITICAL findings and zero HIGH findings

**Approval (14):** This marks the phase as "officially complete."

14. **Founder Approval:** Founder has reviewed the verification report and granted explicit approval via GitHub issue with `founder-approved` label

**Note:** A phase is "technically complete" when criteria 1-13 are met. It is "officially complete" when criterion 14 (Founder approval) is met. Only after official completion can the next phase begin.

**Verification Method:** Code phase verification (see VERIFICATION_STRATEGY.md Section 3.2)

**Sub-Phases:**
- 1.1: AWS Account Setup (Week 1)
- 1.2: Database Infrastructure (Week 2-3)
- 1.3: Authentication (Week 4-5)
- 1.4: Backend API (Week 6-8)
- 1.5: Frontend Hosting (Week 9-10)
- 1.6: Email & Notifications (Week 11-12)
- 1.7: Storage & CDN (Week 13-14)
- 1.8: Event-Driven Architecture (Week 15-16)
- 1.9: PWA & Offline (Week 17-20)
- 1.10: Integration & Testing (Week 21-24)

---

## 5. Phase 2: Identity & Access Management (IAM)

**Status:** ⏳ AWAITING PHASE 1 COMPLETION

**Objective:** Implement the complete recursive IAM model (Partners → Tenants → Users).

**Duration:** 2-3 months

**Entry Criteria:**
1. Phase 1 is complete (all exit criteria met)
2. Phase 1 independent verification passes
3. Phase 1 Founder approval is granted

**Deliverables:**
1. Partner & Tenant Hierarchy (Closure Table model)
2. Role-Based Access Control (RBAC) system
3. User & Group Management
4. Hierarchical permissions
5. Tenant-scoped identity

**Exit Criteria (SMART):**
1. **Partner Hierarchy:** Partners can create sub-partners and tenants; closure table correctly represents hierarchy; queries for "all descendants" and "all ancestors" work correctly and return in < 100ms
2. **RBAC System:** At least 10 predefined roles exist (Super Admin, Partner Admin, Tenant Admin, User, etc.); custom roles can be created; permissions can be assigned at all levels
3. **User Management:** Users can be created, updated, and deleted within tenants; user data is correctly scoped to tenant; cross-tenant data leakage is prevented (verified via security audit)
4. **Permission Enforcement:** All API endpoints enforce permissions; unauthorized access returns 403; permission checks are tested for all roles and resources
5. **Test Coverage:** Unit test coverage ≥ 85% for IAM module; integration tests cover all permission scenarios; E2E tests cover user creation, role assignment, and permission enforcement
6. **Documentation:** IAM architecture diagram, RBAC model documentation, and API documentation are complete
7. **Independent Verification:** Independent verification report shows zero CRITICAL findings and zero HIGH findings
8. **Founder Approval:** Founder has reviewed the verification report and granted explicit approval

**Verification Method:** Code phase verification

---

## 6. Phase 3: Core Platform Primitives

**Status:** ⏳ AWAITING PHASE 2 COMPLETION

**Objective:** Implement the core platform primitives that will be used by all other systems.

**Duration:** 4-6 months

**Entry Criteria:**
1. Phase 2 is complete (all exit criteria met)
2. Phase 2 independent verification passes
3. Phase 2 Founder approval is granted

**Deliverables:**
1. CRM Primitive (Contacts, Companies, Deals)
2. Automation Primitive (Workflows, Triggers, Actions)
3. Communication Primitive (Email, SMS, WhatsApp via Africa's Talking)
4. Forms Primitive (Form Builder, Submissions)
5. Calendar Primitive (Events, Bookings)
6. Billing & Monetization Primitive (Centralized billing, Invoices, Payments)
7. Affiliate Primitive (Multi-level affiliate system with Closure Table)
8. Site Builder Primitive (Drag-and-drop site builder)
9. Reporting & Analytics Primitive (Dashboards, Reports)

**Exit Criteria (SMART):**
1. **Primitive Functionality:** All 9 core primitives (CRM, Automation, Communication, Forms, Calendar, Billing, Affiliate, Site Builder, Reporting) are functional and can perform their core operations
2. **Recursive Usage:** All primitives can be used at all levels (Super Admin → Partner → Tenant → User); tenant-scoped data is correctly isolated; RLS is enforced
3. **AI Integration:** All primitives can invoke AI orchestration layer for at least one use case (e.g., CRM can generate contact summaries; Automation can generate workflow suggestions)
4. **Event Integration:** All primitives emit events to EventBridge; at least 20 event types are defined; event-driven workflows work correctly
5. **Offline Support:** At least 5 core actions per primitive work offline (where applicable); offline data syncs correctly when online; conflict resolution works
6. **Test Coverage:** Unit test coverage ≥ 85% for all primitives; integration tests cover all primitive interactions; E2E tests cover critical user flows for each primitive
7. **Documentation:** Architecture diagrams, API documentation, and user guides are complete for all primitives
8. **Independent Verification:** Independent verification report shows zero CRITICAL findings and zero HIGH findings
9. **Founder Approval:** Founder has reviewed the verification report and granted explicit approval

**Verification Method:** Code phase verification

---

## 7. Phase 4: Commerce Suites

**Status:** ⏳ AWAITING PHASE 3 COMPLETION

**Objective:** Implement the four core commerce suites for the Nigerian market.

**Duration:** 4-6 months

**Entry Criteria:**
1. Phase 3 is complete (all exit criteria met)
2. Phase 3 independent verification passes
3. Phase 3 Founder approval is granted

**Deliverables:**
1. POS Suite (Point of Sale for retail)
2. ParkHub Suite (Parking management)
3. SVM Suite (Smart Vending Machine)
4. MVM Suite (Micro-Vending Machine)

**Exit Criteria (SMART):**
1. **Suite Functionality:** All 4 commerce suites (POS, ParkHub, SVM, MVM) are functional and can perform their core operations (e.g., POS can process sales; ParkHub can manage parking slots)
2. **Tenant Usage:** Tenants can enable/disable suites; suite data is correctly scoped to tenant; cross-tenant data leakage is prevented
3. **Offline Support:** All core actions work offline (e.g., POS can process sales offline; ParkHub can record parking entries offline); offline data syncs correctly when online
4. **Primitive Integration:** All suites integrate with at least 5 core primitives (e.g., POS integrates with CRM, Billing, Reporting, Automation, Communication)
5. **Test Coverage:** Unit test coverage ≥ 85% for all suites; integration tests cover all suite-primitive interactions; E2E tests cover critical user flows for each suite
6. **Documentation:** User guides, API documentation, and setup instructions are complete for all suites
7. **Independent Verification:** Independent verification report shows zero CRITICAL findings and zero HIGH findings
8. **Founder Approval:** Founder has reviewed the verification report and granted explicit approval

**Verification Method:** Code phase verification

---

## 8. Phase 5: Multi-Industry Expansion

**Status:** ⏳ AWAITING PHASE 4 COMPLETION

**Objective:** Expand the platform to support multiple industries beyond commerce.

**Duration:** 6-9 months

**Entry Criteria:**
1. Phase 4 is complete (all exit criteria met)
2. Phase 4 independent verification passes
3. Phase 4 Founder approval is granted

**Deliverables:**
1. Education Suite (Schools, Courses, Students)
2. Health Suite (Clinics, Appointments, Patients)
3. Civic Suite (Government services, Permits)
4. Hospitality Suite (Hotels, Restaurants, Bookings)
5. Logistics Suite (Delivery, Tracking, Fleet management)

**Exit Criteria:**
1. All five industry suites are functional
2. All suites can be used by tenants
3. All suites integrate with core primitives
4. All tests pass (unit, integration, E2E)
5. All documentation is complete
6. Independent verification passes (no CRITICAL or HIGH findings)
7. Founder approval is granted

**Verification Method:** Code phase verification

---

## 9. Phase 6: Partner Extensibility (Optional)

**Status:** ⏳ AWAITING PHASE 5 COMPLETION

**Objective:** Enable partners to create their own industry-specific modules using the extensibility framework.

**Duration:** 3-4 months

**Entry Criteria:**
1. Phase 5 is complete (all exit criteria met)
2. Phase 5 independent verification passes
3. Phase 5 Founder approval is granted
4. Founder decides to proceed with partner extensibility

**Deliverables:**
1. Partner SDK (Software Development Kit)
2. Module marketplace
3. Module approval workflow
4. Module sandboxing and security

**Exit Criteria:**
1. Partners can create custom modules
2. Modules can be published to the marketplace
3. Modules can be installed by other partners
4. All tests pass (unit, integration, E2E)
5. All documentation is complete
6. Independent verification passes (no CRITICAL or HIGH findings)
7. Founder approval is granted

**Verification Method:** Code phase verification

---

## 10. Phase Reconciliation with Blueprint v5.0

**This document is aligned with the WebWaka Platform Re-Founding Blueprint v5.0.**

**Key Alignments:**
- All 15 foundational assumptions are enforced
- AWS-first architecture is maintained
- Max-scale-first design is maintained
- PWA-first and offline-first are maintained
- AI as core platform primitive is maintained
- Platform extensibility is maintained
- Recursive system usage is maintained

**Differences from Blueprint v5.0:**
- Blueprint v5.0 defines the "what" and "why" (architecture, principles, decisions)
- This document defines the "when" and "how" (execution order, verification, approval)

---

## 11. Document Updates

This document may only be updated by the Founder or with explicit Founder approval.

---

**End of Execution Phases**


---

## Documentation

All documentation related to execution, including prompts and completion reports, must adhere to the centralized documentation structure outlined in `GOVERNANCE.md`. Refer to the master indexes for all links in that document to locate any specific document and in the Coordinator Handover Package for the location of all documents.
