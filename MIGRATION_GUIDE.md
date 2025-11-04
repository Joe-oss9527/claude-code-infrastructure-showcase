# Migration Guide

**Migrating from `.claude/` structure to plugin-based architecture**

## Overview

This guide helps you migrate from the legacy `.claude/` directory structure to the new official plugin-based architecture.

## What Changed?

### Before (v0.x - Legacy)
```
project/
├── .claude/
│   ├── skills/
│   ├── agents/
│   ├── commands/
│   ├── hooks/
│   └── settings.json
```

### After (v1.0 - Plugin Architecture)
```
~/.claude/plugins/                    # Global plugins
├── skill-activation-core/
│   ├── .claude-plugin/
│   │   └── plugin.json
│   └── hooks/
├── backend-development/
│   ├── .claude-plugin/
│   │   └── plugin.json
│   ├── skills/
│   └── agents/
└── ... (more plugins)
```

## Key Changes

### 1. Environment Variables

**Old**: `$CLAUDE_PROJECT_DIR`
**New**: `${CLAUDE_PLUGIN_ROOT}`

All hook scripts now use `${CLAUDE_PLUGIN_ROOT}` to reference plugin-relative paths.

### 2. Plugin Structure

Each plugin now has:
- `.claude-plugin/plugin.json` - Plugin manifest
- Standardized directory structure
- Independent versioning

### 3. skill-rules.json Split

The monolithic `skill-rules.json` is now split across plugins:
- `backend-development/skill-rules.json` - Backend rules only
- `frontend-development/skill-rules.json` - Frontend + error tracking rules
- `testing-utilities/skill-rules.json` - Testing rules only
- `skill-developer-toolkit/skill-rules.json` - Skill dev rules only

### 4. New Hook Events

Three new hook events added:
- **PreCompact**: Auto-save context before compaction
- **SessionStart**: Welcome message and dependency checks
- **PreToolUse**: Validate tool usage (blocks sensitive files)

## Migration Steps

### Step 1: Backup Your Configuration

```bash
# Backup existing .claude directory
cp -r .claude .claude.backup
```

### Step 2: Install Desired Plugins

Choose plugins based on your needs (see [PLUGIN_CATALOG.md](PLUGIN_CATALOG.md)):

```bash
# Example: Full-stack developer
cd claude-code-infrastructure-showcase
cp -r plugins/* ~/.claude/plugins/
```

### Step 3: Install Dependencies

```bash
cd ~/.claude/plugins/skill-activation-core
npm install
```

### Step 4: Migrate Custom Configurations

#### If you customized skill-rules.json:

**Old location**: `.claude/skills/skill-rules.json`
**New locations**: Each plugin has its own `skill-rules.json`

Example migration:
```bash
# Your custom backend rules
# OLD: .claude/skills/skill-rules.json (backend section)
# NEW: ~/.claude/plugins/backend-development/skill-rules.json

# Edit the new file to add your custom pathPatterns, keywords, etc.
nano ~/.claude/plugins/backend-development/skill-rules.json
```

#### If you customized hooks:

**Old location**: `.claude/hooks/`
**New location**: `~/.claude/plugins/skill-activation-core/hooks/`

Review and merge your customizations into the new hook scripts.

#### If you created custom skills:

**Old location**: `.claude/skills/my-skill/`
**New approach**: Create a new plugin

```bash
mkdir -p ~/.claude/plugins/my-custom-plugin/.claude-plugin
mkdir -p ~/.claude/plugins/my-custom-plugin/skills

# Create plugin.json
cat > ~/.claude/plugins/my-custom-plugin/.claude-plugin/plugin.json <<EOF
{
  "name": "my-custom-plugin",
  "version": "1.0.0",
  "description": "My custom skills",
  "author": "Your Name",
  "license": "MIT",
  "skills": ["./skills"]
}
EOF

# Copy your custom skill
cp -r .claude/skills/my-skill ~/.claude/plugins/my-custom-plugin/skills/
```

### Step 5: Update Environment Variables

If you have scripts or configurations using `$CLAUDE_PROJECT_DIR`:

```bash
# Find all occurrences
grep -r "CLAUDE_PROJECT_DIR" ~/.claude/

# Replace with CLAUDE_PLUGIN_ROOT
# (Or update your scripts to use the new variable)
```

### Step 6: Test Installation

```bash
# Start Claude Code with debug
claude --debug

# Check for plugin loading messages:
# Loading plugin: skill-activation-core
# Loading plugin: backend-development
# etc.
```

### Step 7: Verify Functionality

Test each component:

```bash
# Start a session
claude

# Test skill activation
"I need to create a backend route"
# Should suggest backend-dev-guidelines

# Test agents
"Use code-architecture-reviewer to review my code"

# Test slash commands
"/dev-docs Create a plan"
```

### Step 8: Clean Up (Optional)

Once verified, you can remove the old structure:

```bash
# Remove backup if everything works
rm -rf .claude.backup

# Optional: Remove old .claude directory if migrated to global plugins
# rm -rf .claude/
```

## Troubleshooting Migration Issues

### Skills Not Found

**Problem**: Claude says skill not found
**Solution**:
1. Verify plugin is in `~/.claude/plugins/` or `./.claude/plugins/`
2. Check `plugin.json` has correct `"skills": ["./skills"]` entry
3. Restart Claude Code session

### Hooks Not Triggering

**Problem**: Skill activation doesn't work automatically
**Solution**:
1. Ensure `skill-activation-core` is installed
2. Check executable permissions: `chmod +x ~/.claude/plugins/skill-activation-core/hooks/*.sh`
3. Verify hooks.json syntax: `jq . ~/.claude/plugins/skill-activation-core/hooks/hooks.json`

### TypeScript Hooks Failing

**Problem**: Hooks throw TypeScript errors
**Solution**:
```bash
cd ~/.claude/plugins/skill-activation-core
npm install
npx tsx --version  # Verify tsx is available
```

### Custom Triggers Not Working

**Problem**: Your custom keywords/patterns don't activate skills
**Solution**:
1. Check you updated the correct plugin's `skill-rules.json`
2. Verify JSON syntax: `jq . ~/.claude/plugins/your-plugin/skill-rules.json`
3. Restart Claude Code to reload configuration

### Environment Variable Errors

**Problem**: Hooks reference wrong paths
**Solution**:
- All plugin hooks should use `${CLAUDE_PLUGIN_ROOT}`, not `$CLAUDE_PROJECT_DIR`
- Check and update: `grep -r "CLAUDE_PROJECT_DIR" ~/.claude/plugins/`

## Backward Compatibility

### Can I use both structures?

Technically yes, but not recommended. Claude Code will load both `.claude/` and `~/.claude/plugins/`.

### Do I need to migrate immediately?

No, but the plugin architecture is the official specification and will receive future updates.

### Will old hooks still work?

Old hooks in `.claude/hooks/` should still work if properly configured in `settings.json`, but new hooks (PreCompact, SessionStart, PreToolUse) are only available in the plugin architecture.

## FAQs

### Q: Where should I install plugins - global or project-specific?

**Global** (`~/.claude/plugins/`): Use for plugins you want across all projects
**Project** (`./.claude/plugins/`): Use for project-specific customizations

### Q: Can I mix global and project plugins?

Yes! Claude Code merges both locations.

### Q: How do I update a plugin?

```bash
# Pull latest from repository
cd claude-code-infrastructure-showcase
git pull

# Copy updated plugin
cp -r plugins/backend-development ~/.claude/plugins/
```

### Q: Can I modify installed plugins?

Yes, plugins in `~/.claude/plugins/` are yours to customize. Just note your changes when updating.

### Q: Do plugins have dependencies on each other?

No hard dependencies. `skill-activation-core` is recommended with skill-based plugins but not required.

## Getting Help

- See [QUICK_START.md](QUICK_START.md) for fresh installation
- See [PLUGIN_CATALOG.md](PLUGIN_CATALOG.md) for plugin details
- Check plugin READMEs: `~/.claude/plugins/*/README.md`
- GitHub Issues: Report migration problems

---

**Last Updated**: 2025-11-04
**Guide Version**: 1.0
