# ⚠️ Archived Legacy Structure

**This directory contains the deprecated `.claude/` directory structure from before the v1.0 plugin architecture migration (November 2025).**

## Status: Archived - Do Not Use

These files are **kept for historical reference only** and should not be used in active development.

## What Happened?

On **2025-11-04**, this repository migrated from the legacy `.claude/` monolithic structure to the official Claude Code plugin architecture. All components have been reorganized into independent, modular plugins.

## Migration Path

If you're looking to use this infrastructure, **DO NOT copy from this directory**. Instead:

### ✅ Use the New Plugin Architecture

```bash
# Navigate to the repository root
cd ..

# See the new plugin-based structure
ls plugins/

# Install plugins you need
cp -r plugins/* ~/.claude/plugins/
```

### 📚 Documentation

- **[QUICK_START.md](../QUICK_START.md)** - Get started with plugins in 5 minutes
- **[MIGRATION_GUIDE.md](../MIGRATION_GUIDE.md)** - Detailed migration instructions from old to new structure
- **[PLUGIN_CATALOG.md](../PLUGIN_CATALOG.md)** - Complete plugin reference
- **[README.md](../README.md)** - Main repository documentation

## What's in This Directory?

This archived directory contains:

- **skills/** - Old monolithic skills structure
- **agents/** - Old agents (now distributed across plugins)
- **commands/** - Old slash commands (now in code-quality-suite plugin)
- **hooks/** - Old hooks (now in skill-activation-core plugin)
- **settings.json** - Old configuration (obsolete with plugin architecture)

## Key Differences: Old vs New

### Old Structure (Deprecated)
```
project/
└── .claude/
    ├── skills/           # All skills in one place
    │   └── skill-rules.json  # Monolithic config
    ├── agents/           # All agents in one place
    ├── commands/         # All commands in one place
    ├── hooks/            # All hooks in one place
    └── settings.json     # Manual hook registration
```

### New Structure (Current)
```
~/.claude/plugins/        # Modular plugins
├── skill-activation-core/
│   └── hooks/            # Auto-registered
├── backend-development/
│   ├── skills/
│   ├── agents/
│   └── skill-rules.json  # Plugin-specific
├── frontend-development/
│   ├── skills/
│   └── agents/
└── ... (more plugins)
```

## Why the Change?

The plugin architecture provides:

- ✅ **Modularity** - Install only what you need
- ✅ **Official spec compliance** - Follows Claude Code plugin standards
- ✅ **Better organization** - Clear separation of concerns
- ✅ **Easier maintenance** - Update plugins independently
- ✅ **Proper versioning** - Each plugin has its own version
- ✅ **Auto-registration** - Hooks and components register automatically
- ✅ **Discoverability** - Keywords and metadata for search

## Environment Variables Changed

- **Old**: `$CLAUDE_PROJECT_DIR`
- **New**: `${CLAUDE_PLUGIN_ROOT}`

All hook scripts now use the new plugin-relative paths.

## When to Reference This Directory

Only reference this directory if you:

1. Need to understand the historical structure
2. Are maintaining a fork that hasn't migrated yet
3. Want to compare old vs new implementations

**For all other purposes, use the new plugin architecture in `../plugins/`**

## Support

If you have questions about migration:

- See [MIGRATION_GUIDE.md](../MIGRATION_GUIDE.md) for step-by-step instructions
- Check [QUICK_START.md](../QUICK_START.md) for fast setup
- Review [PLUGIN_CATALOG.md](../PLUGIN_CATALOG.md) for plugin details
- Open a GitHub issue for specific problems

---

**Archived Date**: 2025-11-04
**Last Active Version**: v0.x
**Current Version**: v1.0.0 (Plugin Architecture)
**Migration Status**: Complete ✅
