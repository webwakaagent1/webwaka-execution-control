# WebWaka Documentation Governance Protocol

**Version**: 1.0  
**Effective Date**: January 27, 2026  
**Authority**: Canonical Documentation Steward (Role A)  
**Status**: ACTIVE

---

## 1. Core Principles

### 1.1 Single Source of Truth

**Notion is the canonical source** for all WebWaka platform documentation.

- All authoritative documents MUST exist in Notion
- GitHub serves as a **versioned backup** and **code-adjacent reference**
- Any conflicts between Notion and GitHub are resolved in favor of Notion
- Manus session artifacts are **ephemeral** and MUST be archived to Notion after completion

### 1.2 No Duplication

- Documents MUST NOT be duplicated across multiple locations
- If a document exists in multiple places, the Notion version is authoritative
- Deprecated documents MUST be clearly marked and archived

### 1.3 Traceability

- Every document MUST have a clear source and version history
- Changes MUST be traceable to a specific author and date
- Cross-references MUST be maintained in the Cross-Reference Index

---

## 2. Document Categories

### 2.1 Constitution Documents

**Location**: Notion → WebWaka Constitution  
**GitHub Sync**: Required  
**Update Authority**: Requires founder approval via GitHub PR

**Documents**:
- FOUNDATIONAL_ASSUMPTIONS.md
- GOVERNANCE.md
- EXECUTION_PHASES.md
- VERIFICATION_STRATEGY.md
- STOP_SAFE_PROTOCOL.md

**Update Protocol**:
1. Propose changes via GitHub Pull Request
2. Obtain founder approval (label: `founder-approved`)
3. Merge to GitHub main branch
4. Sync changes to Notion within 24 hours
5. Update Cross-Reference Index

### 2.2 Phase Execution Documents

**Location**: Notion → Platform Phases → Phase N  
**GitHub Sync**: Required  
**Update Authority**: Phase execution Manus + founder approval

**Documents**:
- PHASE_N_EXECUTION_PROMPT.md
- PHASE_N_FINAL_COMPLETION_REPORT.md
- Phase-specific infrastructure and standards

**Update Protocol**:
1. Updates made in Notion first (living document during phase execution)
2. At phase completion, finalize in Notion
3. Export to GitHub as markdown
4. Create GitHub PR with `phase-completion` label
5. Obtain founder approval
6. Merge and update Cross-Reference Index

### 2.3 Verification & Audit Reports

**Location**: Notion → Verification & Audit Reports  
**GitHub Sync**: Optional (recommended for transparency)  
**Update Authority**: Independent Verification Manus (IVM) only

**Documents**:
- Phase0_IVM_Verification_Report.md
- REQUIRED_FIXES_BEFORE_PHASE_1.md
- Findings trackers and analysis documents

**Update Protocol**:
1. IVM creates reports in Manus session
2. IVM migrates reports to Notion at session end
3. Reports are **immutable** once published
4. Corrections require a new versioned report (e.g., v1.1)
5. Optionally sync to GitHub for transparency

### 2.4 Infrastructure & Standards

**Location**: Notion → Platform Phases → Phase 0  
**GitHub Sync**: Required (these are operational documents)  
**Update Authority**: Platform architect + founder approval

**Documents**:
- PLATFORM_INFRASTRUCTURE.md
- REPOSITORY_STANDARDS.md
- phase-gate.yml

**Update Protocol**:
1. Propose changes via GitHub PR
2. Obtain founder approval
3. Merge to GitHub
4. Sync to Notion within 24 hours
5. Update Cross-Reference Index

---

## 3. Roles and Responsibilities

### 3.1 Canonical Documentation Steward (Role A)

**Primary Responsibilities**:
- Maintain Notion workspace structure
- Ensure bidirectional sync between Notion and GitHub
- Update Cross-Reference Index when documents are added/moved/archived
- Prevent documentation duplication
- Enforce this governance protocol

**Authority**:
- Read/write access to Notion workspace
- Read access to GitHub repository
- Can propose PRs but cannot approve them

**Accountability**:
- Reports to founder
- Must maintain sync within 24 hours of changes
- Must update Cross-Reference Index within 48 hours

### 3.2 Phase Execution Manus

**Primary Responsibilities**:
- Create and update phase execution documents
- Produce phase completion reports
- Archive phase artifacts to Notion

**Authority**:
- Write access to Notion (phase-specific pages only)
- Can propose GitHub PRs for phase completion
- Cannot modify constitution documents

**Accountability**:
- Reports to founder
- Must deliver phase completion report
- Must archive all phase artifacts before phase end

### 3.3 Independent Verification Manus (IVM)

**Primary Responsibilities**:
- Conduct independent audits of phase completion
- Produce verification reports
- Identify risks and blocking issues

**Authority**:
- Read-only access to all documentation
- Write access to Notion (Verification & Audit Reports section only)
- Cannot modify any documents under audit

**Accountability**:
- Reports to founder
- Must deliver verification report within 48 hours of audit start
- Must archive all audit artifacts to Notion

### 3.4 Founder

**Primary Responsibilities**:
- Approve all constitution changes
- Approve phase completion
- Resolve governance disputes

**Authority**:
- Full access to Notion and GitHub
- Final decision authority on all documentation matters
- Can override this governance protocol

**Accountability**:
- Must respond to approval requests within 72 hours
- Must explicitly approve (not implicit approval)

---

## 4. Sync Protocols

### 4.1 GitHub → Notion Sync

**Trigger**: When a PR is merged to GitHub main branch

**Process**:
1. Documentation Steward receives notification (manual or automated)
2. Steward reviews changed files
3. Steward updates corresponding Notion pages
4. Steward adds "Last synced from GitHub" property with commit hash
5. Steward updates Cross-Reference Index

**SLA**: Within 24 hours of merge

### 4.2 Notion → GitHub Sync

**Trigger**: When a phase completion report is finalized in Notion

**Process**:
1. Documentation Steward exports Notion page as markdown
2. Steward creates GitHub PR with exported content
3. Steward adds `phase-completion` label
4. Founder reviews and approves
5. Steward merges PR
6. Steward updates Cross-Reference Index

**SLA**: Within 48 hours of finalization

### 4.3 Conflict Resolution

If Notion and GitHub diverge:

1. **Identify the conflict**: Document what differs
2. **Determine authority**: Which version is authoritative per this protocol?
3. **Resolve in favor of Notion**: Notion always wins unless founder overrides
4. **Update GitHub**: Sync GitHub to match Notion
5. **Document the resolution**: Add note to Cross-Reference Index

---

## 5. Document Lifecycle

### 5.1 Creation

1. Document is created in Notion first
2. Creator adds metadata (author, date, purpose)
3. Creator notifies Documentation Steward
4. Steward adds entry to Cross-Reference Index
5. If document requires GitHub sync, Steward creates PR

### 5.2 Updates

1. Updates are made in the authoritative location (per Section 2)
2. Updater notifies Documentation Steward
3. Steward syncs to other locations per protocol
4. Steward updates Cross-Reference Index with new version

### 5.3 Deprecation

1. Document is marked as **[DEPRECATED]** in title
2. Deprecation notice is added to top of document with:
   - Deprecation date
   - Reason for deprecation
   - Link to replacement document (if any)
3. Document is moved to "Archived" section in Notion
4. Cross-Reference Index is updated with deprecation status

### 5.4 Deletion

Documents MUST NOT be deleted. Instead, they MUST be deprecated and archived.

**Exception**: Test documents or drafts that were never finalized may be deleted with founder approval.

---

## 6. Quality Standards

### 6.1 Markdown Format

All documents MUST be written in GitHub-flavored Markdown.

**Required elements**:
- Title (H1)
- Metadata section (version, date, author)
- Table of contents (for documents > 500 words)
- Proper heading hierarchy (H1 → H2 → H3)

### 6.2 Metadata

Every document MUST include:
- **Version**: Semantic versioning (e.g., 1.0, 1.1, 2.0)
- **Last Updated**: ISO 8601 date (YYYY-MM-DD)
- **Author**: Role or name
- **Status**: DRAFT | ACTIVE | DEPRECATED

### 6.3 Cross-References

When referencing another document:
- Use Notion page links within Notion
- Use relative GitHub links in GitHub
- Always include the full document title

### 6.4 Accessibility

- Use clear, professional language
- Avoid jargon unless defined
- Include examples where appropriate
- Use tables for structured data

---

## 7. Enforcement

### 7.1 Violations

Violations of this protocol include:
- Creating duplicate documents
- Failing to sync within SLA
- Modifying documents without authority
- Deleting documents without deprecation

### 7.2 Consequences

- **First violation**: Warning from Documentation Steward
- **Second violation**: Report to founder
- **Third violation**: Loss of write access

### 7.3 Exceptions

Founder may grant exceptions to this protocol on a case-by-case basis.

---

## 8. Review and Updates

### 8.1 Review Schedule

This protocol MUST be reviewed:
- At the end of each phase
- When a governance issue arises
- Annually (whichever comes first)

### 8.2 Update Process

1. Propose changes via GitHub PR
2. Obtain founder approval
3. Update this document in Notion
4. Sync to GitHub
5. Notify all roles of changes

---

## 9. Emergency Procedures

### 9.1 Notion Outage

If Notion is unavailable:
1. Use GitHub as temporary source of truth
2. Document all changes made during outage
3. Sync changes to Notion when service is restored
4. Update Cross-Reference Index

### 9.2 GitHub Outage

If GitHub is unavailable:
1. Continue using Notion as normal
2. Queue GitHub syncs for when service is restored
3. Document all queued syncs
4. Execute syncs when service is restored

### 9.3 Data Loss

If data is lost in Notion or GitHub:
1. Immediately notify founder
2. Restore from most recent backup
3. Document what was lost
4. Recreate lost content if backup is unavailable
5. Update Cross-Reference Index

---

## 10. Contact

For questions about this protocol:
- **Email**: webwaka.agent.1@gmail.com
- **Notion**: WebWaka-Agent-1's Space
- **GitHub**: webwaka-execution-control repository

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0 | 2026-01-27 | Initial governance protocol | Documentation Steward |

---

## Appendix A: Quick Reference

### Document Update Checklist

- [ ] Update document in authoritative location
- [ ] Notify Documentation Steward
- [ ] Steward syncs to other locations (if required)
- [ ] Steward updates Cross-Reference Index
- [ ] Obtain founder approval (if required)
- [ ] Verify sync completed successfully

### New Document Checklist

- [ ] Create document in Notion first
- [ ] Add required metadata (version, date, author, status)
- [ ] Notify Documentation Steward
- [ ] Steward adds entry to Cross-Reference Index
- [ ] Steward creates GitHub PR (if sync required)
- [ ] Obtain founder approval (if required)

### Deprecation Checklist

- [ ] Add [DEPRECATED] to document title
- [ ] Add deprecation notice to top of document
- [ ] Move document to "Archived" section in Notion
- [ ] Update Cross-Reference Index with deprecation status
- [ ] Update GitHub (if document was synced)
- [ ] Notify all stakeholders
