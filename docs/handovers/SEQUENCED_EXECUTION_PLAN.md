# Sequenced Execution Plan for WebWaka Decisions

**Date:** 2026-01-28  
**Author:** Manus AI  
**Purpose:** Propose a sequenced execution plan for resolving the 15 decided items from the Pending Decision Register.

---

## GROUNDING PRINCIPLE

This plan is sequenced to resolve foundational decisions first, enabling subsequent work to proceed on a stable and correct basis. The sequence prioritizes unblocking the Controlled Completion of Phase 1 and the formal start of Phase 2.

---

## PROPOSED EXECUTION SEQUENCE

### **IMMEDIATE ACTIONS (This Week)**

These actions are foundational and must be completed before any other work.

**1. Establish Canonical Governance Documents (1-2 days)**
   - **What:** Create and ratify the foundational governance and architectural documents based on the Founder's decisions.
   - **Decisions Implemented:** D-01, D-02, D-03, D-05, D-12, D-15
   - **Artifacts to Produce:**
     - `SUITE_BLUEPRINT.md`: Defines the structure, rules, and boundaries of suites.
     - `ARCHITECTURAL_HIERARCHY.md`: Defines Suite > Module > Capability > Feature.
     - `CANONICAL_DEFINITIONS.md`: Defines SVM, MVM, ParkHub, and other key terms.
     - `PARTNER_CONFIGURATION_MODEL.md`: Defines the JSON-based configuration model.
     - `PARTNER_ONBOARDING_V1.md`: Defines the V1 operational onboarding flow.
     - `PHASE_GATE_PROCESS.md`: Defines the formal process for future phase planning.

**2. Reorganize to Monorepo (2-3 days)**
   - **What:** Consolidate all existing code from `webwaka-execution-control`, `webwaka-infrastructure`, and `webwaka-handover-analysis` into a single new monorepo.
   - **Decisions Implemented:** D-06, D-08
   - **Artifacts to Produce:**
     - A new `webwaka` monorepo on GitHub.
     - A `README.md` explaining the monorepo structure.
     - All existing code migrated and organized with clear internal boundaries.

**3. Implement Foundational CI/CD (3-5 days)**
   - **What:** Implement a baseline CI/CD pipeline using GitHub Actions in the new monorepo.
   - **Decisions Implemented:** D-10, D-11
   - **Artifacts to Produce:**
     - A `ci.yml` workflow that automates testing and building on every push.
     - A `deploy.yml` workflow with manual approval gates for deploying to a (temporary) single environment.

---

### **CONTROLLED COMPLETION OF PHASE 1 (Next 1-2 Weeks)**

Once the immediate actions are complete, proceed with the controlled completion of Phase 1.

**4. Complete Phase 1 Technical Work (5-7 days)**
   - **What:** Complete the remaining technical work for Phase 1 as defined in the Founder Directive.
   - **Tasks:**
     - Minimal AI orchestration wiring (Session 10).
     - PWA baseline reintegration into the frontend.
     - Fix all failing tests to achieve a normalized pass rate.

**5. Independent Verification of Phase 1 (1-2 days)**
   - **What:** Conduct a final, independent verification of all 14 Phase 1 exit criteria.
   - **Artifacts to Produce:**
     - `PHASE_1_VERIFICATION_REPORT.md`

---

### **PHASE 2 PREPARATION (Following Phase 1 Completion)**

Once Phase 1 is verified and closed, prepare for Phase 2.

**6. Define Phase 2 Scope and Exit Criteria (2-3 days)**
   - **What:** Formally define the scope and exit criteria for Phase 2 (IAM) based on the Founder's expanded definition.
   - **Decisions Implemented:** D-14
   - **Artifacts to Produce:**
     - `PHASE_2_SCOPE_AND_EXIT_CRITERIA.md`

**7. Implement Phased Environment Strategy (Ongoing)**
   - **What:** Begin planning for the separation of AWS accounts, to be completed before the first partner is onboarded.
   - **Decisions Implemented:** D-09

**8. Implement Versioning and Upgrade Strategy (Ongoing)**
   - **What:** Begin implementing semantic versioning and the opt-in upgrade mechanism as part of the Phase 2 build-out.
   - **Decisions Implemented:** D-07, D-13

---

## PROPOSED TIMELINE

| Phase | Duration | Key Activities |
| :--- | :--- | :--- |
| **Immediate Actions** | 1 Week | Governance Docs, Monorepo, Foundational CI/CD |
| **Phase 1 Completion** | 1-2 Weeks | AI Wiring, PWA Reintegration, Test Fixes, Verification |
| **Phase 2 Prep** | 1 Week | Phase 2 Scope Definition, Environment & Versioning Planning |

**Total Estimated Time to Start of Phase 2 Execution: 3-4 Weeks**

---

## NEXT STEPS

1. **Founder Approval:** Request approval for this sequenced execution plan.
2. **Execute Immediate Actions:** Begin with the creation of canonical governance documents.

---

**End of Plan**
