# Automation Guide: Approval Dashboard

**Version:** 2.0  
**Last Updated:** 2026-01-27  
**Status:** Production Ready

## Overview

The WebWaka Approval Dashboard is a web-based interface that provides the Founder with a simple, non-technical way to manage project approvals, monitor phase status, and maintain visibility over the entire execution process.

**Dashboard URL:** https://webwakaagent1.github.io/webwaka-approval-dashboard/

## Key Features

### 1. Real-Time Status Updates

The dashboard automatically refreshes every 30 seconds to display the latest project status without requiring manual page reloads.

**Features:**
- **Auto-refresh indicator:** Shows countdown timer in top-right corner
- **Visual feedback:** Green badge indicates active auto-refresh
- **Configurable interval:** 30-second default (can be adjusted in code)
- **No user action required:** Completely automatic

**Benefits:**
- Always see the most current information
- No need to manually refresh the page
- Reduces risk of acting on stale data

### 2. Approval History & Audit Log

Complete record of all phase approvals with detailed information about who approved what and when.

**Features:**
- **Tab-based navigation:** Switch between "Current Phase" and "Approval History"
- **Comprehensive records:** Phase name, status, approval date, approver, notes
- **Empty state handling:** Clear message when no approvals exist yet
- **Sortable table:** Easy to scan and review past decisions

**Benefits:**
- Full transparency of approval history
- Easy audit trail for compliance
- Quick reference for past decisions

### 3. Detailed Approval View

Modal dialog that provides comprehensive context about what you're approving before you make a decision.

**Features:**
- **Phase information:** Name, status, start date, last updated
- **Exit criteria:** All requirements that must be met
- **Key documents:** Links to relevant documentation
- **One-click access:** "View Details" button on main dashboard

**Benefits:**
- Make informed decisions with full context
- Quickly access supporting documentation
- Verify all requirements are met before approving

### 4. Enhanced Approval Modal

Streamlined approval process with email notification support and optional notes.

**Features:**
- **Email field:** Enter your email to receive confirmation
- **Approval notes:** Add optional comments or context
- **Confirmation checklist:** Visual reminder of what approval means
- **Cancel option:** Easy to back out if needed

**Benefits:**
- Receive email confirmation of approvals
- Document reasoning for future reference
- Clear understanding of approval implications

### 5. Email Notifications

Automatic email notifications sent after each approval action.

**Features:**
- **HTML formatted emails:** Professional, branded appearance
- **Approval details:** Phase name, status, date, notes
- **Quick links:** Direct links to dashboard and GitHub
- **GitHub issue comments:** Approval also recorded in GitHub

**Benefits:**
- Permanent email record of approvals
- No need to remember to check dashboard
- Easy to forward to stakeholders

## How to Use the Dashboard

### Viewing Current Phase Status

1. **Open the dashboard:** Navigate to https://webwakaagent1.github.io/webwaka-approval-dashboard/
2. **Review phase info:** See current phase, status, start date, last updated
3. **Check exit criteria:** Verify all requirements are met (green checkmarks)
4. **Auto-refresh:** Dashboard updates automatically every 30 seconds

### Viewing Detailed Information

1. **Click "View Details"** button on the main dashboard
2. **Review modal content:**
   - Phase information (name, status, dates)
   - Complete list of exit criteria
   - Links to key documents (EXECUTION_LEDGER.md, GOVERNANCE.md, etc.)
3. **Click document links** to view supporting materials
4. **Close modal** when done reviewing

### Approving a Phase

1. **Verify phase is complete:** Check that status shows "complete"
2. **Review exit criteria:** Ensure all checkmarks are green
3. **Click "Approve Phase"** button
4. **In the approval modal:**
   - Enter your email address (for notification)
   - Add optional notes explaining your decision
   - Review the confirmation checklist
5. **Click "Confirm Approval"** to finalize
6. **Receive email confirmation** within minutes

### Viewing Approval History

1. **Click "Approval History"** tab at the top
2. **Review the table:**
   - Phase: Which phase was approved
   - Status: What status it had when approved
   - Approved: Date and time of approval
   - Approver: Who approved it (your email)
   - Notes: Any comments added during approval
3. **Switch back** to "Current Phase" tab to continue monitoring

## Email Notification Setup

To enable email notifications, the following GitHub Secrets must be configured:

1. **NOTIFICATION_EMAIL:** Gmail address to send notifications from
2. **NOTIFICATION_EMAIL_PASSWORD:** Gmail app password (not regular password)

### How to Create Gmail App Password

1. Go to your Google Account settings
2. Navigate to Security → 2-Step Verification
3. Scroll to "App passwords"
4. Generate a new app password for "Mail"
5. Copy the 16-character password
6. Add it to GitHub Secrets as `NOTIFICATION_EMAIL_PASSWORD`

### Email Notification Workflow

The `approval-notification.yml` workflow automatically:

1. Triggers when EXECUTION_LEDGER.md is updated
2. Detects if an approval occurred
3. Sends HTML email with approval details
4. Posts comment to GitHub issue (if linked)
5. Logs success/failure for debugging

## Technical Architecture

### Frontend (Dashboard)

- **Technology:** Pure HTML/CSS/JavaScript (no framework)
- **Hosting:** GitHub Pages (static site)
- **Data source:** GitHub API (raw content from EXECUTION_LEDGER.md)
- **Refresh mechanism:** JavaScript setInterval (30 seconds)
- **Styling:** Modern, responsive design with gradient background

### Backend (Workflows)

- **Technology:** GitHub Actions (YAML workflows)
- **Triggers:** Push to main branch, manual dispatch
- **Email service:** Gmail SMTP (via GitHub Actions)
- **Validation:** Python script (scripts/ledger.py)

### Data Flow

1. **Dashboard loads** → Fetches EXECUTION_LEDGER.md from GitHub
2. **Parses markdown** → Extracts phase status and exit criteria
3. **Displays UI** → Shows current phase with approval button
4. **User approves** → Redirects to GitHub issue creation
5. **Issue created** → Triggers update-ledger.yml workflow
6. **Ledger updated** → Triggers approval-notification.yml workflow
7. **Email sent** → Founder receives confirmation
8. **Dashboard refreshes** → Shows updated status

## Troubleshooting

### Dashboard Not Loading

**Symptoms:** Blank page or error message

**Solutions:**
1. Check GitHub Pages is enabled (Settings → Pages)
2. Verify repository is public
3. Clear browser cache and reload
4. Check browser console for JavaScript errors

### Auto-Refresh Not Working

**Symptoms:** Dashboard doesn't update automatically

**Solutions:**
1. Check auto-refresh indicator in top-right corner
2. Verify JavaScript is enabled in browser
3. Check browser console for errors
4. Manually refresh page to verify data is accessible

### Email Notifications Not Received

**Symptoms:** No email after approval

**Solutions:**
1. Verify GitHub Secrets are configured correctly
2. Check spam/junk folder
3. Review GitHub Actions logs for errors
4. Verify Gmail app password is valid
5. Check NOTIFICATION_EMAIL is correct

### Approval Button Disabled

**Symptoms:** "Approve Phase" button is grayed out

**Solutions:**
1. Verify phase status is "complete" (not "in_progress")
2. Check all exit criteria are met (green checkmarks)
3. Ensure you're viewing the correct phase
4. Refresh dashboard to get latest status

### Approval History Empty

**Symptoms:** "No approval history yet" message

**Solutions:**
1. Verify approvals have been recorded in EXECUTION_LEDGER.md
2. Check ledger format is correct (use `python scripts/ledger.py validate`)
3. Refresh dashboard to fetch latest data
4. Review EXECUTION_LEDGER.md directly on GitHub

## Best Practices

### For Founders

1. **Review before approving:** Always click "View Details" to see full context
2. **Add notes:** Use approval notes to document your reasoning
3. **Check email:** Verify you receive confirmation emails
4. **Monitor regularly:** Check dashboard at least once per day
5. **Keep history:** Don't delete approval emails (they're your audit trail)

### For AI Operators

1. **Update ledger promptly:** Use `scripts/ledger.py` to keep status current
2. **Validate before pushing:** Run `validate` command before committing
3. **Test dry-run:** Use `--dry-run` flag to preview changes
4. **Document decisions:** Add detailed notes to ledger updates
5. **Monitor workflows:** Check GitHub Actions for any failures

### For System Administrators

1. **Rotate secrets:** Update Gmail app password periodically
2. **Monitor usage:** Check GitHub Actions usage limits
3. **Review logs:** Investigate any workflow failures
4. **Test notifications:** Send test emails after secret updates
5. **Backup data:** EXECUTION_LEDGER.md is the source of truth

## Security Considerations

### Dashboard Security

- **Public access:** Dashboard is publicly accessible (no authentication)
- **Read-only:** Dashboard cannot modify data (only displays it)
- **GitHub API:** Uses public GitHub API (no credentials required)
- **No sensitive data:** Dashboard only shows project status (no secrets)

### Email Security

- **Gmail app password:** More secure than regular password
- **GitHub Secrets:** Encrypted at rest, only accessible to workflows
- **SMTP over TLS:** Email transmission is encrypted
- **No credentials in code:** All secrets stored in GitHub Secrets

### Approval Security

- **GitHub authentication:** Approvals require GitHub login
- **Issue-based:** Approvals are recorded in GitHub issues (audit trail)
- **Ledger validation:** Automated validation prevents invalid updates
- **Backup system:** Rollback capability in case of errors

## Future Enhancements

### Planned Features

1. **Multi-phase view:** Show all phases on single dashboard
2. **Progress indicators:** Visual progress bars for each phase
3. **Cost tracking:** Display estimated vs actual costs
4. **Timeline view:** Gantt chart showing phase dependencies
5. **Mobile app:** Native mobile app for iOS/Android

### Potential Improvements

1. **Real-time notifications:** WebSocket-based live updates
2. **Approval delegation:** Allow Founder to delegate approvals
3. **Approval workflows:** Multi-step approval process
4. **Integration with Slack:** Notifications in Slack channels
5. **Custom dashboards:** Configurable views for different stakeholders

## Related Documentation

- **Ledger Automation Guide:** `docs/AUTOMATION_GUIDE_LEDGER_SCRIPT.md`
- **Automation Architecture:** `AUTOMATION_ARCHITECTURE.md`
- **Founder Quick Start:** `FOUNDER_QUICK_START_AUTOMATION.md`
- **Execution Ledger:** `EXECUTION_LEDGER.md`
- **Governance:** `GOVERNANCE.md`

## Support

For questions, issues, or feature requests:

1. **GitHub Issues:** https://github.com/webwakaagent1/webwaka-execution-control/issues
2. **Notion Documentation:** https://www.notion.so/2f5fb70870b58187a44af7ec2dd5fe44
3. **Email:** Contact the Founder directly

---

**Remember:** The approval dashboard is your primary interface for managing the WebWaka project. Use it regularly, review carefully, and approve confidently.
