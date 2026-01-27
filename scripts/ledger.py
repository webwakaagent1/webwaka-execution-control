#!/usr/bin/env python3
"""
EXECUTION_LEDGER Automation Script (Enhanced)

This script automates the management of the EXECUTION_LEDGER.md file,
ensuring consistent updates and validation of phase transitions.

Features:
- Detailed validation error messages
- Dry-run mode for safe testing
- Automatic backup and rollback functionality

Usage:
    python scripts/ledger.py update --phase "Phase 0" --status "complete" --details "All work done"
    python scripts/ledger.py update --phase "Phase 0" --status "complete" --dry-run  # Test without changes
    python scripts/ledger.py approve --phase "Phase 0" --issue 123
    python scripts/ledger.py validate
    python scripts/ledger.py get-current-phase
    python scripts/ledger.py rollback  # Undo last change
    python scripts/ledger.py list-backups  # Show available backups
"""

import argparse
import re
import sys
import shutil
from datetime import datetime
from pathlib import Path
from typing import Optional, Dict, Any, List

# Constants
LEDGER_FILE = Path(__file__).parent.parent / "EXECUTION_LEDGER.md"
BACKUP_DIR = Path(__file__).parent.parent / ".ledger_backups"
VALID_PHASES = ["Phase 0", "Phase 1", "Phase 2", "Phase 3", "Phase 4", "Phase 5"]
VALID_STATUSES = ["not_started", "in_progress", "complete", "approved"]
MAX_BACKUPS = 10  # Keep last 10 backups

class ValidationError(Exception):
    """Custom exception for validation errors with detailed messages"""
    def __init__(self, message: str, details: List[str] = None):
        self.message = message
        self.details = details or []
        super().__init__(self.message)
    
    def __str__(self):
        result = f"\n❌ {self.message}\n"
        if self.details:
            result += "\nDetails:\n"
            for detail in self.details:
                result += f"  • {detail}\n"
        return result

class LedgerManager:
    """Manages the EXECUTION_LEDGER.md file"""
    
    def __init__(self, ledger_path: Path = LEDGER_FILE):
        self.ledger_path = ledger_path
        self.backup_dir = BACKUP_DIR
        self.backup_dir.mkdir(exist_ok=True)
        self.content = self._read_ledger()
        self.frontmatter = self._parse_frontmatter()
    
    def _read_ledger(self) -> str:
        """Read the ledger file"""
        if not self.ledger_path.exists():
            raise ValidationError(
                f"Ledger file not found: {self.ledger_path}",
                [
                    f"Expected location: {self.ledger_path.absolute()}",
                    "Ensure you're running this script from the repository root",
                    "Check that EXECUTION_LEDGER.md exists in the repository"
                ]
            )
        return self.ledger_path.read_text()
    
    def _write_ledger(self, content: str, dry_run: bool = False):
        """Write content to ledger file"""
        if dry_run:
            print("🔍 DRY-RUN MODE: Changes will NOT be saved")
            print("\n--- Preview of changes ---")
            print(self._show_diff(self.content, content))
            print("--- End of preview ---\n")
            return
        
        # Create backup before writing
        self._create_backup()
        
        # Write the new content
        self.ledger_path.write_text(content)
        self.content = content
        
        # Clean up old backups
        self._cleanup_old_backups()
    
    def _create_backup(self):
        """Create a timestamped backup of the current ledger"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_file = self.backup_dir / f"EXECUTION_LEDGER_{timestamp}.md"
        shutil.copy2(self.ledger_path, backup_file)
        print(f"📦 Backup created: {backup_file.name}")
    
    def _cleanup_old_backups(self):
        """Remove old backups, keeping only the most recent MAX_BACKUPS"""
        backups = sorted(self.backup_dir.glob("EXECUTION_LEDGER_*.md"), reverse=True)
        for old_backup in backups[MAX_BACKUPS:]:
            old_backup.unlink()
            print(f"🗑️  Removed old backup: {old_backup.name}")
    
    def _show_diff(self, old_content: str, new_content: str) -> str:
        """Show a simple diff between old and new content"""
        old_lines = old_content.split('\n')
        new_lines = new_content.split('\n')
        
        diff_lines = []
        for i, (old, new) in enumerate(zip(old_lines, new_lines)):
            if old != new:
                diff_lines.append(f"Line {i+1}:")
                diff_lines.append(f"  - {old}")
                diff_lines.append(f"  + {new}")
        
        if len(new_lines) > len(old_lines):
            diff_lines.append(f"\n{len(new_lines) - len(old_lines)} new lines added")
        
        return '\n'.join(diff_lines) if diff_lines else "No changes detected"
    
    def _parse_frontmatter(self) -> Dict[str, Any]:
        """Parse YAML frontmatter from ledger"""
        match = re.search(r'^---\n(.*?)\n---', self.content, re.DOTALL)
        if not match:
            raise ValidationError(
                "No frontmatter found in ledger",
                [
                    "The EXECUTION_LEDGER.md file must start with YAML frontmatter",
                    "Expected format:",
                    "---",
                    "current_phase: \"Phase 0\"",
                    "phase_status: \"complete\"",
                    "last_updated: \"2026-01-27\"",
                    "---"
                ]
            )
        
        frontmatter = {}
        for line in match.group(1).split('\n'):
            if ':' in line:
                key, value = line.split(':', 1)
                key = key.strip()
                value = value.strip().strip('"')
                if value.lower() == 'null':
                    value = None
                frontmatter[key] = value
        
        return frontmatter
    
    def _update_frontmatter(self, updates: Dict[str, Any]):
        """Update frontmatter with new values"""
        # Update in-memory frontmatter
        self.frontmatter.update(updates)
        
        # Rebuild frontmatter string
        frontmatter_lines = ["---"]
        for key, value in self.frontmatter.items():
            if value is None:
                frontmatter_lines.append(f"{key}: null")
            elif isinstance(value, str):
                frontmatter_lines.append(f'{key}: "{value}"')
            else:
                frontmatter_lines.append(f"{key}: {value}")
        frontmatter_lines.append("---")
        
        # Replace frontmatter in content
        new_frontmatter = '\n'.join(frontmatter_lines)
        self.content = re.sub(
            r'^---\n.*?\n---',
            new_frontmatter,
            self.content,
            count=1,
            flags=re.DOTALL
        )
    
    def get_current_phase(self) -> str:
        """Get the current phase from frontmatter"""
        return self.frontmatter.get('current_phase', 'Unknown')
    
    def get_phase_status(self) -> str:
        """Get the current phase status"""
        return self.frontmatter.get('phase_status', 'Unknown')
    
    def update_phase_status(self, phase: str, status: str, details: str = "", dry_run: bool = False):
        """Update phase status in ledger"""
        # Validate inputs with detailed error messages
        if phase not in VALID_PHASES:
            raise ValidationError(
                f"Invalid phase: '{phase}'",
                [
                    f"Valid phases are: {', '.join(VALID_PHASES)}",
                    f"You provided: '{phase}'",
                    "Ensure phase name matches exactly (case-sensitive)",
                    "Example: --phase \"Phase 0\""
                ]
            )
        
        if status not in VALID_STATUSES:
            raise ValidationError(
                f"Invalid status: '{status}'",
                [
                    f"Valid statuses are: {', '.join(VALID_STATUSES)}",
                    f"You provided: '{status}'",
                    "Status must be one of: not_started, in_progress, complete, approved",
                    "Example: --status complete"
                ]
            )
        
        # Validate phase transition
        current_phase = self.get_current_phase()
        if not self._is_valid_transition(current_phase, phase):
            current_idx = VALID_PHASES.index(current_phase) if current_phase in VALID_PHASES else -1
            target_idx = VALID_PHASES.index(phase)
            
            raise ValidationError(
                f"Invalid phase transition: {current_phase} → {phase}",
                [
                    f"Current phase: {current_phase} (index {current_idx})",
                    f"Target phase: {phase} (index {target_idx})",
                    "Phase transitions must be sequential (no skipping)",
                    "You can only:",
                    "  • Update the current phase status",
                    "  • Move to the next phase in sequence",
                    f"To move from {current_phase} to {phase}, you must complete intermediate phases first"
                ]
            )
        
        # Update frontmatter
        today = datetime.now().strftime("%Y-%m-%d")
        self._update_frontmatter({
            'current_phase': phase,
            'phase_status': status,
            'last_updated': today
        })
        
        # Add history entry
        self._add_history_entry(phase, status, details)
        
        # Write changes (or show preview if dry-run)
        self._write_ledger(self.content, dry_run=dry_run)
        
        if not dry_run:
            print(f"✅ Updated ledger: {phase} → {status}")
        else:
            print(f"✅ DRY-RUN: Would update ledger: {phase} → {status}")
    
    def record_approval(self, phase: str, issue_number: int, dry_run: bool = False):
        """Record Founder approval for a phase"""
        if phase not in VALID_PHASES:
            raise ValidationError(
                f"Invalid phase: '{phase}'",
                [
                    f"Valid phases are: {', '.join(VALID_PHASES)}",
                    f"You provided: '{phase}'",
                    "Example: --phase \"Phase 0\""
                ]
            )
        
        # Update frontmatter
        today = datetime.now().strftime("%Y-%m-%d")
        self._update_frontmatter({
            'current_phase': phase,
            'phase_status': 'approved',
            'approval_issue_number': f"#{issue_number}",
            'last_updated': today
        })
        
        # Add approval entry to history
        details = f"Founder approved {phase} via GitHub issue #{issue_number}"
        self._add_history_entry(phase, "approved", details)
        
        # Update approval table
        self._update_approval_table(phase, issue_number, today)
        
        # Write changes (or show preview if dry-run)
        self._write_ledger(self.content, dry_run=dry_run)
        
        if not dry_run:
            print(f"✅ Recorded approval: {phase} (Issue #{issue_number})")
        else:
            print(f"✅ DRY-RUN: Would record approval: {phase} (Issue #{issue_number})")
    
    def _is_valid_transition(self, from_phase: str, to_phase: str) -> bool:
        """Check if phase transition is valid (no skipping)"""
        if from_phase == to_phase:
            return True  # Same phase is OK (status update)
        
        try:
            from_idx = VALID_PHASES.index(from_phase)
            to_idx = VALID_PHASES.index(to_phase)
            # Can only move forward by 1, or stay in same phase
            return to_idx == from_idx or to_idx == from_idx + 1
        except ValueError:
            return False
    
    def _add_history_entry(self, phase: str, status: str, details: str):
        """Add a new entry to the execution history"""
        today = datetime.now().strftime("%Y-%m-%d")
        
        # Create history entry
        entry = f"\n---\n\n### [{today}] {phase} Status Update\n\n"
        entry += f"**Phase:** {phase}  \n"
        entry += f"**Status:** {status}  \n"
        entry += f"**Actor:** Manus Agent (Automated)  \n\n"
        if details:
            entry += f"{details}\n"
        
        # Find insertion point (before "Phase Approval History")
        insertion_marker = "## Phase Approval History"
        if insertion_marker in self.content:
            self.content = self.content.replace(
                insertion_marker,
                entry + "\n" + insertion_marker
            )
        else:
            # Append to end if no approval history section
            self.content += entry
    
    def _update_approval_table(self, phase: str, issue_number: int, approval_date: str):
        """Update the phase approval table"""
        # Find the approval table
        table_pattern = r'\| ' + re.escape(phase) + r' \| [^|]+ \| [^|]+ \| [^|]+ \|'
        replacement = f"| {phase} | ✅ Approved | #{issue_number} | {approval_date} |"
        
        self.content = re.sub(table_pattern, replacement, self.content)
    
    def rollback(self) -> bool:
        """Rollback to the most recent backup"""
        backups = sorted(self.backup_dir.glob("EXECUTION_LEDGER_*.md"), reverse=True)
        
        if not backups:
            raise ValidationError(
                "No backups available for rollback",
                [
                    f"Backup directory: {self.backup_dir}",
                    "Backups are created automatically before each update",
                    "No previous changes have been made, so no backups exist"
                ]
            )
        
        most_recent_backup = backups[0]
        
        print(f"🔄 Rolling back to: {most_recent_backup.name}")
        print(f"   Created: {datetime.fromtimestamp(most_recent_backup.stat().st_mtime)}")
        
        # Create a backup of current state before rollback (just in case)
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        pre_rollback_backup = self.backup_dir / f"EXECUTION_LEDGER_pre_rollback_{timestamp}.md"
        shutil.copy2(self.ledger_path, pre_rollback_backup)
        print(f"📦 Pre-rollback backup created: {pre_rollback_backup.name}")
        
        # Restore from backup
        shutil.copy2(most_recent_backup, self.ledger_path)
        
        # Remove the backup we just restored from (it's now the current state)
        most_recent_backup.unlink()
        
        print(f"✅ Successfully rolled back to previous version")
        print(f"   If you need to undo this rollback, restore from: {pre_rollback_backup.name}")
        
        return True
    
    def list_backups(self) -> List[Path]:
        """List all available backups"""
        backups = sorted(self.backup_dir.glob("EXECUTION_LEDGER_*.md"), reverse=True)
        
        if not backups:
            print("No backups available")
            return []
        
        print(f"\n📦 Available backups ({len(backups)}):\n")
        for i, backup in enumerate(backups, 1):
            timestamp = datetime.fromtimestamp(backup.stat().st_mtime)
            size = backup.stat().st_size
            print(f"  {i}. {backup.name}")
            print(f"     Created: {timestamp.strftime('%Y-%m-%d %H:%M:%S')}")
            print(f"     Size: {size:,} bytes\n")
        
        return backups
    
    def validate(self) -> bool:
        """Validate ledger structure and content with detailed error messages"""
        errors = []
        warnings = []
        
        # Check frontmatter exists
        if not self.frontmatter:
            errors.append("Missing frontmatter section")
        
        # Check required fields
        required_fields = ['current_phase', 'phase_status', 'last_updated']
        for field in required_fields:
            if field not in self.frontmatter:
                errors.append(f"Missing required field in frontmatter: '{field}'")
        
        # Validate current phase
        current_phase = self.frontmatter.get('current_phase')
        if current_phase and current_phase not in VALID_PHASES:
            errors.append(
                f"Invalid current_phase: '{current_phase}' "
                f"(must be one of: {', '.join(VALID_PHASES)})"
            )
        
        # Validate phase status
        phase_status = self.frontmatter.get('phase_status')
        if phase_status and phase_status not in VALID_STATUSES:
            errors.append(
                f"Invalid phase_status: '{phase_status}' "
                f"(must be one of: {', '.join(VALID_STATUSES)})"
            )
        
        # Validate date format
        last_updated = self.frontmatter.get('last_updated')
        if last_updated:
            try:
                datetime.strptime(last_updated, "%Y-%m-%d")
            except ValueError:
                errors.append(
                    f"Invalid date format for last_updated: '{last_updated}' "
                    "(expected format: YYYY-MM-DD)"
                )
        
        # Check for Phase Approval History section
        if "## Phase Approval History" not in self.content:
            warnings.append("Missing 'Phase Approval History' section")
        
        # Report results
        if errors:
            raise ValidationError(
                "Ledger validation failed",
                errors
            )
        
        if warnings:
            print("⚠️  Ledger validation passed with warnings:")
            for warning in warnings:
                print(f"  • {warning}")
        else:
            print("✅ Ledger validation passed")
        
        return True


def main():
    parser = argparse.ArgumentParser(
        description="Manage EXECUTION_LEDGER.md (Enhanced with dry-run and rollback)"
    )
    subparsers = parser.add_subparsers(dest='command', help='Command to execute')
    
    # Update command
    update_parser = subparsers.add_parser('update', help='Update phase status')
    update_parser.add_argument('--phase', required=True, help='Phase name (e.g., "Phase 0")')
    update_parser.add_argument('--status', required=True, choices=VALID_STATUSES, help='Phase status')
    update_parser.add_argument('--details', default='', help='Additional details')
    update_parser.add_argument('--dry-run', action='store_true', help='Preview changes without saving')
    
    # Approve command
    approve_parser = subparsers.add_parser('approve', help='Record Founder approval')
    approve_parser.add_argument('--phase', required=True, help='Phase name (e.g., "Phase 0")')
    approve_parser.add_argument('--issue', type=int, required=True, help='GitHub issue number')
    approve_parser.add_argument('--dry-run', action='store_true', help='Preview changes without saving')
    
    # Validate command
    subparsers.add_parser('validate', help='Validate ledger structure')
    
    # Get current phase command
    subparsers.add_parser('get-current-phase', help='Get current phase')
    
    # Rollback command
    subparsers.add_parser('rollback', help='Rollback to previous version')
    
    # List backups command
    subparsers.add_parser('list-backups', help='List available backups')
    
    args = parser.parse_args()
    
    if not args.command:
        parser.print_help()
        sys.exit(1)
    
    try:
        ledger = LedgerManager()
        
        if args.command == 'update':
            ledger.update_phase_status(
                args.phase, 
                args.status, 
                args.details,
                dry_run=args.dry_run
            )
        
        elif args.command == 'approve':
            ledger.record_approval(
                args.phase, 
                args.issue,
                dry_run=args.dry_run
            )
        
        elif args.command == 'validate':
            ledger.validate()
        
        elif args.command == 'get-current-phase':
            phase = ledger.get_current_phase()
            status = ledger.get_phase_status()
            print(f"{phase} ({status})")
        
        elif args.command == 'rollback':
            ledger.rollback()
        
        elif args.command == 'list-backups':
            ledger.list_backups()
    
    except ValidationError as e:
        print(str(e), file=sys.stderr)
        sys.exit(1)
    
    except Exception as e:
        print(f"❌ Unexpected error: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == '__main__':
    main()
