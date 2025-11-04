# Claude Code Infrastructure Showcase

**Official plugin collection for production-tested Claude Code infrastructure**

Born from 6 months of real-world use managing a complex TypeScript microservices project, this showcase provides the patterns and systems that solved the "skills don't activate automatically" problem and scaled Claude Code for enterprise development.

Now refactored into **6 independent plugins** following the official Claude Code plugin specification.

---

## 🎯 What's New (v1.0 - Plugin Architecture)

### Plugin-Based Architecture
- ✅ **6 independent plugins** - Install only what you need
- ✅ **Official specification** - Follows Claude Code plugin standards
- ✅ **Modular installation** - Mix and match for your workflow
- ✅ **Standardized structure** - `plugin.json`, proper versioning
- ✅ **New hook events** - PreCompact, SessionStart, PreToolUse

### Migration from Old Structure
If you used the previous `.claude/` structure, see [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md).

---

## 📦 Available Plugins

### 🔑 skill-activation-core (Essential)
**Core engine for auto-activating skills based on context**

- Automatic skill activation from prompts
- File-based skill triggering
- 5 hook events (3 new in v1.0)
- Context preservation before compaction

**Recommended for:** Everyone

### 🔧 backend-development
**Node.js/Express/TypeScript/Prisma patterns**

- Layered architecture guidelines
- BaseController pattern
- Error handling with Sentry
- Auth route testing agents

**Recommended for:** Backend developers, API builders

### ⚛️ frontend-development
**React/TypeScript/MUI v7 patterns**

- MUI v7 compatibility enforcement (BLOCKS incompatible code)
- Suspense and lazy loading patterns
- Frontend error debugging
- Sentry integration

**Recommended for:** Frontend developers, React teams

### 🧪 testing-utilities
**API route testing with JWT cookie auth**

- Authenticated endpoint testing
- Mock authentication patterns
- Route verification

**Recommended for:** Backend testing, QA

### 🛠️ skill-developer-toolkit
**Create your own skills, hooks, and plugins**

- Meta-skill for skill development
- Hook system deep-dive
- Trigger pattern examples
- Best practices and troubleshooting

**Recommended for:** Plugin developers, power users

### 📊 code-quality-suite
**Code review, refactoring, documentation agents**

- 7 specialized agents
- 3 slash commands
- Planning and review workflows
- Research and debugging tools

**Recommended for:** All developers

---

## 🚀 Quick Start

**Choose your path:**

### New User? Start Here
```bash
# Clone repository
git clone https://github.com/your-org/claude-code-infrastructure-showcase

# See quick start guide
cat QUICK_START.md
```

### Know What You Want?
```bash
# Backend developers
cp -r plugins/{skill-activation-core,backend-development,testing-utilities,code-quality-suite} ~/.claude/plugins/

# Frontend developers
cp -r plugins/{skill-activation-core,frontend-development,code-quality-suite} ~/.claude/plugins/

# Full-stack developers
cp -r plugins/* ~/.claude/plugins/

# Install dependencies
cd ~/.claude/plugins/skill-activation-core && npm install
```

### Migrating from Old Structure?
See [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) for step-by-step migration.

---

## 📚 Documentation

- **[PLUGIN_CATALOG.md](PLUGIN_CATALOG.md)** - Complete plugin reference
- **[QUICK_START.md](QUICK_START.md)** - 5-minute installation guide
- **[MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)** - Upgrade from old structure
- **[CLAUDE_INTEGRATION_GUIDE.md](CLAUDE_INTEGRATION_GUIDE.md)** - AI-assisted setup (updated for v1.0)
- **Plugin READMEs** - Each plugin has detailed docs in `plugins/*/README.md`

---

## 💡 Key Features

### Auto-Activating Skills
**The breakthrough that started it all:**

Skills that actually activate when you need them, not when you remember them.

**How it works:**
1. UserPromptSubmit hook analyzes your prompts
2. Checks skill-rules.json for trigger patterns
3. Automatically suggests relevant skills
4. No manual invocation needed

**Example:**
```
You: "I need to create a new API endpoint"
Claude: [Auto-loads backend-dev-guidelines skill]
```

### Modular Skills (500-Line Rule)
Large skills hit context limits. Solution:

```
skill-name/
  SKILL.md                  # <500 lines, high-level guide
  resources/
    topic-1.md              # <500 lines each
    topic-2.md              # Progressive disclosure
    topic-3.md
```

**All skills follow this pattern** - main file + resource files loaded on demand.

### Production-Tested Patterns
Extracted from real-world use:
- ✅ 6 microservices in production
- ✅ 50,000+ lines of TypeScript
- ✅ Complex React frontend
- ✅ 6 months of daily Claude Code usage

**These patterns work because they solved real problems.**

### New Hook Events (v1.0)
- **PreCompact**: Auto-save dev docs before context compaction
- **SessionStart**: Welcome message and dependency checks
- **PreToolUse**: Validate operations (blocks sensitive files)

---

## 📂 Repository Structure

```
claude-code-infrastructure-showcase/
├── plugins/                           # NEW: 6 independent plugins
│   ├── skill-activation-core/         # Hook system + auto-activation
│   ├── backend-development/           # Backend patterns + agents
│   ├── frontend-development/          # Frontend patterns + agents
│   ├── testing-utilities/             # API testing patterns
│   ├── skill-developer-toolkit/       # Meta-skill for creating skills
│   └── code-quality-suite/            # Review/refactor/docs agents
│
├── dev/                               # Dev docs pattern examples
│   └── active/public-infrastructure-repo/
│
├── PLUGIN_CATALOG.md                  # Complete plugin reference
├── QUICK_START.md                     # 5-minute setup guide
├── MIGRATION_GUIDE.md                 # Upgrade from v0.x
├── CLAUDE_INTEGRATION_GUIDE.md        # AI-assisted integration
├── README.md                          # This file
└── LICENSE                            # MIT
```

---

## 🎨 Plugin Component Breakdown

### Skills (5 total across plugins)
- **backend-dev-guidelines** (12 resources) - Express/Prisma/TypeScript
- **frontend-dev-guidelines** (11 resources) - React/MUI v7
- **skill-developer** (7 resources) - Creating skills
- **route-tester** - API testing
- **error-tracking** - Sentry integration

### Agents (10 total)
- code-architecture-reviewer
- code-refactor-master
- documentation-architect
- frontend-error-fixer
- plan-reviewer
- refactor-planner
- web-research-specialist
- auth-route-tester
- auth-route-debugger
- auto-error-resolver

### Slash Commands (3)
- /dev-docs
- /dev-docs-update
- /route-research-for-testing

### Hooks (8 total - 5 hook events)
- UserPromptSubmit (skill-activation-prompt)
- PostToolUse (post-tool-use-tracker)
- PreCompact (pre-compact-save-context) - NEW
- SessionStart (session-start-setup) - NEW
- PreToolUse (pre-tool-use-validator) - NEW

---

## 🌟 What Makes This Different?

### 1. Actually Works in Production
Not theoretical examples - extracted from 6 months of real enterprise use.

### 2. Official Plugin Specification
Follows Claude Code's official plugin structure for maximum compatibility.

### 3. Mix and Match
Install only the plugins you need. No bloat.

### 4. Auto-Activation That Actually Works
The hook system that finally solves "skills don't activate automatically."

### 5. Modular Everything
Skills, hooks, agents - all designed to stay under context limits.

### 6. Progressive Disclosure
Load only what you need, when you need it.

---

## 🔧 Recommended Combinations

**Minimal:**
```
skill-activation-core
```

**Backend Developer:**
```
skill-activation-core + backend-development + testing-utilities + code-quality-suite
```

**Frontend Developer:**
```
skill-activation-core + frontend-development + code-quality-suite
```

**Full-Stack:**
```
All 6 plugins
```

**Plugin Creator:**
```
skill-activation-core + skill-developer-toolkit + code-quality-suite
```

---

## ⚠️ Important Notes

### Environment Variables Changed
- **Old**: `$CLAUDE_PROJECT_DIR`
- **New**: `${CLAUDE_PLUGIN_ROOT}`

All hook scripts use the new standard.

### skill-rules.json Split
The monolithic `skill-rules.json` is now split across plugins. Each plugin manages its own activation rules.

### Blog Domain Examples
Skills use generic blog examples (Post/Comment/User) for teaching. Adapt patterns to your domain (e-commerce, SaaS, etc.).

---

## 🤝 Getting Help

- **Plugin Issues**: Check individual plugin READMEs
- **Installation**: See QUICK_START.md
- **Migration**: See MIGRATION_GUIDE.md
- **GitHub Issues**: Report problems or ask questions

---

## 💬 Community

This infrastructure was detailed in ["Claude Code is a Beast – Tips from 6 Months of Hardcore Use"](https://www.reddit.com/r/ClaudeAI/comments/1oivjvm/claude_code_is_a_beast_tips_from_6_months_of/) on Reddit. After hundreds of requests, this plugin collection was created.

**Ways to contribute:**
- ⭐ Star this repo
- 🐛 Report issues
- 💬 Share your own plugins
- 📝 Contribute domain-specific examples

---

## 📜 License

MIT License - Use freely in your projects, commercial or personal.

---

## 🔗 Quick Links

- 📖 [Plugin Catalog](PLUGIN_CATALOG.md) - Complete reference
- 🚀 [Quick Start](QUICK_START.md) - 5-minute setup
- 🔄 [Migration Guide](MIGRATION_GUIDE.md) - Upgrade from old structure
- 🤖 [Claude Integration](CLAUDE_INTEGRATION_GUIDE.md) - AI-assisted setup
- 💡 [Dev Docs Pattern](dev/README.md) - Context preservation

**Start here:** Install `skill-activation-core`, add one skill plugin, experience auto-activation magic.

---

**Version**: 1.0.0 (Plugin Architecture)
**Last Updated**: 2025-11-04
