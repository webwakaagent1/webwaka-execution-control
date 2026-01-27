# Proactive Approval System Documentation

**Version:** 1.0  
**Last Updated:** 2026-01-27  
**Status:** ✅ DEPLOYED & OPERATIONAL

## Overview

The Proactive Approval System is a comprehensive automation framework that transforms the WebWaka project approval workflow from reactive (manual checking) to proactive (automatic notifications with direct action links).

## Key Features

### 1. Proactive Email Notifications

The system automatically detects when a phase becomes ready for approval and sends an email notification to the Founder with:

- **Phase details** and current status
- **Direct approval link** (opens GitHub issue with pre-filled approval form)
- **Exit criteria checklist** for quick review
- **Dashboard link** for detailed information

### 2. Multi-Approval Dashboard

A dedicated web interface for managing multiple pending approvals:

- **URL:** https://webwakaagent1.github.io/webwaka-approval-dashboard/multi-approval.html
- **Features:**
  - View all phases and their approval status
  - Select multiple phases for bulk approval
  - Auto-refresh every 30 seconds
  - Responsive design for mobile and desktop

### 3. Bulk Approval Capability

Approve multiple phases simultaneously:

- Select individual phases or use "Select All Pending"
- Review all selected phases before confirming
- Single GitHub issue for bulk approvals
- Clear audit trail

### 4. Issue-Based Approval Workflow

Approvals are processed through GitHub issues:

- Each approval creates a GitHub issue
- Issues are automatically labeled and tracked
- Workflow automation processes approvals
- Complete audit trail maintained

## System Architecture

### Components

1. **detect-pending-approvals.yml** - Workflow that runs every 6 hours to check for phases ready for approval
2. **notify-pending-approvals.yml** - Workflow that sends email notifications for pending approvals
3. **handle-approval.yml** - Workflow that processes approval requests from GitHub issues
4. **multi-approval.html** - Web dashboard for managing multiple approvals
5. **index.html** - Enhanced single-phase approval dashboard with history and real-time updates

### Workflow Triggers

- **Scheduled:** Every 6 hours (00:00, 06:00, 12:00, 18:00 UTC)
- **Manual:** Can be triggered manually via GitHub Actions
- **On-demand:** Triggered when EXECUTION_LEDGER.md is updated

### Data Flow

```
EXECUTION_LEDGER.md (phase complete)
    ↓
detect-pending-approvals.yml (runs every 6 hours)
    ↓
notify-pending-approvals.yml (sends email)
    ↓
Founder receives email with direct link
    ↓
Founder clicks link → GitHub issue created
    ↓
Founder adds comment: "/approve Phase X"
    ↓
handle-approval.yml (processes approval)
    ↓
EXECUTION_LEDGER.md updated (phase approved)
    ↓
Confirmation email sent to Founder
```

## Usage Guide

### For the Founder

#### Receiving Approval Notifications

1. **Email arrives** with subject: "WebWaka: Phase X Ready for Approval"
2. **Review phase details** in the email
3. **Click "Approve Phase X"** link in the email
4. **GitHub issue opens** with pre-filled approval form
5. **Review and submit** the issue

#### Using the Multi-Approval Dashboard

1. **Visit:** https://webwakaagent1.github.io/webwaka-approval-dashboard/multi-approval.html
2. **View all phases** and their approval status
3. **Select phases** to approve (or click "Select All Pending")
4. **Click "Approve Selected"** button
5. **Review and confirm** bulk approval

#### Approving via GitHub Issue

1. **Create or open** a GitHub issue in the webwaka-execution-control repository
2. **Add a comment** with the approval command:
   ```
   /approve Phase 0
   ```
3. **Submit the comment** - the workflow will process it automatically

#### Bulk Approval via GitHub Issue

1. **Create a GitHub issue** with title: "Bulk Approval: X Phases"
2. **Add approval commands** for each phase:
   ```
   /approve Phase 0
   /approve Phase 1
   /approve Phase 2
   ```
3. **Submit the issue** - all phases will be approved

### For AI Operators

#### Triggering Approval Notifications

Approval notifications are triggered automatically when:

1. A phase status is updated to `complete` in EXECUTION_LEDGER.md
2. The phase has not been approved yet
3. The scheduled workflow runs (every 6 hours)

To manually trigger:

```bash
# Via GitHub CLI
gh workflow run detect-pending-approvals.yml --repo webwakaagent1/webwaka-execution-control

# Or via GitHub Actions UI
# Go to Actions → detect-pending-approvals → Run workflow
```

#### Checking Approval Status

```bash
# Using the ledger script
cd /path/to/webwaka-execution-control
python3 scripts/ledger.py get-current-phase

# Expected output:
# Current Phase: Phase 0 - Execution Control & Governance
# Status: complete
# Approval Status: pending
```

## Configuration

### Required GitHub Secrets

The following secrets must be configured in the repository settings:

1. **NOTIFICATION_EMAIL** - Email address to receive approval notifications
2. **NOTIFICATION_EMAIL_PASSWORD** - Gmail app password for sending emails

### Setting Up Gmail App Password

1. Go to your Google Account settings
2. Navigate to Security → 2-Step Verification
3. Scroll to "App passwords"
4. Generate a new app password for "Mail"
5. Copy the password and add it to GitHub Secrets

### Workflow Configuration

Edit the workflow files to customize:

- **Notification frequency:** Change the cron schedule in `detect-pending-approvals.yml`
- **Email template:** Modify the email body in `notify-pending-approvals.yml`
- **Approval commands:** Customize the approval pattern in `handle-approval.yml`

## Troubleshooting

### Emails Not Being Sent

**Problem:** Approval notifications are not arriving

**Solutions:**

1. Check GitHub Secrets are configured correctly
2. Verify the Gmail app password is valid
3. Check GitHub Actions logs for errors
4. Ensure the workflow has been triggered (check Actions tab)

### Approvals Not Being Processed

**Problem:** Approval commands in issues are not updating the ledger

**Solutions:**

1. Check the issue comment contains the exact command: `/approve Phase X`
2. Verify the phase name matches exactly (case-sensitive)
3. Check GitHub Actions logs for processing errors
4. Ensure the workflow has permissions to update the repository

### Dashboard Not Showing Phases

**Problem:** Multi-approval dashboard shows "No phases found"

**Solutions:**

1. Check EXECUTION_LEDGER.md has phases in the expected format
2. Verify the ledger parsing logic in the dashboard JavaScript
3. Check browser console for errors
4. Ensure GitHub Pages is serving the latest version

## Best Practices

### For Founders

1. **Check email regularly** for approval notifications
2. **Use the dashboard** for a comprehensive view of all phases
3. **Review exit criteria** before approving
4. **Use bulk approval** for multiple completed phases
5. **Add notes** to approval issues for context

### For AI Operators

1. **Update EXECUTION_LEDGER.md** immediately when a phase is complete
2. **Verify approval status** before starting the next phase
3. **Monitor GitHub Actions** for workflow errors
4. **Test approvals** in a separate branch before production
5. **Document all changes** in commit messages

## Security Considerations

### Email Security

- Gmail app passwords are used instead of account passwords
- Passwords are stored securely in GitHub Secrets
- Email content does not contain sensitive information
- Links are public GitHub URLs

### Approval Security

- All approvals are tracked in GitHub issues
- Only authorized users can approve (via GitHub permissions)
- Approval commands are validated before processing
- Complete audit trail maintained in EXECUTION_LEDGER.md

### Dashboard Security

- Dashboard is read-only (no write operations)
- Data is fetched from public GitHub repository
- No authentication required (public repository)
- No sensitive information displayed

## Future Enhancements

### Planned Features

1. **SMS notifications** for critical approvals
2. **Slack integration** for team notifications
3. **Approval analytics** dashboard
4. **Custom approval workflows** per phase
5. **Approval delegation** to other team members

### Potential Improvements

1. **Real-time notifications** via WebSockets
2. **Mobile app** for approvals
3. **Voice approval** via phone call
4. **AI-assisted approval** recommendations
5. **Approval templates** for common scenarios

## Support

For issues, questions, or feature requests:

1. **Create a GitHub issue** in the webwaka-execution-control repository
2. **Tag with:** `approval-system`, `bug`, or `enhancement`
3. **Provide details:** Error messages, screenshots, steps to reproduce

## Changelog

### Version 1.0 (2026-01-27)

- ✅ Initial release
- ✅ Proactive email notifications
- ✅ Multi-approval dashboard
- ✅ Bulk approval capability
- ✅ Issue-based approval workflow
- ✅ Comprehensive documentation

---

**End of Documentation**
