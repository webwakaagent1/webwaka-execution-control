# Phase 1, Session 11 Execution Prompt: PWA & Offline Support

**Date:** 2026-01-27  
**Issued By:** Manus AI (Coordinator Agent) on behalf of the Founder  
**Status:** ✅ **AUTHORIZED**

---

## 1. Executive Summary

This document authorizes the Implementation Agent to execute **Phase 1, Session 11: PWA & Offline Support**. The goal is to make the frontend application installable and functional while offline.

**Prerequisite:** Session 6 (Frontend Hosting) must be complete.

---

## 2. Session 11: PWA & Offline Support

### Objective
Enhance the frontend application to become a Progressive Web App (PWA) with core offline capabilities.

### Tasks

1.  **Implement a Service Worker:**
    *   Use a library like `workbox` to simplify service worker creation and management.
    *   Configure the service worker to cache the application shell (HTML, CSS, JS) and static assets.
    *   Implement a network-first or stale-while-revalidate caching strategy for API calls.

2.  **Implement IndexedDB Caching:**
    *   Use a library like `idb` to simplify IndexedDB interactions.
    *   Store results from API calls (e.g., the "Hello World" message) in IndexedDB.
    *   When the application loads, it should first try to display data from IndexedDB, then fetch fresh data from the network.

3.  **Create a PWA Manifest:**
    *   Create a `manifest.json` file for the frontend application.
    *   Include the application name, icons, start URL, display mode, and theme color.

4.  **Implement Install Prompt:**
    *   Add logic to the frontend to detect when the app can be installed and show a custom "Install App" button to the user.

5.  **Deploy and Test:**
    *   Run the `frontend-ci.yml` workflow to deploy the updated application.
    *   Test the offline functionality by:
        1.  Loading the application.
        2.  Disconnecting from the network (using browser dev tools).
        3.  Reloading the page and verifying that the application still loads and displays cached data.
    *   Test the PWA installation on both desktop and mobile.

6.  **Document Output:**
    *   Generate and commit a `PHASE_1_SESSION_11_COMPLETION_REPORT.md` detailing the PWA and offline capabilities that were implemented.

### Exit Criteria
- ✅ The application has a functional service worker.
- ✅ The application shell and API data are cached for offline use.
- ✅ The application is installable as a PWA on desktop and mobile.
- ✅ The application loads and displays data correctly while offline.
- ✅ A complete `PHASE_1_SESSION_11_COMPLETION_REPORT.md` is generated and committed.

---

**Proceed with execution once Session 10 is complete.**


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
