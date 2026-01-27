#!/usr/bin/env python3
"""
WebWaka 6 Document Migration to Notion
Migrates 6 missing documents without duplicating existing content
"""

import os
from notion_client import Client

# Initialize Notion client
NOTION_TOKEN = open('/home/ubuntu/notion-migration/.notion_token').read().strip()
notion = Client(auth=NOTION_TOKEN)

# Document mapping
DOCUMENTS = {
    "remediation_reports": [
        {
            "title": "PHASE_0_REMEDIATION_REPORT.md",
            "source": "/home/ubuntu/upload/PHASE_0_REMEDIATION_REPORT.md",
            "icon": "📋",
            "target_section": "Verification & Audit Reports"
        },
        {
            "title": "Phase 0 Remediation #2 Completion Report",
            "source": "/home/ubuntu/upload/Phase0Remediation#2CompletionReport.md",
            "icon": "📋",
            "target_section": "Verification & Audit Reports"
        },
    ],
    "internal_artifacts": [
        {
            "title": "Founder Action Checklist — Phase 0 Approval",
            "source": "/home/ubuntu/upload/FounderActionChecklist—Phase0Approval.md",
            "icon": "✅",
            "target_section": "Platform Phases → Phase 0",
            "subsection": "Founder Actions"
        },
        {
            "title": "Phase 0 Handover Package for Founder",
            "source": "/home/ubuntu/upload/Phase0HandoverPackageforFounder(1).md",
            "icon": "📦",
            "target_section": "Platform Phases → Phase 0",
            "subsection": "Handover Documents"
        },
        {
            "title": "Founder Quick Start Checklist",
            "source": "/home/ubuntu/upload/FounderQuickStartChecklist.md",
            "icon": "🚀",
            "target_section": "Platform Phases → Phase 0",
            "subsection": "Quick Reference"
        },
    ],
    "internal_documentation": [
        {
            "title": "Internal Artifacts Inventory",
            "source": "/home/ubuntu/upload/INTERNAL_ARTIFACTS_INVENTORY.md",
            "icon": "🤖",
            "target_section": "Internal Documentation",
            "subsection": "Manus Session Artifacts"
        },
    ]
}

def create_page(parent_id, title, icon=None):
    """Create a new Notion page"""
    page_data = {
        "parent": {"page_id": parent_id},
        "properties": {
            "title": {
                "title": [{"text": {"content": title}}]
            }
        }
    }
    
    if icon:
        page_data["icon"] = {"emoji": icon}
    
    return notion.pages.create(**page_data)

def add_content_to_page(page_id, content):
    """Add markdown content to a Notion page - handles full content"""
    lines = content.split('\n')
    
    # Process in batches of 100 blocks (Notion API limit)
    batch_size = 100
    for i in range(0, len(lines), batch_size):
        batch_lines = lines[i:i + batch_size]
        blocks = []
        
        for line in batch_lines:
            # Handle different content types
            if line.strip().startswith('# '):
                # Heading 1
                blocks.append({
                    "object": "block",
                    "type": "heading_1",
                    "heading_1": {
                        "rich_text": [{"type": "text", "text": {"content": line.strip()[2:][:2000]}}]
                    }
                })
            elif line.strip().startswith('## '):
                # Heading 2
                blocks.append({
                    "object": "block",
                    "type": "heading_2",
                    "heading_2": {
                        "rich_text": [{"type": "text", "text": {"content": line.strip()[3:][:2000]}}]
                    }
                })
            elif line.strip().startswith('### '):
                # Heading 3
                blocks.append({
                    "object": "block",
                    "type": "heading_3",
                    "heading_3": {
                        "rich_text": [{"type": "text", "text": {"content": line.strip()[4:][:2000]}}]
                    }
                })
            elif line.strip():
                # Regular paragraph
                blocks.append({
                    "object": "block",
                    "type": "paragraph",
                    "paragraph": {
                        "rich_text": [{"type": "text", "text": {"content": line[:2000]}}]
                    }
                })
        
        if blocks:
            try:
                notion.blocks.children.append(block_id=page_id, children=blocks)
            except Exception as e:
                print(f"    Warning: Batch append error: {e}")
                # Try one by one if batch fails
                for block in blocks:
                    try:
                        notion.blocks.children.append(block_id=page_id, children=[block])
                    except:
                        pass

def find_page_by_title(title):
    """Search for a page by title"""
    try:
        results = notion.search(query=title, filter={"property": "object", "value": "page"})
        pages = results.get("results", [])
        
        for page in pages:
            try:
                page_title_prop = page.get("properties", {}).get("title", {}).get("title", [])
                if page_title_prop:
                    page_title = page_title_prop[0].get("text", {}).get("content", "")
                    if title.lower() in page_title.lower():
                        return page["id"]
            except:
                continue
        return None
    except Exception as e:
        print(f"Search error: {e}")
        return None

def main():
    print("=" * 70)
    print("WebWaka 6 Document Migration to Notion")
    print("=" * 70)
    
    # Find target sections
    print("\n1. Finding target sections in Notion...")
    
    verification_section_id = find_page_by_title("Verification & Audit Reports")
    phase0_section_id = find_page_by_title("Platform Phases → Phase 0")
    
    if not verification_section_id:
        print("ERROR: Could not find 'Verification & Audit Reports' section")
        return
    
    if not phase0_section_id:
        print("ERROR: Could not find 'Platform Phases → Phase 0' section")
        return
    
    print(f"✓ Found Verification & Audit Reports: {verification_section_id}")
    print(f"✓ Found Platform Phases → Phase 0: {phase0_section_id}")
    
    # Find or create Internal Documentation section
    internal_doc_id = find_page_by_title("Internal Documentation")
    if not internal_doc_id:
        print("\n2. Creating 'Internal Documentation' section...")
        # Find root page
        results = notion.search(filter={"property": "object", "value": "page"})
        pages = results.get("results", [])
        root_page_id = pages[0]["id"] if pages else None
        
        if root_page_id:
            internal_doc_page = create_page(root_page_id, "5️⃣ Internal Documentation", icon="🤖")
            internal_doc_id = internal_doc_page["id"]
            print(f"✓ Created Internal Documentation: {internal_doc_id}")
        else:
            print("ERROR: Could not find root page")
            return
    else:
        print(f"\n2. Found existing Internal Documentation: {internal_doc_id}")
    
    # Migrate remediation reports
    print("\n3. Migrating Remediation Reports...")
    for doc in DOCUMENTS["remediation_reports"]:
        try:
            print(f"\n  Migrating: {doc['title']}")
            content = open(doc["source"]).read()
            page = create_page(verification_section_id, doc["title"], icon=doc["icon"])
            add_content_to_page(page["id"], content)
            print(f"  ✓ {doc['title']} - {len(content)} chars migrated")
        except Exception as e:
            print(f"  ✗ {doc['title']}: {e}")
    
    # Migrate internal artifacts to Phase 0
    print("\n4. Migrating Internal Artifacts to Phase 0...")
    for doc in DOCUMENTS["internal_artifacts"]:
        try:
            print(f"\n  Migrating: {doc['title']}")
            content = open(doc["source"]).read()
            
            # Create subsection if specified
            if "subsection" in doc:
                subsection_id = find_page_by_title(doc["subsection"])
                if not subsection_id:
                    print(f"    Creating subsection: {doc['subsection']}")
                    subsection_page = create_page(phase0_section_id, doc["subsection"], icon="📁")
                    subsection_id = subsection_page["id"]
                
                page = create_page(subsection_id, doc["title"], icon=doc["icon"])
            else:
                page = create_page(phase0_section_id, doc["title"], icon=doc["icon"])
            
            add_content_to_page(page["id"], content)
            print(f"  ✓ {doc['title']} - {len(content)} chars migrated")
        except Exception as e:
            print(f"  ✗ {doc['title']}: {e}")
    
    # Migrate internal documentation
    print("\n5. Migrating Internal Documentation...")
    for doc in DOCUMENTS["internal_documentation"]:
        try:
            print(f"\n  Migrating: {doc['title']}")
            content = open(doc["source"]).read()
            
            # Create subsection
            subsection_id = find_page_by_title(doc["subsection"])
            if not subsection_id:
                print(f"    Creating subsection: {doc['subsection']}")
                subsection_page = create_page(internal_doc_id, doc["subsection"], icon="🗂️")
                subsection_id = subsection_page["id"]
            
            page = create_page(subsection_id, doc["title"], icon=doc["icon"])
            add_content_to_page(page["id"], content)
            print(f"  ✓ {doc['title']} - {len(content)} chars migrated")
        except Exception as e:
            print(f"  ✗ {doc['title']}: {e}")
    
    print("\n" + "=" * 70)
    print("Migration Complete!")
    print("=" * 70)
    print("\nSummary:")
    print("  • 2 Remediation Reports → Verification & Audit Reports")
    print("  • 3 Internal Artifacts → Platform Phases → Phase 0")
    print("  • 1 Inventory → Internal Documentation")
    print("\nTotal: 6 documents migrated")

if __name__ == "__main__":
    main()
