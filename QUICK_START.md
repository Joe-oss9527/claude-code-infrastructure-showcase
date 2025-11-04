# Quick Start Guide

**Get started with Claude Code plugins in 5 minutes**

## Prerequisites

- Claude Code installed
- Node.js 18+ (for TypeScript hooks)
- npm (for dependencies)

## Step 1: Choose Your Plugins

Pick a combination based on your role:

**Backend Developer?**
```
skill-activation-core + backend-development + testing-utilities + code-quality-suite
```

**Frontend Developer?**
```
skill-activation-core + frontend-development + code-quality-suite
```

**Full-Stack Developer?**
```
All 6 plugins
```

**Plugin Developer?**
```
skill-activation-core + skill-developer-toolkit + code-quality-suite
```

## Step 2: Install Plugins

### Quick Install (Recommended Combo)

```bash
# Navigate to repository
cd claude-code-infrastructure-showcase

# Backend developers
cp -r plugins/{skill-activation-core,backend-development,testing-utilities,code-quality-suite} ~/.claude/plugins/

# Frontend developers
cp -r plugins/{skill-activation-core,frontend-development,code-quality-suite} ~/.claude/plugins/

# Full-stack developers
cp -r plugins/* ~/.claude/plugins/

# Plugin developers
cp -r plugins/{skill-activation-core,skill-developer-toolkit,code-quality-suite} ~/.claude/plugins/
```

### Install Dependencies (for skill-activation-core)

```bash
cd ~/.claude/plugins/skill-activation-core
npm install
```

## Step 3: Verify Installation

```bash
# Check Claude Code recognizes plugins
claude --debug

# Look for lines like:
# Loading plugin: skill-activation-core
# Loading plugin: backend-development
# etc.
```

## Step 4: Test It Out

Start a Claude Code session:

```bash
cd your-project
claude
```

### Test Skill Activation

Try these prompts based on installed plugins:

**Backend:**
```
I need to create a new API endpoint for user authentication
```
→ Should automatically suggest `backend-dev-guidelines` skill

**Frontend:**
```
I want to create a new React component with MUI Grid
```
→ Should automatically suggest `frontend-dev-guidelines` skill (or block if editing .tsx)

**Skill Development:**
```
How do I create a new Claude Code skill?
```
→ Should automatically suggest `skill-developer` skill

### Test Agents

```
Use the code-architecture-reviewer agent to review my code
```

### Test Slash Commands

```
/dev-docs Create a plan to implement notifications
```

## Step 5: Customize (Optional)

### Adjust skill-rules.json for Your Project

If using auto-activation, customize trigger patterns:

```bash
# Backend plugin
nano ~/.claude/plugins/backend-development/skill-rules.json
```

Change `pathPatterns` to match your project structure:
```json
{
  "pathPatterns": [
    "your-backend/src/**/*.ts",
    "api/**/*.ts"
  ]
}
```

## Troubleshooting

### Plugins Not Loading

1. Check Claude Code version: `claude --version` (need v1.0+)
2. Verify plugin.json exists in each `.claude-plugin/` directory
3. Check permissions: `ls -la ~/.claude/plugins/*/`

### Skills Not Auto-Activating

1. Ensure `skill-activation-core` is installed
2. Check hooks have executable permissions:
   ```bash
   chmod +x ~/.claude/plugins/skill-activation-core/hooks/*.sh
   ```
3. Verify hooks.json syntax:
   ```bash
   jq . ~/.claude/plugins/skill-activation-core/hooks/hooks.json
   ```

### TypeScript Hooks Failing

1. Install dependencies:
   ```bash
   cd ~/.claude/plugins/skill-activation-core
   npm install
   ```
2. Verify tsx is available: `npx tsx --version`

### Frontend Skill Blocking Edits

This is intentional! Frontend skill uses BLOCK enforcement for MUI v7 compatibility.

To proceed:
1. Use the skill first: `Use frontend-dev-guidelines skill`
2. Or add `// @skip-validation` to file
3. Or set `export SKIP_FRONTEND_GUIDELINES=1`

## Next Steps

- **Read plugin READMEs**: Each plugin has detailed documentation
- **Explore skill resources**: Check `skills/*/resources/` for guides
- **Create your own skills**: Use `skill-developer-toolkit`
- **See [PLUGIN_CATALOG.md](PLUGIN_CATALOG.md)** for complete plugin reference
- **See [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)** if upgrading from old structure

## Quick Reference

### File Locations

```
~/.claude/plugins/                    # Global plugins
./.claude/plugins/                    # Project-specific plugins
~/.claude/settings.json               # Claude Code settings
```

### Useful Commands

```bash
# Debug mode
claude --debug

# List slash commands
/help

# Use a skill manually
Use <skill-name> skill

# Use an agent
Use <agent-name> agent
```

## Getting Help

- Plugin README files: `plugins/*/README.md`
- Skill resources: `plugins/*/skills/*/resources/`
- GitHub Issues: Report problems or ask questions

---

**Last Updated**: 2025-11-04
**Guide Version**: 1.0

Happy coding with Claude! 🚀
