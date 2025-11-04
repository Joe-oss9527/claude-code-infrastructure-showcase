# Claude Code Plugin Catalog

**Official plugin collection for Claude Code Infrastructure Showcase**

## Available Plugins

### 🔑 1. skill-activation-core (Core Plugin)

**Status**: Recommended for all users
**Description**: Core engine for auto-activating Claude Code skills based on context

**Features:**
- Automatic skill activation from user prompts
- File-based skill triggering
- Context preservation before compaction (NEW)
- Session startup checks (NEW)
- Pre-tool validation for sensitive files (NEW)

**Use when:** You want skills to automatically activate based on context

---

### 🔧 2. backend-development

**Status**: For backend developers
**Description**: Backend dev patterns for Node.js/Express/TypeScript/Prisma

**Includes:**
- Skills: `backend-dev-guidelines`
- Agents: `auth-route-tester`, `auth-route-debugger`
- Auto-activation rules for backend files

**Use when:** Building REST APIs, microservices, or backend systems

---

### ⚛️ 3. frontend-development

**Status**: For frontend developers
**Description**: React/TypeScript/MUI v7 patterns with Sentry integration

**Includes:**
- Skills: `frontend-dev-guidelines` (BLOCKING), `error-tracking`
- Agents: `frontend-error-fixer`
- MUI v7 compatibility enforcement

**Use when:** Building React frontends, especially with Material-UI

**Note:** Uses BLOCK enforcement to prevent MUI v7 incompatibilities

---

### 🧪 4. testing-utilities

**Status**: For API testing
**Description**: API route testing patterns with JWT cookie auth

**Includes:**
- Skills: `route-tester`
- Testing patterns for authenticated endpoints

**Use when:** Testing backend API routes

---

### 🛠️ 5. skill-developer-toolkit

**Status**: For plugin developers
**Description**: Meta-skill for creating Claude Code skills, hooks, and plugins

**Includes:**
- Skills: `skill-developer`
- Comprehensive guides on skill development
- Hook system documentation
- Trigger pattern examples

**Use when:** Creating your own Claude Code plugins or skills

---

### 📊 6. code-quality-suite

**Status**: For all developers
**Description**: Code review, refactoring, and documentation agents

**Includes:**
- 7 specialized agents (review, refactor, document, research, debug)
- 3 slash commands (`/dev-docs`, `/dev-docs-update`, `/route-research-for-testing`)

**Use when:** Reviewing code, planning refactors, creating documentation

---

## Recommended Combinations

### Minimal (Essential Core)
```
✅ skill-activation-core
```
Basic auto-activation for any skills you create.

### Backend Developer
```
✅ skill-activation-core
✅ backend-development
✅ testing-utilities
✅ code-quality-suite
```
Complete backend development workflow.

### Frontend Developer
```
✅ skill-activation-core
✅ frontend-development
✅ code-quality-suite
```
Complete frontend development workflow with MUI v7 enforcement.

### Full-Stack Developer
```
✅ skill-activation-core
✅ backend-development
✅ frontend-development
✅ testing-utilities
✅ code-quality-suite
```
Complete toolchain for full-stack development.

### Plugin Developer
```
✅ skill-activation-core
✅ skill-developer-toolkit
✅ code-quality-suite
```
Everything needed to create your own Claude Code plugins.

---

## Installation

See [QUICK_START.md](QUICK_START.md) for detailed installation instructions.

Quick install examples:
```bash
# Backend developers
cp -r plugins/{skill-activation-core,backend-development,testing-utilities,code-quality-suite} ~/.claude/plugins/

# Frontend developers
cp -r plugins/{skill-activation-core,frontend-development,code-quality-suite} ~/.claude/plugins/

# Full-stack developers
cp -r plugins/* ~/.claude/plugins/
```

---

## License

All plugins: MIT License

---

**Last Updated**: 2025-11-04
**Catalog Version**: 1.0
