# PENDING DECISION REGISTER — WEBWAKA
## (Updated with Founder Decisions)

**Date:** 2026-01-28  
**Author:** Manus AI  
**Status:** ✅ Reviewed and Decided by Founder

---

## GROUNDING PRINCIPLE (NON-NEGOTIABLE)

**WebWaka is a platform for Partners to deploy SaaS products to their clients using fully built suites, modules, capabilities, and features provided by WebWaka.**

**Partners do not build software on WebWaka. They configure, brand, deploy, and operate products that WebWaka has already fully built.**

This principle governs all architecture, documentation, and implementation.

---

## CATEGORY A: PLATFORM ARCHITECTURE DECISIONS

---

**Decision ID:** D-01  
**Title:** Final Suite Composition and Boundaries

**Founder Decision:** ⚠️ Partially Approved (with correction)

**What Was Decided:**
- We will define a **canonical Suite Blueprint** and **initial reference compositions** now, not exhaustive final contents
- **Lock:** Structure, rules, and boundaries of suites
- **Define:** Mandatory vs optional modules, configuration axes (e.g., SVM vs MVM)
- **Allow:** Controlled expansion during suite build phases

**Correction Applied:**
We are not deferring clarity, but we are avoiding over-freezing too early.

**Status:** ✅ Decided - Proceed with Suite Blueprint definition

---

**Decision ID:** D-02  
**Title:** Formal Hierarchy of Primitives (Suite, Module, Capability, Feature)

**Founder Decision:** ✅ Fully Approved

**What Was Decided:**
Adopt and enforce the strict hierarchy: **Suite > Module > Capability > Feature**

**Clarifications to Enforce Everywhere:**
- **WebWaka owns** Suites and Modules
- **Partners activate** Capabilities and Features
- **Partners do NOT create** primitives

This hierarchy must be reflected in documentation, repo structure, APIs, and governance.

**Status:** ✅ Decided - Enforce in all documentation and code

---

**Decision ID:** D-03  
**Title:** Technical Composition of SVM, MVM, and ParkHub Suites

**Founder Decision:** ⚠️ Approved with Correction

**What Was Decided:**
- **SVM and MVM:** Configuration modes of the Commerce Suite (NOT standalone suites)
- **ParkHub:** A vertical solution bundle composed from Transport + Commerce + Identity (NOT a generic transport app)

**Status:** ✅ Decided - Definitions enforced

---

**Decision ID:** D-04  
**Title:** Technical Strategy for White-Labeling

**Founder Decision:** ✅ Strongly Approved

**What Was Decided:**
Metadata-driven branding is mandatory.

**Additional Constraints:**
- Must support partner-level and client-level overrides
- Must cover UI, domains, email identity, legal text
- Build-time branding is explicitly disallowed

**Status:** ✅ Decided - Implement metadata-driven white-labeling

---

**Decision ID:** D-05  
**Title:** Partner Configuration Model and Boundaries

**Founder Decision:** ✅ Approved (with guardrails)

**What Was Decided:**
JSON-based configuration is correct, but must be strictly constrained.

**Partners Configure:**
- Activated modules/capabilities/features
- Branding
- Pricing overlays (later)

**Partners Do NOT Configure:**
- Business logic

**Additional Requirements:**
Configuration schemas must be versioned, validated, and migratable.

**Status:** ✅ Decided - Implement constrained JSON configuration

---

## CATEGORY B: REPOSITORY & CODEBASE DECISIONS

---

**Decision ID:** D-06  
**Title:** Final Repository Structure

**Founder Decision:** ⚠️ Partially Approved

**What Was Decided:**
- Start with a **monorepo**
- Architect it deliberately for **future polyrepo extraction**

**Requirements:**
- Strict internal boundaries
- No implicit imports
- Clear ownership

**Status:** ✅ Decided - Implement monorepo with extraction-ready architecture

---

**Decision ID:** D-07  
**Title:** Versioning and Release Strategy

**Founder Decision:** ✅ Approved

**What Was Decided:**
Semantic versioning is mandatory.

**Clarifications:**
- Platform version ≠ Suite version ≠ Module version
- Partners must be able to pin versions

**Status:** ✅ Decided - Implement semantic versioning with independent version tracks

---

**Decision ID:** D-08  
**Title:** Shared Package Publishing Strategy

**Founder Decision:** ✅ Approved (conditional)

**What Was Decided:**
- Internal packages within the monorepo are acceptable for now
- External SDKs will eventually require proper publishing

**Status:** ✅ Decided - Use internal packages, plan for future SDK publishing

---

## CATEGORY C: CI/CD & ENVIRONMENT DECISIONS

---

**Decision ID:** D-09  
**Title:** Environment Separation Strategy

**Founder Decision:** ⚠️ Approved, Phased Execution

**What Was Decided:**
Separate AWS accounts are correct long-term, but we will phase this:
- **Early phases:** Single account, strict isolation
- **Before partner onboarding:** Split accounts

**Status:** ✅ Decided - Implement phased account separation

---

**Decision ID:** D-10  
**Title:** CI/CD Automation Strategy

**Founder Decision:** ✅ Strongly Approved

**What Was Decided:**
CI/CD is foundational and must be implemented before significant new feature work.

**Status:** ✅ Decided - Implement CI/CD immediately

---

**Decision ID:** D-11  
**Title:** Deployment Promotion and Rollback Strategy

**Founder Decision:** ✅ Approved

**What Was Decided:**
Manual approval gates for staging and production are mandatory.

**Status:** ✅ Decided - Implement manual approval gates

---

## CATEGORY D: OPERATIONAL & GOVERNANCE DECISIONS

---

**Decision ID:** D-12  
**Title:** Operational Flow for Partner Onboarding

**Founder Decision:** ⚠️ Approved with Reframing

**What Was Decided:**
Partners are operators, not builders.

We will document a V1 onboarding flow now, covering:
- Commercial
- Legal
- Provisioning
- Configuration
- Training

**Status:** ✅ Decided - Document V1 onboarding flow

---

**Decision ID:** D-13  
**Title:** Platform Upgrade Strategy for Partner Tenants

**Founder Decision:** ⚠️ Approved with Additions

**What Was Decided:**
Opt-in upgrades are correct.

**Additions:**
- Mandatory security patches override opt-in
- LTS versions will be introduced later

**Status:** ✅ Decided - Implement opt-in upgrades with security patch override

---

## CATEGORY E: PHASE PLANNING DECISIONS

---

**Decision ID:** D-14  
**Title:** Scope and Definition of Phase 2

**Founder Decision:** ⚠️ Approved with Expansion

**What Was Decided:**
Phase 2 (IAM) must include:
- Partner → Client → User hierarchy
- Tenant isolation
- Capability enforcement
- Hooks for future billing (not billing itself)

**Status:** ✅ Decided - Expand Phase 2 scope accordingly

---

**Decision ID:** D-15  
**Title:** Decision-Making Process for Future Phases

**Founder Decision:** ✅ Strongly Approved

**What Was Decided:**
A formal Phase Gate process is mandatory and aligns with WebWaka's governance model.

**Status:** ✅ Decided - Implement formal Phase Gate process

---

## SUMMARY OF DECISIONS

**Total Decisions:** 15  
**Fully Approved:** 8  
**Approved with Corrections/Additions:** 7  
**Rejected:** 0

**All decisions are now resolved and ready for implementation.**

---

**End of Register**
