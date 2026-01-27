#!/usr/bin/env python3
"""
WebWaka Documentation Migration to Notion
Migrates all Phase 0 documents from GitHub and audit reports to Notion
"""

import os
from notion_client import Client
from pathlib import Path

# Initialize Notion client
NOTION_TOKEN = open('/home/ubuntu/notion-migration/.notion_token').read().strip()
notion = Client(auth=NOTION_TOKEN)

# Document inventory with source paths and metadata
DOCUMENTS = {
    "constitution": [
        {
            "title": "FOUNDATIONAL_ASSUMPTIONS.md",
            "source": "/home/ubuntu/webwaka-execution-control/FOUNDATIONAL_ASSUMPTIONS.md",
            "priority": "CRITICAL",
            "description": "15 locked foundational assumptions"
        },
        {
            "title": "GOVERNANCE.md",
            "source": "/home/ubuntu/webwaka-execution-control/GOVERNANCE.md",
            "priority": "CRITICAL",
            "description": "Governance framework and enforcement"
        },
        {
            "title": "EXECUTION_PHASES.md",
            "source": "/home/ubuntu/webwaka-execution-control/EXECUTION_PHASES.md",
            "priority": "CRITICAL",
            "description": "Phase definitions and exit criteria"
        },
        {
            "title": "VERIFICATION_STRATEGY.md",
            "source": "/home/ubuntu/webwaka-execution-control/VERIFICATION_STRATEGY.md",
            "priority": "CRITICAL",
            "description": "Verification methods and protocols"
        },
        {
            "title": "STOP_SAFE_PROTOCOL.md",
            "source": "/home/ubuntu/webwaka-execution-control/STOP_SAFE_PROTOCOL.md",
            "priority": "HIGH",
            "description": "Emergency stop procedures"
        },
    ],
    "phase0": [
        {
            "title": "PHASE_0_FINAL_COMPLETION_REPORT.md",
            "source": "/home/ubuntu/webwaka-execution-control/PHASE_0_FINAL_COMPLETION_REPORT.md",
            "priority": "CRITICAL",
            "description": "Phase 0 completion claim"
        },
        {
            "title": "PLATFORM_INFRASTRUCTURE.md",
            "source": "/home/ubuntu/webwaka-execution-control/PLATFORM_INFRASTRUCTURE.md",
            "priority": "HIGH",
            "description": "Infrastructure strategy"
        },
        {
            "title": "REPOSITORY_STANDARDS.md",
            "source": "/home/ubuntu/webwaka-execution-control/REPOSITORY_STANDARDS.md",
            "priority": "MEDIUM",
            "description": "Repository conventions"
        },
        {
            "title": "phase-gate.yml",
            "source": "/home/ubuntu/webwaka-execution-control/.github/workflows/phase-gate.yml",
            "priority": "HIGH",
            "description": "Automated phase-gate workflow"
        },
    ],
    "phase1": [
        {
            "title": "PHASE_1_EXECUTION_PROMPT.md",
            "source": "/home/ubuntu/webwaka-execution-control/PHASE_1_EXECUTION_PROMPT.md",
            "priority": "HIGH",
            "description": "Phase 1 execution instructions"
        },
    ],
    "verification": [
        {
            "title": "Phase0_IVM_Verification_Report.md",
            "source": "/home/ubuntu/phase0-audit/Phase0_IVM_Verification_Report.md",
            "priority": "CRITICAL",
            "description": "Independent verification report"
        },
        {
            "title": "REQUIRED_FIXES_BEFORE_PHASE_1.md",
            "source": "/home/ubuntu/phase0-audit/REQUIRED_FIXES_BEFORE_PHASE_1.md",
            "priority": "CRITICAL",
            "description": "Blocking issues list"
        },
        {
            "title": "findings_tracker.md",
            "source": "/home/ubuntu/phase0-audit/findings_tracker.md",
            "priority": "HIGH",
            "description": "Detailed findings"
        },
        {
            "title": "consistency_analysis.md",
            "source": "/home/ubuntu/phase0-audit/consistency_analysis.md",
            "priority": "HIGH",
            "description": "Internal consistency assessment"
        },
        {
            "title": "enforceability_assessment.md",
            "source": "/home/ubuntu/phase0-audit/enforceability_assessment.md",
            "priority": "HIGH",
            "description": "Enforceability evaluation"
        },
        {
            "title": "founder_isolation_forward_compatibility.md",
            "source": "/home/ubuntu/phase0-audit/founder_isolation_forward_compatibility.md",
            "priority": "HIGH",
            "description": "Founder isolation test results"
        },
    ],
}

def create_page(parent_id, title, content="", icon=None):
    """Create a new Notion page"""
    properties = {
        "title": {
            "title": [
                {
                    "text": {
                        "content": title
                    }
                }
            ]
        }
    }
    
    page_data = {
        "parent": {"page_id": parent_id},
        "properties": properties,
    }
    
    if icon:
        page_data["icon"] = {"emoji": icon}
    
    # Create the page
    page = notion.pages.create(**page_data)
    
    # Add content if provided
    if content:
        add_content_to_page(page["id"], content)
    
    return page

def add_content_to_page(page_id, content):
    """Add markdown content to a Notion page"""
    # Split content into chunks (Notion has block limits)
    lines = content.split('\n')
    blocks = []
    
    for line in lines[:100]:  # Limit to first 100 lines for now
        if line.strip():
            blocks.append({
                "object": "block",
                "type": "paragraph",
                "paragraph": {
                    "rich_text": [{
                        "type": "text",
                        "text": {"content": line[:2000]}  # Notion limit
                    }]
                }
            })
    
    if blocks:
        notion.blocks.children.append(block_id=page_id, children=blocks)

def get_workspace_pages():
    """Get all pages the integration has access to"""
    try:
        results = notion.search(filter={"property": "object", "value": "page"})
        return results.get("results", [])
    except Exception as e:
        print(f"Error searching pages: {e}")
        return []

def main():
    print("=" * 60)
    print("WebWaka Documentation Migration to Notion")
    print("=" * 60)
    
    # First, find the workspace root
    print("\n1. Finding workspace pages...")
    pages = get_workspace_pages()
    
    if not pages:
        print("ERROR: No pages found. The integration may not have proper access.")
        return
    
    print(f"Found {len(pages)} accessible pages:")
    for page in pages:
        try:
            title_prop = page.get("properties", {}).get("title", {}).get("title", [])
            if title_prop:
                title = title_prop[0].get("text", {}).get("content", "Untitled")
            else:
                title = "Untitled"
        except:
            title = "Untitled"
        print(f"  - {title} (ID: {page['id']})")  
    
    # Use the first page as parent (or create a new root page)
    root_page_id = pages[0]["id"]
    print(f"\nUsing page as parent: {root_page_id}")
    
    # Create top-level structure
    print("\n2. Creating top-level structure...")
    
    try:
        constitution_page = create_page(
            root_page_id,
            "1️⃣ WebWaka Constitution",
            icon="📜"
        )
        print(f"✓ Created: WebWaka Constitution")
        
        phase0_page = create_page(
            root_page_id,
            "2️⃣ Platform Phases → Phase 0",
            icon="🏗️"
        )
        print(f"✓ Created: Platform Phases → Phase 0")
        
        phase1_page = create_page(
            root_page_id,
            "3️⃣ Platform Phases → Phase 1",
            icon="🚀"
        )
        print(f"✓ Created: Platform Phases → Phase 1")
        
        verification_page = create_page(
            root_page_id,
            "4️⃣ Verification & Audit Reports",
            icon="🔍"
        )
        print(f"✓ Created: Verification & Audit Reports")
        
        print("\n3. Migrating documents...")
        
        # Migrate Constitution documents
        print("\n  Constitution documents:")
        for doc in DOCUMENTS["constitution"]:
            try:
                content = open(doc["source"]).read()
                create_page(constitution_page["id"], doc["title"], content)
                print(f"    ✓ {doc['title']}")
            except Exception as e:
                print(f"    ✗ {doc['title']}: {e}")
        
        # Migrate Phase 0 documents
        print("\n  Phase 0 documents:")
        for doc in DOCUMENTS["phase0"]:
            try:
                content = open(doc["source"]).read()
                create_page(phase0_page["id"], doc["title"], content)
                print(f"    ✓ {doc['title']}")
            except Exception as e:
                print(f"    ✗ {doc['title']}: {e}")
        
        # Migrate Phase 1 documents
        print("\n  Phase 1 documents:")
        for doc in DOCUMENTS["phase1"]:
            try:
                content = open(doc["source"]).read()
                create_page(phase1_page["id"], doc["title"], content)
                print(f"    ✓ {doc['title']}")
            except Exception as e:
                print(f"    ✗ {doc['title']}: {e}")
        
        # Migrate Verification documents
        print("\n  Verification documents:")
        for doc in DOCUMENTS["verification"]:
            try:
                content = open(doc["source"]).read()
                create_page(verification_page["id"], doc["title"], content)
                print(f"    ✓ {doc['title']}")
            except Exception as e:
                print(f"    ✗ {doc['title']}: {e}")
        
        print("\n" + "=" * 60)
        print("Migration Complete!")
        print("=" * 60)
        
    except Exception as e:
        print(f"\nERROR during migration: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    main()
