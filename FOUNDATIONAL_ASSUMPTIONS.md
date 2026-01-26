# FOUNDATIONAL_ASSUMPTIONS.md

**Status:** 🔒 CANON-LOCKED  
**Authority:** Founder

---

## 1. Introduction

This document contains the **10 canonically locked foundational assumptions** that govern all architectural and implementation decisions for the WebWaka platform. These assumptions are non-negotiable and may only be changed by the Founder.

---

## 2. The 10 Foundational Assumptions

### 2.1. AWS-First, Single-Bill Architecture

- All services must be AWS-native (no third-party SaaS).
- Single AWS bill for all infrastructure.
- Justified exceptions: Prisma (ORM), Africa's Talking (WhatsApp).

### 2.2. Max-Scale-First Design

- 1,000+ Partners
- 1,000,000+ Tenants
- 100,000,000+ Users
- Architecture designed for maximum scale from day one.

### 2.3. Platform-for-Platforms Vision

- Not a vertical SaaS product.
- A platform for building platforms.
- Recursive system usage at all levels.

### 2.4. PWA-First by Default

- Every surface must be PWA-installable.
- No exceptions.

### 2.5. Offline-First for Core Actions

- 5 core actions must work offline: POS, lead capture, inventory, affiliate, field data.
- Mandatory, not optional.

### 2.6. Push Notifications as Core Platform Primitive

- First-class system, recursively usable.
- Event-driven architecture.

### 2.7. AI as Core Platform Primitive

- AI is equal to Auth, Billing, Affiliates.
- One Unified AI Orchestration Layer.
- AI is recursive (Super Admin → Partner → Client → User).
- Multi-model support (AWS Bedrock preferred).
- AI must integrate with Events, Workflows, Permissions, Cost attribution.
- AI must degrade gracefully offline.

### 2.8. Recursive System Usage

- Any system WebWaka uses internally must be available downstream.
- Super Admin → Partners → Clients → End-users.

### 2.9. Partner Pricing Autonomy

- Partners set their own retail prices.
- Hierarchical pricing model.

### 2.10. Platform Extensibility & Future-Proofing

- Everything must be extensible via plug-ins.
- No closed systems, no final forms.
- Event-driven architecture mandatory.
- Backward compatibility mandatory.
- Recursive extensibility at all levels.

---

## 3. Implications

These assumptions have significant implications for the platform's architecture, build order, and governance. All operators must read and understand these assumptions before beginning any work.

---

**End of FOUNDATIONAL_ASSUMPTIONS.md**
