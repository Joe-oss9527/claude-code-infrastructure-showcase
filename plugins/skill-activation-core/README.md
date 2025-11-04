# Skill Activation Core Plugin

**Core engine for auto-activating Claude Code skills based on context**

## Overview

The Skill Activation Core plugin is the foundation of context-aware skill activation in Claude Code. It provides hooks that automatically detect when skills should be activated based on user prompts, file edits, and session events.

## Features

- **UserPromptSubmit Hook**: Analyzes user prompts and activates relevant skills
- **PostToolUse Hook**: Tracks file edits and suggests skills based on content
- **PreCompact Hook**: Saves context before compaction (NEW)
- **SessionStart Hook**: Sets up environment and displays welcome message (NEW)
- **PreToolUse Hook**: Validates tool usage before execution (NEW)

## Installation

1. Copy this plugin directory to your Claude Code plugins location:
   ```bash
   cp -r plugins/skill-activation-core ~/.claude/plugins/
   ```

2. Claude Code will automatically detect and load the plugin on next session.

3. Verify installation:
   ```bash
   claude --debug
   # Look for "skill-activation-core" in loaded plugins
   ```

## Configuration

### hooks.json

The plugin uses `hooks/hooks.json` to configure all hook events. All paths use `${CLAUDE_PLUGIN_ROOT}` for portability.

### skill-rules.json

To use this plugin with skills, create a `skill-rules.json` file in your project's `.claude/skills/` directory. See `templates/skill-rules-template.json` for an example structure.

## Hook Scripts

### Core Hooks

- **skill-activation-prompt.sh/ts**: Analyzes user prompts and triggers skill activation
- **post-tool-use-tracker.sh**: Tracks file edits and suggests relevant skills

### New Hooks (v1.0)

- **pre-compact-save-context.sh**: Auto-saves dev documentation before context compaction
- **session-start-setup.sh**: Displays welcome message and checks dependencies
- **pre-tool-use-validator.sh**: Validates file operations (blocks sensitive files)

## Dependencies

- Node.js and npm (for TypeScript hooks)
- tsx (TypeScript execution)
- jq (JSON parsing in bash scripts)

Install TypeScript dependencies:
```bash
cd ~/.claude/plugins/skill-activation-core
npm install
```

## Usage

Once installed, the plugin works automatically:

1. **Skill Activation**: When you mention keywords like "backend", "component", "route", etc., relevant skills are automatically suggested
2. **File Tracking**: When you edit files, skills matching file patterns are activated
3. **Context Preservation**: Before context compaction, active dev docs are saved
4. **Session Setup**: Each session starts with a welcome message and dependency check

## Customization

### Adding Custom Validation

Edit `hooks/pre-tool-use-validator.sh` to add custom file validation rules:

```bash
SENSITIVE_PATTERNS=(
  "\\.env$"
  "credentials\\.json$"
  # Add your patterns here
)
```

### Modifying Session Start

Edit `hooks/session-start-setup.sh` to customize the welcome message or add project-specific checks.

## Compatibility

- Claude Code v1.0+
- Uses official plugin specification
- Environment variable: `CLAUDE_PLUGIN_ROOT`

## Troubleshooting

### Hooks not triggering

1. Check plugin is loaded: `claude --debug`
2. Verify hooks have executable permissions: `chmod +x hooks/*.sh`
3. Check hook script syntax: `bash -n hooks/script-name.sh`

### TypeScript hooks failing

1. Install dependencies: `npm install`
2. Verify tsx is installed: `tsx --version`
3. Check TypeScript compilation: `npx tsc --noEmit`

## Related Plugins

This core plugin works best when combined with skill plugins:

- **backend-development**: Backend dev patterns with auto-activation
- **frontend-development**: Frontend dev patterns with auto-activation
- **skill-developer-toolkit**: Tools for creating your own skills

## License

MIT License - See repository root for details

## Contributing

This plugin is part of the Claude Code Infrastructure Showcase. Contributions welcome!
