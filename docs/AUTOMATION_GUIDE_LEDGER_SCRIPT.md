# Automation Guide: Enhanced Ledger Script

**Document Status:** ✅ Final  
**Last Updated:** 2026-01-27  
**Author:** Manus AI Agent

## 1. Overview

This document provides a comprehensive guide to the enhanced `scripts/ledger.py` automation script. This script is the central tool for managing the `EXECUTION_LEDGER.md` file and has been significantly upgraded to improve usability, safety, and debugging capabilities.

## 2. Key Enhancements

The script now includes three critical new features:

### 2.1. Detailed Validation Error Messages

**Purpose:** Provide clear, actionable feedback when validation rules are violated.

**Benefits:**
- **Faster Debugging:** Quickly understand why an operation failed.
- **Better User Experience:** Clear guidance on how to fix the problem.
- **Improved Reliability:** Prevents common errors and ensures data integrity.

**Example:**

If you try to skip a phase, you will now see a detailed error message:

```
❌ Invalid phase transition: Phase 0 → Phase 5
Details:
  • Current phase: Phase 0 (index 0)
  • Target phase: Phase 5 (index 5)
  • Phase transitions must be sequential (no skipping)
  • You can only:
  •   • Update the current phase status
  •   • Move to the next phase in sequence
  • To move from Phase 0 to Phase 5, you must complete intermediate phases first
```

### 2.2. Dry-Run Mode

**Purpose:** Preview the effects of `update` and `approve` commands without making any permanent changes.

**Benefits:**
- **Safe Testing:** Verify commands before execution.
- **Prevent Accidents:** Avoid unintentional modifications to the ledger.
- **Clear Previews:** See exactly what changes will be made.

**Usage:**

Add the `--dry-run` flag to any `update` or `approve` command:

```bash
python scripts/ledger.py update --phase "Phase 0" --status "complete" --dry-run
```

**Output:**

```
🔍 DRY-RUN MODE: Changes will NOT be saved
--- Preview of changes ---
No changes detected
--- End of preview ---
✅ DRY-RUN: Would update ledger: Phase 0 → complete
```

### 2.3. Rollback Functionality

**Purpose:** Easily undo changes by restoring from automatic backups.

**Benefits:**
- **Safety Net:** Quickly revert to a previous state if an error occurs.
- **Automatic Backups:** Backups are created automatically before every write operation.
- **Easy to Use:** A simple `rollback` command restores the last known good state.

**Usage:**

To undo the last change:

```bash
python scripts/ledger.py rollback
```

To see all available backups:

```bash
python scripts/ledger.py list-backups
```

**Backup System Details:**
- **Location:** Backups are stored in the `.ledger_backups/` directory.
- **Retention:** The last 10 backups are kept (configurable).
- **Safety:** A pre-rollback backup is created before any rollback operation.

## 3. Complete Command Reference

### `update`

Updates the status of a specific phase.

```bash
python scripts/ledger.py update --phase <PHASE> --status <STATUS> [--details <DETAILS>] [--dry-run]
```

- `--phase`: The name of the phase (e.g., "Phase 0").
- `--status`: The new status (e.g., "not_started", "in_progress", "complete", "approved").
- `--details`: (Optional) Additional information about the update.
- `--dry-run`: (Optional) Preview changes without saving them.

### `approve`

Records Founder approval for a phase.

```bash
python scripts/ledger.py approve --phase <PHASE> --issue <ISSUE_NUMBER> [--dry-run]
```

- `--phase`: The name of the phase being approved.
- `--issue`: The GitHub issue number associated with the approval.
- `--dry-run`: (Optional) Preview changes without saving them.

### `validate`

Validates the structure and content of the `EXECUTION_LEDGER.md` file.

```bash
python scripts/ledger.py validate
```

### `get-current-phase`

Retrieves and prints the current active phase and its status.

```bash
python scripts/ledger.py get-current-phase
```

### `rollback`

Reverts the `EXECUTION_LEDGER.md` file to its most recent previous version.

```bash
python scripts/ledger.py rollback
```

### `list-backups`

Lists all available backups of the `EXECUTION_LEDGER.md` file.

```bash
python scripts/ledger.py list-backups
```

## 4. Integration with GitHub Actions

The enhanced script is fully backward-compatible and will continue to work seamlessly with the existing GitHub Actions workflows. The new features provide additional safety and debugging capabilities for both automated and manual use.

## 5. Visibility and Accessibility

To ensure all stakeholders are aware of these improvements, this guide has been:

1.  **Added to the `docs/` directory** in the `webwaka-execution-control` repository.
2.  **Linked from the main `README.md`** for high visibility.
3.  **Posted to the Notion workspace** for easy access by non-technical stakeholders.

This ensures that anyone involved in the project can quickly understand how to use the enhanced automation system and act accordingly.

---

**End of Document**
