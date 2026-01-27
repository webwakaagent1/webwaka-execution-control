# Repository Standards

**Status:** 🔒 CANON-LOCKED  
**Authority:** Founder  
**Created:** 2026-01-26 (Phase 0 Remediation)

---

## 1. Purpose

This document defines the standards for all WebWaka repositories, including naming conventions, branch strategies, commit message formats, and directory structures. All operators must adhere to these standards to ensure consistency, maintainability, and ease of navigation.

---

## 2. Repository Naming Conventions

### 2.1. Repository Name Format

**Format:** `webwaka-{category}-{name}`

**Examples:**
- `webwaka-execution-control` (governance and execution control)
- `webwaka-platform` (main platform codebase)
- `webwaka-docs` (public documentation)
- `webwaka-infra` (infrastructure as code)

### 2.2. Category Guidelines

| Category | Purpose | Examples |
|----------|---------|----------|
| `execution` | Execution control and governance | `webwaka-execution-control` |
| `platform` | Main platform code | `webwaka-platform` |
| `docs` | Documentation | `webwaka-docs` |
| `infra` | Infrastructure as code | `webwaka-infra` |
| `module` | Industry-specific modules | `webwaka-module-pos`, `webwaka-module-parkhub` |
| `plugin` | Partner-created plugins | `webwaka-plugin-{name}` |
| `internal` | Internal tools and utilities | `webwaka-internal-{name}` |

### 2.3. Naming Rules

- **All lowercase:** No uppercase letters
- **Hyphen-separated:** Use hyphens, not underscores or spaces
- **Descriptive:** Name should clearly indicate the repository's purpose
- **Concise:** Keep names short but meaningful (max 50 characters)

---

## 3. Branch Naming Conventions

### 3.1. Protected Branches

**`main`:**
- The canonical, production-ready branch
- All work must be merged via pull request
- No direct commits allowed
- Requires Founder approval for phase-related merges
- **Branch protection MUST be configured** (see Section 3.1.1)

**`develop` (optional):**
- Integration branch for ongoing development
- Used for pre-production testing
- Merged to `main` after verification

### 3.1.1. Branch Protection Rules (REQUIRED)

**The Founder MUST configure the following branch protection rules on the `main` branch:**

**Required Settings:**
1. ✅ **Require pull request reviews before merging**
   - Minimum number of approvals: 1
   - Dismiss stale pull request approvals when new commits are pushed: Enabled
   - Require review from Code Owners: Disabled (no CODEOWNERS file yet)

2. ✅ **Require status checks to pass before merging**
   - Required status checks:
     - `Phase Gate - Prevent Phase Skipping / Verify Phase Approval and Sequential Order`
   - Require branches to be up to date before merging: Enabled

3. ✅ **Require conversation resolution before merging**
   - All PR comments must be resolved before merge

4. ✅ **Require signed commits** (recommended but optional)
   - Ensures commit authenticity

5. ✅ **Require linear history** (recommended)
   - Prevents merge commits, enforces rebase or squash

6. ✅ **Include administrators** (recommended)
   - Enforce rules for administrators too

7. ✅ **Restrict who can push to matching branches**
   - Only allow Founder and authorized Manus agents

8. ✅ **Allow force pushes: DISABLED**
   - Prevents history rewriting

9. ✅ **Allow deletions: DISABLED**
   - Prevents accidental branch deletion

**How to Configure (GitHub UI):**
1. Navigate to repository Settings
2. Click "Branches" in left sidebar
3. Click "Add branch protection rule"
4. Set "Branch name pattern" to `main`
5. Enable all settings listed above
6. Click "Create" or "Save changes"

**Verification:**
The phase-gate workflow automatically checks if branch protection is enabled and reports warnings if not configured.

**Why This Matters:**
- Prevents accidental direct commits to `main`
- Enforces code review process
- Ensures phase-gate workflow runs before merge
- Maintains execution control integrity

### 3.2. Feature Branches

**Format:** `feature/{phase}-{description}`

**Examples:**
- `feature/phase1-aws-cognito-setup`
- `feature/phase1-pwa-service-workers`
- `feature/phase2-rbac-implementation`

### 3.3. Bugfix Branches

**Format:** `bugfix/{issue-number}-{description}`

**Examples:**
- `bugfix/123-fix-auth-token-expiry`
- `bugfix/456-resolve-offline-sync-conflict`

### 3.4. Hotfix Branches

**Format:** `hotfix/{description}`

**Examples:**
- `hotfix/critical-security-patch`
- `hotfix/production-database-connection`

---

## 4. Commit Message Format

### 4.1. Commit Message Structure

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Example:**
```
feat(auth): implement AWS Cognito integration

- Add Cognito user pool configuration
- Implement OAuth 2.0 flow
- Add JWT token validation middleware

Closes #123
```

### 4.2. Commit Types

| Type | Purpose | Examples |
|------|---------|----------|
| `feat` | New feature | `feat(crm): add contact management` |
| `fix` | Bug fix | `fix(auth): resolve token expiry issue` |
| `docs` | Documentation changes | `docs(readme): update installation guide` |
| `style` | Code style changes (formatting, no logic change) | `style(api): format code with prettier` |
| `refactor` | Code refactoring (no feature change) | `refactor(db): optimize query performance` |
| `test` | Adding or updating tests | `test(auth): add unit tests for login flow` |
| `chore` | Maintenance tasks | `chore(deps): update dependencies` |
| `perf` | Performance improvements | `perf(api): optimize database queries` |
| `ci` | CI/CD changes | `ci(github): add automated testing workflow` |

### 4.3. Commit Message Rules

- **Subject line:** Max 72 characters, imperative mood ("add" not "added")
- **Body:** Explain what and why, not how (optional but recommended for complex changes)
- **Footer:** Reference issues, breaking changes, or related commits

---

## 5. Directory Structure Standards

### 5.1. Root Directory Structure (for `webwaka-execution-control`)

```
webwaka-execution-control/
├── .github/                 # GitHub Actions workflows
│   └── workflows/
│       └── phase-gate.yml   # Phase-gate enforcement workflow
├── docs/                    # Additional documentation
│   └── ASSUMPTION_VALIDATION.md  # Assumption validation procedures
├── reports/                 # STOP-SAFE and verification reports
│   ├── README.md            # Reports directory documentation
│   ├── stop-safe-report-*.md      # STOP-SAFE reports
│   └── phase-*-verification-report-*.md  # Phase verification reports
├── scripts/                 # Automation scripts
│   └── validate-assumptions.sh    # Foundational assumptions validator
├── FOUNDATIONAL_ASSUMPTIONS.md    # 15 canonically locked assumptions
├── GOVERNANCE.md                  # Core governance rules
├── EXECUTION_PHASES.md            # Phase definitions with SMART exit criteria
├── EXECUTION_LEDGER.md            # Execution history and phase status
├── EXECUTION_LEDGER_STANDARDS.md  # Ledger structure standards
├── VERIFICATION_STRATEGY.md       # Verification methods
├── STOP_SAFE_PROTOCOL.md          # Emergency stop protocol
├── REPOSITORY_STANDARDS.md        # Repository standards (this document)
├── PLATFORM_INFRASTRUCTURE.md     # Infrastructure strategy
├── AWS_BOOTSTRAP_CONFIG.md        # AWS configuration
├── AWS_IAM_SETUP_GUIDE.md         # IAM setup instructions
├── PHASE_0_VERIFICATION.md        # Phase 0 verification checklist
├── PHASE_1_EXECUTION_PROMPT.md    # Phase 1 execution instructions
├── .gitignore                     # Git ignore file
└── README.md                      # Repository README
```

### 5.2. Root Directory Structure (for `webwaka-platform`)

```
webwaka-platform/
├── .github/                 # GitHub Actions workflows, issue templates
├── docs/                    # Project documentation
├── packages/                # Monorepo packages (if using monorepo)
│   ├── api/                 # Backend API
│   ├── web/                 # Frontend web application
│   ├── shared/              # Shared code (types, utils)
│   └── infra/               # Infrastructure as code (AWS CDK)
├── scripts/                 # Build and deployment scripts
├── tests/                   # End-to-end tests
├── .gitignore               # Git ignore file
├── package.json             # Root package.json (for monorepo)
├── tsconfig.json            # Root TypeScript configuration
├── README.md                # Project README
└── LICENSE                  # License file
```

### 5.3. Backend API Directory Structure

```
packages/api/
├── src/
│   ├── modules/             # Feature modules
│   │   ├── auth/            # Authentication module
│   │   ├── crm/             # CRM module
│   │   └── billing/         # Billing module
│   ├── common/              # Shared code (middleware, guards, decorators)
│   ├── config/              # Configuration files
│   ├── database/            # Database migrations and seeds
│   ├── events/              # Event definitions and handlers
│   └── main.ts              # Application entry point
├── tests/                   # Unit and integration tests
├── package.json             # Package dependencies
├── tsconfig.json            # TypeScript configuration
└── README.md                # Module README
```

### 5.4. Frontend Web Directory Structure

```
packages/web/
├── public/                  # Static assets
│   ├── manifest.json        # PWA manifest
│   └── service-worker.js    # Service worker
├── src/
│   ├── components/          # React components
│   ├── pages/               # Page components
│   ├── hooks/               # Custom React hooks
│   ├── stores/              # State management (Zustand/Jotai)
│   ├── services/            # API clients and services
│   ├── utils/               # Utility functions
│   ├── styles/              # Global styles
│   ├── App.tsx              # Root component
│   └── main.tsx             # Application entry point
├── tests/                   # Unit and E2E tests
├── package.json             # Package dependencies
├── tsconfig.json            # TypeScript configuration
├── vite.config.ts           # Vite configuration
└── README.md                # Module README
```

---

## 6. Pull Request Standards

### 6.1. Pull Request Title Format

**Format:** `[Phase N] <type>: <description>`

**Examples:**
- `[Phase 1] feat: implement AWS Cognito authentication`
- `[Phase 1] fix: resolve offline sync conflict`
- `[Phase 2] refactor: optimize RBAC query performance`

### 6.2. Pull Request Description Template

```markdown
## Description
Brief description of the changes made.

## Related Issue
Closes #123

## Changes Made
- Change 1
- Change 2
- Change 3

## Verification
- [ ] All unit tests pass
- [ ] All integration tests pass
- [ ] Manual testing completed
- [ ] Documentation updated

## Screenshots (if applicable)
[Add screenshots here]

## Checklist
- [ ] Code follows repository standards
- [ ] Commit messages follow format
- [ ] All tests pass
- [ ] Documentation updated
- [ ] No breaking changes (or documented if unavoidable)
```

---

## 7. Code Style Standards

### 7.1. TypeScript/JavaScript

- **Linter:** ESLint with recommended rules
- **Formatter:** Prettier with default configuration
- **Style Guide:** Airbnb TypeScript Style Guide (with modifications)

### 7.2. Code Organization

- **One component per file** (for React components)
- **Barrel exports** (index.ts files) for module exports
- **Absolute imports** (using path aliases) instead of relative imports
- **Consistent naming:**
  - PascalCase for components, classes, types, interfaces
  - camelCase for functions, variables
  - UPPER_SNAKE_CASE for constants

---

## 8. Documentation Standards

### 8.1. README.md Requirements

Every repository must have a README.md with:
- Project title and description
- Installation instructions
- Usage examples
- Development setup
- Testing instructions
- Deployment instructions
- Contributing guidelines
- License information

### 8.2. Code Documentation

- **All public APIs must be documented** with JSDoc comments
- **Complex logic must be explained** with inline comments
- **All environment variables must be documented** in a `.env.example` file

---

## 9. Testing Standards

### 9.1. Test File Naming

- **Unit tests:** `{filename}.test.ts`
- **Integration tests:** `{filename}.integration.test.ts`
- **E2E tests:** `{feature}.e2e.test.ts`

### 9.2. Test Coverage Requirements

- **Minimum coverage:** 80% for all new code
- **Critical paths:** 100% coverage for authentication, billing, and data integrity

---

## 10. CI/CD Standards

### 10.1. GitHub Actions Workflows

- **`test.yml`:** Run tests on all pull requests
- **`lint.yml`:** Run linter on all pull requests
- **`deploy.yml`:** Deploy to staging/production on merge to `main`

### 10.2. Deployment Environments

- **Development:** Continuous deployment from `develop` branch
- **Staging:** Manual deployment from `main` branch
- **Production:** Manual deployment with Founder approval

---

## 11. Security Standards

### 11.1. Secrets Management

- **Never commit secrets to Git**
- **Use environment variables** for all sensitive configuration
- **Use AWS Secrets Manager** for production secrets
- **Use `.env.example`** to document required environment variables

### 11.2. Dependency Management

- **Regularly update dependencies** to patch security vulnerabilities
- **Use `npm audit`** or `yarn audit` to check for known vulnerabilities
- **Pin dependency versions** in `package.json` for production

---

## 12. Document Updates

This document may only be updated by the Founder or with explicit Founder approval.

---

**End of Repository Standards**
