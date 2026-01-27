#!/bin/bash

# Foundational Assumptions Validation Script
# Purpose: Automatically validate alignment with the 15 foundational assumptions
# Authority: Execution Control System
# Created: 2026-01-27

set -e

echo "========================================="
echo "WebWaka Foundational Assumptions Validator"
echo "========================================="
echo ""

VALIDATION_FAILED=0

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print success
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

# Function to print failure
print_failure() {
    echo -e "${RED}✗${NC} $1"
    VALIDATION_FAILED=1
}

# Function to print warning
print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Function to print info
print_info() {
    echo "ℹ $1"
}

echo "Starting validation..."
echo ""

# ============================================
# ASSUMPTION #1: AWS-First Architecture
# ============================================
echo "Validating Assumption #1: AWS-First Architecture"
echo "------------------------------------------------"

# Check for non-AWS services in package.json
if [ -f "package.json" ]; then
    print_info "Checking package.json for non-AWS services..."
    
    NON_AWS_SERVICES=(
        "firebase"
        "supabase"
        "@supabase"
        "google-cloud"
        "@google-cloud"
        "azure"
        "@azure"
        "heroku"
        "netlify"
        "vercel"
    )
    
    for service in "${NON_AWS_SERVICES[@]}"; do
        if grep -q "\"$service\"" package.json 2>/dev/null; then
            print_failure "Non-AWS service detected in package.json: $service"
        fi
    done
fi

# Check for non-AWS services in requirements.txt
if [ -f "requirements.txt" ]; then
    print_info "Checking requirements.txt for non-AWS services..."
    
    NON_AWS_SERVICES=(
        "firebase"
        "supabase"
        "google-cloud"
        "azure"
        "heroku"
    )
    
    for service in "${NON_AWS_SERVICES[@]}"; do
        if grep -q "$service" requirements.txt 2>/dev/null; then
            print_failure "Non-AWS service detected in requirements.txt: $service"
        fi
    done
fi

# Check for AWS services in infrastructure files
print_info "Checking for AWS service usage..."

AWS_SERVICES_FOUND=0

# Check for AWS Cognito
if grep -rq "cognito" --include="*.tf" --include="*.yml" --include="*.yaml" --include="*.json" . 2>/dev/null; then
    print_success "AWS Cognito detected"
    AWS_SERVICES_FOUND=$((AWS_SERVICES_FOUND + 1))
fi

# Check for AWS Aurora/RDS
if grep -rq -E "(aurora|rds)" --include="*.tf" --include="*.yml" --include="*.yaml" --include="*.json" . 2>/dev/null; then
    print_success "AWS Aurora/RDS detected"
    AWS_SERVICES_FOUND=$((AWS_SERVICES_FOUND + 1))
fi

# Check for AWS Fargate/ECS
if grep -rq -E "(fargate|ecs)" --include="*.tf" --include="*.yml" --include="*.yaml" --include="*.json" . 2>/dev/null; then
    print_success "AWS Fargate/ECS detected"
    AWS_SERVICES_FOUND=$((AWS_SERVICES_FOUND + 1))
fi

if [ $AWS_SERVICES_FOUND -eq 0 ]; then
    print_warning "No AWS services detected yet (acceptable in Phase 0)"
fi

echo ""

# ============================================
# ASSUMPTION #4: PWA-First Design
# ============================================
echo "Validating Assumption #4: PWA-First Design"
echo "-------------------------------------------"

# Check for manifest.json
if [ -f "public/manifest.json" ] || [ -f "src/manifest.json" ] || [ -f "manifest.json" ]; then
    print_success "PWA manifest.json found"
else
    print_warning "PWA manifest.json not found (acceptable in Phase 0, required in Phase 1)"
fi

# Check for service worker
if grep -rq "serviceWorker" --include="*.js" --include="*.ts" --include="*.jsx" --include="*.tsx" . 2>/dev/null; then
    print_success "Service worker implementation detected"
else
    print_warning "Service worker not detected (acceptable in Phase 0, required in Phase 1)"
fi

echo ""

# ============================================
# ASSUMPTION #5: Offline-First Capability
# ============================================
echo "Validating Assumption #5: Offline-First Capability"
echo "---------------------------------------------------"

# Check for IndexedDB usage
if grep -rq -E "(indexedDB|IndexedDB|idb)" --include="*.js" --include="*.ts" --include="*.jsx" --include="*.tsx" . 2>/dev/null; then
    print_success "IndexedDB usage detected"
else
    print_warning "IndexedDB not detected (acceptable in Phase 0, required in Phase 1)"
fi

# Check for offline-related code
if grep -rq -E "(offline|navigator\.onLine)" --include="*.js" --include="*.ts" --include="*.jsx" --include="*.tsx" . 2>/dev/null; then
    print_success "Offline handling code detected"
else
    print_warning "Offline handling not detected (acceptable in Phase 0, required in Phase 1)"
fi

echo ""

# ============================================
# ASSUMPTION #8: Nigeria-First Design
# ============================================
echo "Validating Assumption #8: Nigeria-First Design"
echo "-----------------------------------------------"

# Check for Nigeria-specific configuration
if grep -rq -E "(nigeria|naira|NGN)" --include="*.json" --include="*.yml" --include="*.yaml" --include="*.md" . 2>/dev/null; then
    print_success "Nigeria-specific configuration detected"
else
    print_warning "Nigeria-specific configuration not detected (acceptable in Phase 0)"
fi

# Check for af-south-1 region (closest to Nigeria)
if grep -rq "af-south-1" --include="*.md" --include="*.yml" --include="*.yaml" --include="*.json" --include="*.tf" . 2>/dev/null; then
    print_success "AWS region af-south-1 (Africa - Cape Town) configured"
else
    print_warning "AWS region af-south-1 not detected (should be configured in Phase 0)"
fi

echo ""

# ============================================
# ASSUMPTION #15: Absolute State Persistence
# ============================================
echo "Validating Assumption #15: Absolute State Persistence"
echo "------------------------------------------------------"

# Check for uncommitted changes
if [ -d ".git" ]; then
    print_info "Checking for uncommitted changes..."
    
    if git diff --quiet && git diff --cached --quiet; then
        print_success "No uncommitted changes detected"
    else
        print_failure "Uncommitted changes detected - violates Absolute State Persistence"
    fi
    
    # Check if local branch is ahead of remote
    if git rev-parse --abbrev-ref HEAD@{upstream} >/dev/null 2>&1; then
        LOCAL=$(git rev-parse @)
        REMOTE=$(git rev-parse @{u})
        
        if [ "$LOCAL" = "$REMOTE" ]; then
            print_success "Local branch is in sync with remote"
        else
            print_failure "Local branch is ahead of remote - violates Absolute State Persistence"
        fi
    else
        print_warning "No upstream branch configured"
    fi
else
    print_warning "Not a git repository"
fi

echo ""

# ============================================
# Summary
# ============================================
echo "========================================="
echo "Validation Summary"
echo "========================================="
echo ""

if [ $VALIDATION_FAILED -eq 1 ]; then
    echo -e "${RED}✗ VALIDATION FAILED${NC}"
    echo ""
    echo "One or more foundational assumptions are violated."
    echo "Please review the failures above and fix them before proceeding."
    echo ""
    exit 1
else
    echo -e "${GREEN}✓ VALIDATION PASSED${NC}"
    echo ""
    echo "All automatically validatable foundational assumptions are satisfied."
    echo ""
    echo "Note: Some assumptions require manual verification by the IVM:"
    echo "  - Assumption #2: Founder-Centric Governance"
    echo "  - Assumption #3: Phase-Gated Execution"
    echo "  - Assumption #6: Extensibility-First Architecture"
    echo "  - Assumption #7: Partner-Branded Multi-Tenancy"
    echo "  - Assumption #9: AI-Augmented Operations"
    echo "  - Assumption #10: Event-Driven Architecture"
    echo "  - Assumption #11: Transactional Integrity"
    echo "  - Assumption #12: Security-First Design"
    echo "  - Assumption #13: Observability-First Operations"
    echo "  - Assumption #14: Cost-Conscious Optimization"
    echo ""
    echo "See docs/ASSUMPTION_VALIDATION.md for manual verification procedures."
    echo ""
    exit 0
fi
