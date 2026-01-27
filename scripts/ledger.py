#!/usr/bin/env python3
"""
EXECUTION_LEDGER Automation Script

This script automates the management of the EXECUTION_LEDGER.md file,
ensuring consistent updates and validation of phase transitions.

Usage:
    python scripts/ledger.py update --phase "Phase 0" --status "complete" --details "All work done"
    python scripts/ledger.py approve --phase "Phase 0" --issue 123
    python scripts/ledger.py validate
    python scripts/ledger.py get-current-phase
"""

import argparse
import re
import sys
from datetime import datetime
from pathlib import Path
from typing import Optional, Dict, Any

# Constants
LEDGER_FILE = Path(__file__).parent.parent / "EXECUTION_LEDGER.md"
VALID_PHASES = ["Phase 0", "Phase 1", "Phase 2", "Phase 3", "Phase 4", "Phase 5"]
VALID_STATUSES = ["not_started", "in_progress", "complete", "approved"]

class LedgerManager:
    """Manages the EXECUTION_LEDGER.md file"""
    
    def __init__(self, ledger_path: Path = LEDGER_FILE):
        self.ledger_path = ledger_path
        self.content = self._read_ledger()
        self.frontmatter = self._parse_frontmatter()
    
    def _read_ledger(self) -> str:
        """Read the ledger file"""
        if not self.ledger_path.exists():
            raise FileNotFoundError(f"Ledger file not found: {self.ledger_path}")
        return self.ledger_path.read_text()
    
    def _write_ledger(self, content: str):
        """Write content to ledger file"""
        self.ledger_path.write_text(content)
        self.content = content
    
    def _parse_frontmatter(self) -> Dict[str, Any]:
        """Parse YAML frontmatter from ledger"""
        match = re.search(r'^---\n(.*?)\n---', self.content, re.DOTALL)
        if not match:
            raise ValueError("No frontmatter found in ledger")
        
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
    
    def update_phase_status(self, phase: str, status: str, details: str = ""):
        """Update phase status in ledger"""
        # Validate inputs
        if phase not in VALID_PHASES:
            raise ValueError(f"Invalid phase: {phase}. Must be one of {VALID_PHASES}")
        if status not in VALID_STATUSES:
            raise ValueError(f"Invalid status: {status}. Must be one of {VALID_STATUSES}")
        
        # Validate phase transition
        current_phase = self.get_current_phase()
        if not self._is_valid_transition(current_phase, phase):
            raise ValueError(f"Invalid phase transition: {current_phase} → {phase}")
        
        # Update frontmatter
        today = datetime.now().strftime("%Y-%m-%d")
        self._update_frontmatter({
            'current_phase': phase,
            'phase_status': status,
            'last_updated': today
        })
        
        # Add history entry
        self._add_history_entry(phase, status, details)
        
        # Write changes
        self._write_ledger(self.content)
        
        print(f"✅ Updated ledger: {phase} → {status}")
    
    def record_approval(self, phase: str, issue_number: int):
        """Record Founder approval for a phase"""
        if phase not in VALID_PHASES:
            raise ValueError(f"Invalid phase: {phase}. Must be one of {VALID_PHASES}")
        
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
        
        # Write changes
        self._write_ledger(self.content)
        
        print(f"✅ Recorded approval: {phase} (Issue #{issue_number})")
    
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
    
    def validate(self) -> bool:
        """Validate ledger structure and content"""
        errors = []
        
        # Check frontmatter exists
        if not self.frontmatter:
            errors.append("Missing frontmatter")
        
        # Check required fields
        required_fields = ['current_phase', 'phase_status', 'last_updated']
        for field in required_fields:
            if field not in self.frontmatter:
                errors.append(f"Missing required field: {field}")
        
        # Validate current phase
        current_phase = self.frontmatter.get('current_phase')
        if current_phase not in VALID_PHASES:
            errors.append(f"Invalid current_phase: {current_phase}")
        
        # Validate phase status
        phase_status = self.frontmatter.get('phase_status')
        if phase_status not in VALID_STATUSES:
            errors.append(f"Invalid phase_status: {phase_status}")
        
        # Validate date format
        last_updated = self.frontmatter.get('last_updated')
        if last_updated:
            try:
                datetime.strptime(last_updated, "%Y-%m-%d")
            except ValueError:
                errors.append(f"Invalid date format: {last_updated}")
        
        # Report results
        if errors:
            print("❌ Ledger validation failed:")
            for error in errors:
                print(f"  - {error}")
            return False
        else:
            print("✅ Ledger validation passed")
            return True


def main():
    parser = argparse.ArgumentParser(description="Manage EXECUTION_LEDGER.md")
    subparsers = parser.add_subparsers(dest='command', help='Command to execute')
    
    # Update command
    update_parser = subparsers.add_parser('update', help='Update phase status')
    update_parser.add_argument('--phase', required=True, help='Phase name (e.g., "Phase 0")')
    update_parser.add_argument('--status', required=True, choices=VALID_STATUSES, help='Phase status')
    update_parser.add_argument('--details', default='', help='Additional details')
    
    # Approve command
    approve_parser = subparsers.add_parser('approve', help='Record Founder approval')
    approve_parser.add_argument('--phase', required=True, help='Phase name (e.g., "Phase 0")')
    approve_parser.add_argument('--issue', type=int, required=True, help='GitHub issue number')
    
    # Validate command
    subparsers.add_parser('validate', help='Validate ledger structure')
    
    # Get current phase command
    subparsers.add_parser('get-current-phase', help='Get current phase')
    
    args = parser.parse_args()
    
    if not args.command:
        parser.print_help()
        sys.exit(1)
    
    try:
        ledger = LedgerManager()
        
        if args.command == 'update':
            ledger.update_phase_status(args.phase, args.status, args.details)
        
        elif args.command == 'approve':
            ledger.record_approval(args.phase, args.issue)
        
        elif args.command == 'validate':
            if not ledger.validate():
                sys.exit(1)
        
        elif args.command == 'get-current-phase':
            phase = ledger.get_current_phase()
            status = ledger.get_phase_status()
            print(f"{phase} ({status})")
    
    except Exception as e:
        print(f"❌ Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == '__main__':
    main()
