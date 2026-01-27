# Mandatory Documentation Protocol — Implementation Guide

**Effective Date**: January 27, 2026  
**Applies To**: ALL Manus Accounts, ALL Roles, ALL Phases  
**Authority**: Founder Directive (Mandatory Documentation & State Persistence)  
**Status**: ✅ **ACTIVE AND ENFORCEABLE**

---

## Purpose

This protocol implements the **Mandatory Documentation & State Persistence Directive** received on January 27, 2026. It provides step-by-step procedures for ensuring **EVERY document is committed to GitHub AND posted to Notion without exception**.

---

## Core Principle

> **If it would help a future agent, founder, or verifier understand the system → it is a document.**

**Documents are not overhead. Documents are the system.**

---

## What Counts as a "Document"

The following ALL require GitHub + Notion posting:

✅ **Phase execution prompts**  
✅ **Phase completion reports**  
✅ **Verification / audit reports**  
✅ **Architectural decisions**  
✅ **Design rationales**  
✅ **Governance clarifications**  
✅ **Execution notes**  
✅ **Internal technical strategies**  
✅ **Migration procedures**  
✅ **Handover notes**  
✅ **Enforcement rules**  
✅ **Any long-form response explaining "what was done" or "what should be done"**

---

## Canonical Order of Operations (MANDATORY)

For **EVERY document** you generate, follow this exact order:

### Step 1: Create the Document
```bash
# Create proper markdown file with descriptive name
# Use kebab-case naming: my-document-name.md
# Include proper front matter (title, date, author, purpose)
```

**Checklist**:
- ✅ Descriptive filename (kebab-case)
- ✅ Proper markdown formatting
- ✅ Clear title and purpose
- ✅ Sections and headings
- ✅ Complete content (not truncated)

---

### Step 2: Commit to GitHub

```bash
# Navigate to correct repository
cd /tmp/webwaka-execution-control  # or appropriate repo

# Verify clean state
git status

# Add document to correct directory
git add <correct-directory>/<document-name>.md

# Commit with descriptive message
git commit -m "docs: add <document-name> for <purpose>"

# Push to GitHub
git push origin main

# Verify push succeeded
git log -1
```

**Checklist**:
- ✅ Correct repository (webwaka-execution-control for governance docs)
- ✅ Correct directory (see directory structure below)
- ✅ Descriptive commit message (follows conventional commits format)
- ✅ Push succeeded (no errors)
- ✅ Commit visible on GitHub

**Commit Message Format**:
```
<type>: <short description>

<optional longer description>

<optional footer>
```

**Types**:
- `docs:` — Documentation changes
- `feat:` — New feature or capability
- `fix:` — Bug fix or correction
- `chore:` — Maintenance or housekeeping

---

### Step 3: Post to Notion

```python
# Use Notion API to post document
# Token: /home/ubuntu/notion-migration/.notion_token
# Workspace: WebWaka-Agent-1's Space

# Steps:
# 1. Find correct parent page ID
# 2. Create child page with document title
# 3. Add document content as blocks
# 4. Verify page created
```

**Checklist**:
- ✅ Correct parent page (see Notion structure below)
- ✅ Document title matches GitHub filename
- ✅ Full content migrated (not truncated)
- ✅ Proper formatting preserved
- ✅ Page URL captured

**Notion Structure** (as of 2026-01-27):
```
WebWaka (root)
├── 1️⃣ WebWaka Constitution
│   ├── FOUNDATIONAL_ASSUMPTIONS.md
│   ├── GOVERNANCE.md
│   ├── EXECUTION_PHASES.md
│   ├── EXECUTION_LEDGER.md
│   └── VERIFICATION_STRATEGY.md
├── 2️⃣ Platform Phases → Phase 0
│   ├── PHASE_0_FINAL_COMPLETION_REPORT.md
│   ├── PLATFORM_INFRASTRUCTURE.md
│   ├── REPOSITORY_STANDARDS.md
│   ├── phase-gate.yml
│   ├── Founder Actions (subsection)
│   ├── Handover Documents (subsection)
│   └── Quick Reference (subsection)
├── 3️⃣ Platform Phases → Phase 1
│   └── PHASE_1_EXECUTION_PROMPT.md
├── 4️⃣ Verification & Audit Reports
│   ├── (6 original reports)
│   └── (2 remediation reports)
└── 5️⃣ Internal Documentation
    └── Manus Session Artifacts
        └── INTERNAL_ARTIFACTS_INVENTORY.md
```

---

### Step 4: Verify Presence

```bash
# Verify GitHub
echo "GitHub URL: https://github.com/webwakaagent1/webwaka-execution-control/blob/main/<path>/<document>.md"

# Verify Notion (via browser or API)
echo "Notion URL: https://www.notion.so/<page-id>"
```

**Checklist**:
- ✅ GitHub path confirmed (accessible via URL)
- ✅ Notion page URL confirmed (accessible via URL)
- ✅ Both locations have identical content
- ✅ Verification recorded in session notes

---

### Step 5: Update Cross-Reference Index

```bash
# Add entry to CROSS_REFERENCE_INDEX.md
# Format:
# | Document Name | GitHub Path | Notion URL | Date Added |
```

**Checklist**:
- ✅ Entry added to cross-reference index
- ✅ Index committed to GitHub
- ✅ Index updated in Notion

---

## GitHub Directory Structure

**Repository**: `webwaka-execution-control`

```
webwaka-execution-control/
├── README.md
├── FOUNDATIONAL_ASSUMPTIONS.md
├── GOVERNANCE.md
├── EXECUTION_PHASES.md
├── EXECUTION_LEDGER.md
├── EXECUTION_LEDGER_STANDARDS.md
├── VERIFICATION_STRATEGY.md
├── REPOSITORY_STANDARDS.md
├── PLATFORM_INFRASTRUCTURE.md
├── STOP_SAFE_PROTOCOL.md
├── PHASE_0_FINAL_COMPLETION_REPORT.md
├── PHASE_1_EXECUTION_PROMPT.md
├── AWS_BOOTSTRAP_CONFIG.md
├── AWS_IAM_SETUP_GUIDE.md
├── reports/                          # Verification & audit reports
│   ├── README.md
│   ├── PHASE_0_REMEDIATION_REPORT.md
│   ├── PHASE_0_REMEDIATION_2_REPORT.md
│   └── (future reports)
├── docs/                             # Additional documentation
│   ├── ASSUMPTION_VALIDATION.md
│   └── (future docs)
├── scripts/                          # Automation scripts
│   └── validate-assumptions.sh
├── .github/
│   └── workflows/
│       └── phase-gate.yml
└── internal/                         # Internal documentation (NEW)
    ├── migration/                    # Migration reports
    ├── handover/                     # Handover notes
    └── verification/                 # Verification working docs
```

**Document Placement Rules**:

| Document Type | GitHub Directory | Notion Parent Page |
|---------------|------------------|-------------------|
| Constitution documents | Root | WebWaka Constitution |
| Phase completion reports | Root | Platform Phases → Phase N |
| Verification reports | `reports/` | Verification & Audit Reports |
| Architectural decisions | `docs/` | Platform Phases → Phase N |
| Migration reports | `internal/migration/` | Internal Documentation |
| Handover notes | `internal/handover/` | Internal Documentation |
| Scripts | `scripts/` | N/A (code, not docs) |

---

## Duplication Prevention

**Before creating ANY document**:

### Step 1: Search GitHub
```bash
cd /tmp/webwaka-execution-control
git pull origin main
find . -name "*<keyword>*" -type f
grep -r "<keyword>" .
```

### Step 2: Search Notion
```python
# Use Notion API search
# Or use browser search (Cmd+K / Ctrl+K)
```

### Step 3: Decision Tree
```
Does document exist?
├── YES → Update existing document (don't duplicate)
│   ├── Edit in GitHub
│   ├── Update in Notion
│   └── Commit with "docs: update <name>" message
└── NO → Create new document (follow protocol)
    └── Follow Steps 1-5 above
```

---

## Source of Truth Rules

### GitHub = Canonical Execution Record
- **Authoritative**: GitHub defines what exists
- **Immutable**: Git history preserves all changes
- **Auditable**: All commits traceable to agent and time

### Notion = Canonical Human Reference
- **Accessible**: Founder and team can browse easily
- **Navigable**: Visual hierarchy and search
- **Onboarding**: New agents can orient quickly

### Mirroring Requirement
- GitHub and Notion must **mirror each other**
- If mismatch: **GitHub defines truth**, Notion must be updated

---

## Failure Modes (What NOT to Do)

❌ **"Another Manus probably posted it"**  
→ Verify yourself. Don't assume.

❌ **"It's already in chat history"**  
→ Chat history is ephemeral. Documents must be persistent.

❌ **"This is just internal reasoning"**  
→ If it helps future agents, it's a document.

❌ **"I assumed it would be documented later"**  
→ Document immediately. No delays.

❌ **"This was only a prompt"**  
→ Prompts are documents if they explain "what should be done".

---

## Enforcement

### Breach Definition
**GROSS BREACH OF CONTRACT**: Generating documents without pushing to GitHub AND posting to Notion.

### Consequences
- ❌ Immediate stop of execution
- ❌ Remediation required before continuing
- ❌ Possible withdrawal from project

### Self-Enforcement
Before ending ANY session, verify:
```bash
# Check for uncommitted work
cd /tmp/webwaka-execution-control
git status  # Must show "nothing to commit, working tree clean"

# Check for local-only documents
find /home/ubuntu -name "*.md" -type f | grep -v "/tmp/webwaka-execution-control"
# Any results? → Must commit to GitHub and post to Notion
```

---

## Quick Reference Checklist

For EVERY document you generate:

- [ ] 1. Create proper markdown file
- [ ] 2. Commit to GitHub (correct repo, correct directory)
- [ ] 3. Push to GitHub (verify success)
- [ ] 4. Post to Notion (correct parent page)
- [ ] 5. Verify presence (GitHub URL + Notion URL)
- [ ] 6. Update cross-reference index
- [ ] 7. Record in session notes

**If you cannot complete ALL 7 steps → STOP and report immediately.**

---

## Examples

### Example 1: Phase Completion Report

**Scenario**: You complete Phase 1 and need to create a completion report.

**Steps**:
```bash
# 1. Create document
cat > /tmp/PHASE_1_COMPLETION_REPORT.md << 'EOF'
# Phase 1 Completion Report
...
EOF

# 2. Commit to GitHub
cd /tmp/webwaka-execution-control
cp /tmp/PHASE_1_COMPLETION_REPORT.md .
git add PHASE_1_COMPLETION_REPORT.md
git commit -m "docs: add Phase 1 completion report"
git push origin main

# 3. Post to Notion
python3 /home/ubuntu/notion-migration/post_to_notion.py \
  --parent "Platform Phases → Phase 1" \
  --file PHASE_1_COMPLETION_REPORT.md

# 4. Verify
echo "GitHub: https://github.com/webwakaagent1/webwaka-execution-control/blob/main/PHASE_1_COMPLETION_REPORT.md"
echo "Notion: [URL from script output]"

# 5. Update index
# Add entry to CROSS_REFERENCE_INDEX.md
```

---

### Example 2: Verification Report

**Scenario**: You complete an independent verification and need to create a report.

**Steps**:
```bash
# 1. Create document
cat > /tmp/PHASE_1_VERIFICATION_REPORT.md << 'EOF'
# Phase 1 Independent Verification Report
...
EOF

# 2. Commit to GitHub
cd /tmp/webwaka-execution-control
cp /tmp/PHASE_1_VERIFICATION_REPORT.md reports/
git add reports/PHASE_1_VERIFICATION_REPORT.md
git commit -m "docs: add Phase 1 verification report"
git push origin main

# 3. Post to Notion
python3 /home/ubuntu/notion-migration/post_to_notion.py \
  --parent "Verification & Audit Reports" \
  --file reports/PHASE_1_VERIFICATION_REPORT.md

# 4. Verify
echo "GitHub: https://github.com/webwakaagent1/webwaka-execution-control/blob/main/reports/PHASE_1_VERIFICATION_REPORT.md"
echo "Notion: [URL from script output]"

# 5. Update index
# Add entry to CROSS_REFERENCE_INDEX.md
```

---

### Example 3: Architectural Decision

**Scenario**: You make a significant architectural decision and need to document it.

**Steps**:
```bash
# 1. Create document
cat > /tmp/ADR_001_DATABASE_SELECTION.md << 'EOF'
# ADR 001: Database Selection
...
EOF

# 2. Commit to GitHub
cd /tmp/webwaka-execution-control
mkdir -p docs/adr
cp /tmp/ADR_001_DATABASE_SELECTION.md docs/adr/
git add docs/adr/ADR_001_DATABASE_SELECTION.md
git commit -m "docs: add ADR 001 - database selection"
git push origin main

# 3. Post to Notion
python3 /home/ubuntu/notion-migration/post_to_notion.py \
  --parent "Platform Phases → Phase 1" \
  --file docs/adr/ADR_001_DATABASE_SELECTION.md

# 4. Verify
echo "GitHub: https://github.com/webwakaagent1/webwaka-execution-control/blob/main/docs/adr/ADR_001_DATABASE_SELECTION.md"
echo "Notion: [URL from script output]"

# 5. Update index
# Add entry to CROSS_REFERENCE_INDEX.md
```

---

## Automation Script (Recommended)

To simplify compliance, use this automation script:

**Location**: `/home/ubuntu/scripts/commit-and-post.sh`

```bash
#!/bin/bash
# Commit document to GitHub and post to Notion
# Usage: ./commit-and-post.sh <file> <github-dir> <notion-parent>

FILE=$1
GITHUB_DIR=$2
NOTION_PARENT=$3

# Validate inputs
if [ -z "$FILE" ] || [ -z "$GITHUB_DIR" ] || [ -z "$NOTION_PARENT" ]; then
  echo "Usage: ./commit-and-post.sh <file> <github-dir> <notion-parent>"
  exit 1
fi

# 1. Commit to GitHub
cd /tmp/webwaka-execution-control
git pull origin main
cp "$FILE" "$GITHUB_DIR/"
git add "$GITHUB_DIR/$(basename $FILE)"
git commit -m "docs: add $(basename $FILE)"
git push origin main

# 2. Post to Notion
python3 /home/ubuntu/notion-migration/post_to_notion.py \
  --parent "$NOTION_PARENT" \
  --file "$GITHUB_DIR/$(basename $FILE)"

# 3. Verify
echo "✅ GitHub: https://github.com/webwakaagent1/webwaka-execution-control/blob/main/$GITHUB_DIR/$(basename $FILE)"
echo "✅ Notion: [Check output above]"
echo "✅ COMPLIANCE ACHIEVED"
```

---

## Final Reminder

> **Documentation is not overhead. Documentation is the system.**

The WebWaka platform is governed by:
- ✅ **Absolute State Persistence**
- ✅ **Auditability**
- ✅ **Zero implicit knowledge**
- ✅ **Zero undocumented decisions**

**Every document you generate is a permanent part of the system.**

---

## Protocol Status

**Status**: ✅ **ACTIVE AND ENFORCEABLE**  
**Effective Date**: January 27, 2026  
**Last Updated**: January 27, 2026  
**Next Review**: After Phase 1 completion

---

**END OF MANDATORY DOCUMENTATION PROTOCOL**
