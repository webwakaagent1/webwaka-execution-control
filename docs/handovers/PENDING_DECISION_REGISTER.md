""
# PENDING DECISION REGISTER — WEBWAKA

**Date:** 2026-01-28  
**Author:** Manus AI  
**Purpose:** Enumerate every unresolved decision that must be made for WebWaka to safely and correctly proceed into the next steps and phases.

---

## CATEGORY A: PLATFORM ARCHITECTURE DECISIONS

---

**Decision ID:** D-01  
**Title:** Final Suite Composition and Boundaries

**Description**
What specific, versioned primitives (modules, capabilities) compose each of the 7 canonical industry suites (Retail, Transport, Hospitality, etc.)? How are these boundaries technically defined and enforced?

**Why This Is Unresolved**
Phase 1 focused on foundational infrastructure, not application-level architecture. The website lists suites, but their technical composition has not been defined.

**Impact of Not Deciding Now**
Architectural ambiguity. It is impossible to begin Phase 2/3 suite development without a clear, versioned definition of what constitutes a suite. This will lead to scope creep and inconsistent implementations.

**Options**
*   **Option A:** Define the V1.0 composition for all 7 suites now, before Phase 2 begins. Create a canonical document listing the exact primitives for each.
*   **Option B:** Defer suite definition to the beginning of each suite's respective development phase. Decide the composition of the "Retail Suite" when that phase begins.

**Recommendation**
Option A. Defining the initial composition of all suites upfront provides a clear architectural roadmap, allows for better dependency planning, and prevents architectural drift. It establishes a stable foundation for future phases.

**Decision Authority**
*   Founder (for suite naming and strategic focus)
*   Phase Gate (for technical composition and versioning)

**Urgency Level**
*   Must decide before next phase

---

**Decision ID:** D-02  
**Title:** Formal Hierarchy of Primitives (Suite, Module, Capability, Feature)

**Description**
What is the formal, hierarchical definition of "Suite," "Module," "Capability," and "Feature"? The terms are currently used interchangeably.

**Why This Is Unresolved**
No formal architectural glossary or data model has been established.

**Impact of Not Deciding Now**
Persistent architectural confusion, inconsistent code structure, and difficulty in managing scope and versioning. Developers will not have a shared language.

**Options**
*   **Option A:** Adopt a strict hierarchy: **Suite > Module > Capability > Feature**. A Suite is a collection of Modules. A Module is a collection of Capabilities. A Capability is a collection of Features.
*   **Option B:** Adopt a flatter hierarchy: **Suite > Capability**. A Suite is a collection of Capabilities, and "Module/Feature" are implementation details.

**Recommendation**
Option A. A clear, granular hierarchy is essential for a composable architecture. It allows for more precise versioning, dependency management, and partner configuration.

**Decision Authority**
*   Phase Gate

**Urgency Level**
*   Must decide before next phase

---

**Decision ID:** D-03  
**Title:** Technical Composition of SVM, MVM, and ParkHub Suites

**Description**
What is the specific technical composition of the "SVM (Single Vendor Marketplace)," "MVM (Multi-Vendor Marketplace)," and "ParkHub" suites? How do they relate to the "Commerce" and "Transport" suites?

**Why This Is Unresolved**
The terms were introduced in a correction prompt but are not defined in any canonical document.

**Impact of Not Deciding Now**
The core commerce and transport offerings cannot be designed or built without a clear definition of these fundamental suite types.

**Options**
*   **Option A:** Define SVM and MVM as configurations of a single "Commerce Suite." Define ParkHub as a specialized configuration of the "Transport Suite."
*   **Option B:** Define SVM, MVM, and ParkHub as entirely separate, standalone suites.

**Recommendation**
Option A. Treating them as configurations of broader suites promotes code reuse and aligns with the composable primitives architecture (Assumption #11).

**Decision Authority**
*   Founder

**Urgency Level**
*   Must decide now

---

**Decision ID:** D-04  
**Title:** Technical Strategy for White-Labeling

**Description**
How will white-labeling (partner branding) be technically implemented across the platform? This includes themes, logos, domain masking, and email branding.

**Why This Is Unresolved**
Phase 1 focused on infrastructure, not partner-facing features.

**Impact of Not Deciding Now**
It is impossible to build the partner dashboard or any tenant-facing UI without a clear strategy for how branding is applied and enforced.

**Options**
*   **Option A:** A metadata-driven approach. Partner branding assets (colors, logos, domains) are stored in a database (e.g., DynamoDB) and dynamically applied at runtime by the frontend and backend services.
*   **Option B:** A build-time approach. A separate build process is triggered for each partner, creating a custom-branded version of the application.

**Recommendation**
Option A. A metadata-driven approach is far more scalable and manageable for 1,000+ partners. It avoids a complex and slow build process for every branding change.

**Decision Authority**
*   Phase Gate

**Urgency Level**
*   Must decide before next phase

---

**Decision ID:** D-05  
**Title:** Partner Configuration Model and Boundaries

**Description**
What specific platform aspects can partners "configure"? What is the technical model for storing, versioning, and applying these configurations?

**Why This Is Unresolved**
"Configuration" is a core concept but has not been technically defined.

**Impact of Not Deciding Now**
Development of the partner dashboard and any configurable features is blocked. There is a risk of building a system that is either too rigid or too complex for partners to manage.

**Options**
*   **Option A:** A JSON-based configuration model. Each partner/tenant has a versioned JSON document that defines their activated capabilities, feature flags, and settings. This is stored in the database.
*   **Option B:** A UI-driven configuration model. Configuration is managed through a series of tables in the database, controlled by the partner dashboard UI.

**Recommendation**
Option A. A JSON-based model is more flexible, easier to version, and can be managed both via UI and API, which aligns with the principle of recursive system usage.

**Decision Authority**
*   Phase Gate

**Urgency Level**
*   Must decide before next phase

---

## CATEGORY B: REPOSITORY & CODEBASE DECISIONS

---

**Decision ID:** D-06  
**Title:** Final Repository Structure

**Description**
What is the final, canonical repository structure for the WebWaka ecosystem?

**Why This Is Unresolved**
The current structure is ad-hoc, with code and documentation scattered across three repositories.

**Impact of Not Deciding Now**
Continued disorganization will make the codebase difficult to navigate, manage, and scale. Onboarding new developers will be inefficient.

**Options**
*   **Option A (Monorepo):** A single repository containing all code (frontend, backend, infrastructure, suites) managed with a tool like Turborepo or Nx.
*   **Option B (Polyrepo):** A dedicated repository for each major component: `webwaka-core-backend`, `webwaka-core-frontend`, `webwaka-infra`, and separate repos for each industry suite.

**Recommendation**
Option A (Monorepo). A monorepo simplifies dependency management, promotes code sharing, and makes cross-cutting changes easier to implement and review. It is a modern and scalable approach for a complex, interconnected platform like WebWaka.

**Decision Authority**
*   Phase Gate

**Urgency Level**
*   Must decide now

---

**Decision ID:** D-07  
**Title:** Versioning and Release Strategy

**Description**
What is the strategy for versioning code and managing releases? This includes semantic versioning, changelogs, and release cadence.

**Why This Is Unresolved**
No formal release process has been established. Deployments are manual and unversioned.

**Impact of Not Deciding Now**
It is impossible to safely manage deployments, communicate changes to partners, or handle hotfixes without a clear versioning and release strategy. This is a critical blocker for production readiness.

**Options**
*   **Option A:** Semantic Versioning (Major.Minor.Patch) for all published packages and services. Releases are managed via GitHub Releases with automated changelogs.
*   **Option B:** A simple date-based versioning scheme (YYYY-MM-DD).

**Recommendation**
Option A. Semantic Versioning is the industry standard and provides clear signals about the nature of changes (breaking vs. non-breaking). It is essential for managing a complex dependency graph.

**Decision Authority**
*   Phase Gate

**Urgency Level**
*   Must decide before next phase

---

**Decision ID:** D-08  
**Title:** Shared Package Publishing Strategy

**Description**
How will shared code (e.g., types, UI components, utilities) be packaged and published for consumption across different parts of the platform?

**Why This Is Unresolved**
No strategy exists, leading to the risk of code duplication.

**Impact of Not Deciding Now**
Without a clear strategy, developers will resort to copying code, leading to a maintenance nightmare, inconsistencies, and bugs.

**Options**
*   **Option A:** Use a private npm registry (like GitHub Packages) to publish versioned, shared packages.
*   **Option B:** If using a monorepo, manage internal dependencies directly within the monorepo without publishing to a registry.

**Recommendation**
Option B, assuming a monorepo is chosen (D-06). Managing internal packages within a monorepo is simpler and avoids the overhead of a private registry. If a polyrepo is chosen, Option A is mandatory.

**Decision Authority**
*   Phase Gate

**Urgency Level**
*   Must decide now

---

## CATEGORY C: CI/CD & ENVIRONMENT DECISIONS

---

**Decision ID:** D-09  
**Title:** Environment Separation Strategy

**Description**
What is the strategy for separating Development, Staging, and Production environments?

**Why This Is Unresolved**
Only a single environment currently exists, which is serving as a de-facto production.

**Impact of Not Deciding Now**
Extremely high risk of breaking the live environment with untested changes. It is impossible to develop and test safely.

**Options**
*   **Option A:** Use separate AWS accounts for each environment (Dev, Staging, Prod). This provides the strongest isolation.
*   **Option B:** Use a single AWS account with separate VPCs and resource tagging for each environment.

**Recommendation**
Option A. Separate AWS accounts provide the best security and resource isolation, preventing any possibility of cross-environment interference. This is a best practice for enterprise-grade systems.

**Decision Authority**
*   Founder (due to cost implications of multiple accounts)

**Urgency Level**
*   Must decide now

---

**Decision ID:** D-10  
**Title:** CI/CD Automation Strategy

**Description**
What is the strategy for Continuous Integration and Continuous Deployment (CI/CD)?

**Why This Is Unresolved**
All deployments are currently manual and ad-hoc.

**Impact of Not Deciding Now**
Manual deployments are slow, error-prone, not repeatable, and unscalable. The platform cannot move towards production readiness without CI/CD.

**Options**
*   **Option A:** Implement a comprehensive CI/CD pipeline using GitHub Actions. The pipeline should automate testing, building, and deploying to all environments.
*   **Option B:** Continue with manual deployments for now and defer CI/CD to a later phase.

**Recommendation**
Option A. CI/CD is not a "nice-to-have"; it is a foundational requirement for modern software development. It must be implemented before any significant new features are built.

**Decision Authority**
*   Phase Gate

**Urgency Level**
*   Must decide now

---

**Decision ID:** D-11  
**Title:** Deployment Promotion and Rollback Strategy

**Description**
What is the process for promoting builds between environments (Dev → Staging → Prod) and for rolling back failed deployments?

**Why This Is Unresolved**
No formal promotion or rollback process exists.

**Impact of Not Deciding Now**
High risk of deploying faulty code to production and an inability to recover quickly from deployment failures, leading to extended downtime.

**Options**
*   **Option A (Automated with Manual Gates):** CI/CD automatically deploys to Dev. A manual approval is required to promote to Staging, and another manual approval (by a different person) is required for Production.
*   **Option B (Fully Automated):** Deployments are automatically promoted to all environments upon a successful merge to the main branch.

**Recommendation**
Option A. Manual gates for Staging and Production are a critical safety measure, ensuring that changes are reviewed and approved before impacting users.

**Decision Authority**
*   Phase Gate

**Urgency Level**
*   Must decide before next phase

---

## CATEGORY D: OPERATIONAL & GOVERNANCE DECISIONS

---

**Decision ID:** D-12  
**Title:** Operational Flow for Partner Onboarding

**Description**
What is the detailed, step-by-step operational process for onboarding a new partner, from initial application to their first client deployment?

**Why This Is Unresolved**
The website provides a high-level overview, but the technical and operational details are undefined.

**Impact of Not Deciding Now**
It is impossible to build the partner dashboard or any backend provisioning systems without a clear understanding of the end-to-end onboarding flow.

**Options**
*   **Option A:** Document the V1.0 onboarding flow now, defining the specific manual and automated steps, systems involved (CRM, billing, etc.), and expected timelines.
*   **Option B:** Defer this decision and onboard the first few partners manually to discover the process organically.

**Recommendation**
Option A. Defining the process upfront, even if it's a simple V1.0, is crucial for building the correct underlying systems. It avoids building a technical solution for the wrong problem.

**Decision Authority**
*   Founder

**Urgency Level**
*   Must decide before next phase

---

**Decision ID:** D-13  
**Title:** Platform Upgrade Strategy for Partner Tenants

**Description**
How will platform upgrades (new features, bug fixes) be deployed to active partner tenants without breaking their configurations or client platforms?

**Why This Is Unresolved**
No strategy for managing upgrades in a multi-tenant, partner-led ecosystem has been defined.

**Impact of Not Deciding Now**
High risk of causing widespread disruption to partners and their clients with every platform update. This can destroy trust and lead to churn.

**Options**
*   **Option A (Forced Upgrades):** All partners and tenants are automatically upgraded to the latest version.
*   **Option B (Opt-in Upgrades):** Partners can choose when to upgrade their tenants to a new version, within a certain support window.
*   **Option C (Long-Term Support Versions):** Offer LTS versions that partners can stay on for an extended period.

**Recommendation**
Option B. Opt-in upgrades provide partners with control and stability, allowing them to test new versions before rolling them out to their clients. This is a standard practice for enterprise SaaS platforms.

**Decision Authority**
*   Founder

**Urgency Level**
*   Must decide before next phase

---

## CATEGORY E: PHASE PLANNING DECISIONS

---

**Decision ID:** D-14  
**Title:** Scope and Definition of Phase 2

**Description**
What is the precise scope and definition of "Phase 2: Identity & Access Management"? What are its specific, verifiable exit criteria?

**Why This Is Unresolved**
`EXECUTION_PHASES.md` provides a high-level title but no detailed scope.

**Impact of Not Deciding Now**
Phase 2 cannot be planned or executed without a clear definition of "done." This will lead to scope creep and an indefinite phase.

**Options**
*   **Option A:** Define Phase 2 scope now, including a detailed list of features (e.g., multi-tenancy, RLS, roles, permissions, basic billing hooks) and a set of measurable exit criteria.
*   **Option B:** Begin Phase 2 with a discovery sub-phase to define the scope and exit criteria.

**Recommendation**
Option A. Defining the scope and exit criteria upfront is a core principle of the WebWaka governance model. It ensures clarity, focus, and accountability.

**Decision Authority**
*   Founder

**Urgency Level**
*   Must decide now

---

**Decision ID:** D-15  
**Title:** Decision-Making Process for Future Phases

**Description**
What is the formal process for defining scope, making architectural decisions, and approving exit criteria for all future phases (Phase 3, 4, 5, etc.)?

**Why This Is Unresolved**
The current process has been reactive, driven by directives. A proactive, repeatable process is needed.

**Impact of Not Deciding Now**
Continued ambiguity and inefficiency in phase planning. Decisions will continue to be made on an ad-hoc basis, increasing risk.

**Options**
*   **Option A:** Formalize a "Phase Gate" process. Before each phase begins, a formal review is conducted to approve the scope, architecture, and exit criteria. The review is led by a designated "Architect" and approved by the Founder.
*   **Option B:** Continue with the current directive-driven process.

**Recommendation**
Option A. A formal Phase Gate process provides structure, predictability, and rigor. It ensures that all stakeholders are aligned and that decisions are made deliberately and transparently.

**Decision Authority**
*   Founder

**Urgency Level**
*   Must decide now

---

**End of Register**
""
