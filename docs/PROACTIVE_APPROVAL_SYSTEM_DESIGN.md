# Proactive Approval System Design

**Date:** 2026-01-27  
**Status:** Design Phase  
**Goal:** Enable email-driven approval workflow with direct links and bulk operations

## Overview

This system transforms the approval workflow from reactive (Founder checks dashboard) to proactive (Founder receives email when approval is needed).

## Key Features

### 1. Proactive Email Notifications

**Trigger:** When a phase status changes to "complete" (ready for approval)

**Email Content:**
- Subject: "WebWaka: Phase X Ready for Approval"
- Phase name and status
- List of all exit criteria met
- Summary of work completed
- Direct "Approve Now" link
- Link to view full details
- Link to dashboard

**Frequency:** Immediate (within 1 minute of status change)

### 2. Direct Approval Links

**Mechanism:** GitHub Issues with approval template

**Flow:**
1. Email contains link to pre-filled GitHub issue
2. Founder clicks link → GitHub issue opens
3. Issue contains approval form with:
   - Phase details
   - Exit criteria checklist
   - Approval confirmation button
   - Optional notes field
4. Founder submits issue → Triggers approval workflow
5. Ledger updated automatically
6. Confirmation email sent

**Security:** GitHub authentication required (Founder must be logged in)

### 3. Multi-Approval Dashboard

**Purpose:** Show all phases and their approval status in one view

**Features:**
- Table with all phases (0-8)
- Status column: not_started, in_progress, complete, approved
- Approval status: Pending, Approved, Not Ready
- Individual "Approve" buttons
- Bulk selection checkboxes
- "Approve Selected" button
- Last updated timestamp
- Progress indicator

**Layout:**
```
┌─────────────────────────────────────────────────────────┐
│  WebWaka Multi-Phase Approval Dashboard                │
├─────────────────────────────────────────────────────────┤
│  [Select All] [Approve Selected (2)]                    │
├──┬────────┬──────────┬──────────┬──────────┬───────────┤
│☐ │Phase 0 │complete  │Pending   │2026-01-27│[Approve]  │
│☐ │Phase 1 │in_progress│Not Ready│2026-01-27│[Disabled] │
│☐ │Phase 2 │not_started│Not Ready│-         │[Disabled] │
└──┴────────┴──────────┴──────────┴──────────┴───────────┘
```

### 4. Bulk Approval Capability

**Use Case:** Approve multiple phases at once (e.g., after reviewing all)

**Flow:**
1. Founder selects multiple phases (checkboxes)
2. Clicks "Approve Selected" button
3. Confirmation modal shows:
   - List of phases to be approved
   - Total count
   - Warning about bulk action
4. Founder confirms
5. All selected phases approved simultaneously
6. Single confirmation email with all approvals

**Safety:**
- Only "complete" phases can be selected
- Confirmation required before bulk approval
- Audit trail records each approval separately

## Technical Architecture

### Components

1. **Pending Approval Detector (GitHub Actions)**
   - Workflow: `detect-pending-approvals.yml`
   - Trigger: On push to main, scheduled (every 5 minutes)
   - Logic: Parse EXECUTION_LEDGER.md, find phases with status="complete" and no approval
   - Output: List of pending approval phases

2. **Proactive Email Notifier (GitHub Actions)**
   - Workflow: `notify-pending-approvals.yml`
   - Trigger: Called by detector if pending approvals found
   - Logic: Send email for each pending approval
   - Email: HTML template with direct approval link

3. **Approval Handler (GitHub Actions)**
   - Workflow: `handle-approval.yml`
   - Trigger: GitHub issue labeled "approval"
   - Logic: Parse issue, update ledger, send confirmation
   - Output: Updated EXECUTION_LEDGER.md

4. **Multi-Approval Dashboard (HTML/JS)**
   - File: `multi-approval.html`
   - Hosting: GitHub Pages
   - Data: Fetched from EXECUTION_LEDGER.md via GitHub API
   - Features: All phases, bulk selection, approval buttons

5. **Bulk Approval Handler (GitHub Actions)**
   - Workflow: `handle-bulk-approval.yml`
   - Trigger: GitHub issue labeled "bulk-approval"
   - Logic: Parse issue, update ledger for multiple phases
   - Output: Updated EXECUTION_LEDGER.md

### Data Flow

```
Phase Status Change
       ↓
Detect Pending Approvals (every 5 min)
       ↓
Send Email with Approval Link
       ↓
Founder Clicks Link
       ↓
GitHub Issue Created (pre-filled)
       ↓
Founder Submits Issue
       ↓
Approval Handler Triggered
       ↓
Ledger Updated
       ↓
Confirmation Email Sent
```

### Email Templates

#### Pending Approval Email

```html
Subject: WebWaka: Phase 0 Ready for Approval

Dear Founder,

Phase 0 - Execution Control & Governance is now COMPLETE and ready for your approval.

Exit Criteria Met:
✓ All required documents exist (13+ documents)
✓ All documents internally consistent
✓ All 15 foundational assumptions documented
✓ All documents align with Blueprint v5.0
✓ All governance mechanisms defined and enforceable
✓ Independent verification passed
✓ Founder requirements documented
✓ Phase 1 execution prompt ready

[Approve Now] [View Details] [Go to Dashboard]

This phase was completed on 2026-01-27.

---
WebWaka Execution Control
Automated Approval System
```

#### Bulk Approval Email

```html
Subject: WebWaka: 3 Phases Approved Successfully

Dear Founder,

You have successfully approved 3 phases:

✓ Phase 0 - Execution Control & Governance
✓ Phase 1 - Core Infrastructure Setup
✓ Phase 2 - Platform Primitives

All phases have been updated in the execution ledger.

[View Dashboard] [View Ledger]

---
WebWaka Execution Control
Automated Approval System
```

## Implementation Plan

### Phase 1: Pending Approval Detection

1. Create `detect-pending-approvals.yml` workflow
2. Implement ledger parsing logic
3. Identify phases with status="complete" and no approval
4. Store pending approvals in workflow output

### Phase 2: Proactive Email Notification

1. Create `notify-pending-approvals.yml` workflow
2. Design HTML email template
3. Implement email sending via Gmail SMTP
4. Generate direct approval links (GitHub issue URLs)

### Phase 3: Approval Handling

1. Create `handle-approval.yml` workflow
2. Implement issue parsing logic
3. Update ledger with approval
4. Send confirmation email

### Phase 4: Multi-Approval Dashboard

1. Create `multi-approval.html` file
2. Implement all-phases table
3. Add bulk selection checkboxes
4. Implement "Approve Selected" button
5. Add confirmation modal

### Phase 5: Bulk Approval Handling

1. Create `handle-bulk-approval.yml` workflow
2. Implement multi-phase ledger update
3. Send bulk confirmation email

## Security Considerations

1. **GitHub Authentication:** All approval actions require GitHub login
2. **Issue Labels:** Only issues with specific labels trigger workflows
3. **Validation:** Workflows validate phase status before approval
4. **Audit Trail:** All approvals recorded in ledger with timestamp
5. **Email Security:** Gmail app password stored in GitHub Secrets

## User Experience

### Current Workflow (Reactive)

1. Founder manually checks dashboard
2. Sees phase is complete
3. Clicks "Approve Phase"
4. Fills in email and notes
5. Submits approval
6. Receives confirmation email

**Time:** ~2-3 minutes per approval  
**Friction:** Requires remembering to check dashboard

### New Workflow (Proactive)

1. Founder receives email notification
2. Clicks "Approve Now" link in email
3. GitHub issue opens (pre-filled)
4. Founder reviews and submits
5. Receives confirmation email

**Time:** ~30 seconds per approval  
**Friction:** Minimal, email-driven

### Bulk Approval Workflow

1. Founder receives multiple pending approval emails
2. Clicks "Go to Dashboard" in any email
3. Sees multi-approval dashboard
4. Selects multiple phases
5. Clicks "Approve Selected"
6. Confirms bulk approval
7. Receives single confirmation email

**Time:** ~1 minute for multiple approvals  
**Friction:** Very low, efficient for batch processing

## Success Metrics

1. **Time to Approval:** Reduce from hours/days to minutes
2. **Approval Rate:** Increase from reactive to proactive
3. **User Satisfaction:** Measure via feedback
4. **Email Open Rate:** Track engagement with notifications
5. **Bulk Approval Usage:** Measure adoption of bulk feature

## Future Enhancements

1. **Slack Integration:** Send notifications to Slack
2. **Mobile App:** Native mobile approval interface
3. **Approval Delegation:** Allow Founder to delegate approvals
4. **Conditional Approvals:** Approve with conditions/notes
5. **Approval Reminders:** Send reminder if no action after 24 hours

## Conclusion

This proactive approval system transforms the approval workflow from manual and reactive to automated and proactive. The Founder will receive timely notifications, have direct approval links, and can efficiently manage multiple approvals.

**Key Benefits:**
- ✅ Proactive notifications (no need to check dashboard)
- ✅ Direct approval links (one-click from email)
- ✅ Multi-approval visibility (see all phases at once)
- ✅ Bulk approval capability (approve multiple at once)
- ✅ Complete audit trail (all approvals recorded)

Implementation will proceed in phases, with testing at each stage to ensure reliability and usability.
