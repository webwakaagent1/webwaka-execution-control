#!/bin/bash
# Script to deploy GitHub Actions workflows
# This script attempts to push workflow files to GitHub

echo "========================================="
echo "WebWaka Workflow Deployment Script"
echo "========================================="
echo ""

# Check if workflows exist
if [ ! -d ".github/workflows" ]; then
    echo "❌ Error: .github/workflows directory not found"
    exit 1
fi

echo "📁 Found workflow files:"
ls -lh .github/workflows/*.yml | awk '{print "  ", $9, "(" $5 ")"}'
echo ""

# Try to commit and push
echo "🔄 Attempting to push workflows to GitHub..."
git add .github/workflows/*.yml
git status

echo ""
echo "Do you want to commit and push these workflows? (y/n)"
read -r response

if [ "$response" = "y" ]; then
    git commit -m "feat: add GitHub Actions workflows for automation

- aws-bootstrap.yml: Automated AWS infrastructure setup
- validate-ledger.yml: Automatic ledger validation
- update-ledger.yml: Automatic ledger updates
- phase-gate-enhanced.yml: Phase validation and enforcement

These workflows enable full automation of the WebWaka project."
    
    echo ""
    echo "🚀 Pushing to GitHub..."
    git push origin main
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Success! Workflows deployed to GitHub"
        echo "View at: https://github.com/webwakaagent1/webwaka-execution-control/actions"
    else
        echo ""
        echo "❌ Push failed. This might be due to:"
        echo "  1. GitHub App permissions (workflows scope needed)"
        echo "  2. Branch protection rules"
        echo "  3. Authentication issues"
        echo ""
        echo "Alternative: Upload workflows manually via GitHub web interface"
    fi
else
    echo "❌ Cancelled by user"
fi
