#!/bin/bash
# SessionStart Hook - Environment setup and welcome message

echo ""
echo "🚀 Claude Code Session Started"
echo "================================"
echo ""

# Detect project info
PROJECT_ROOT="${CLAUDE_PLUGIN_ROOT}/../.."
PROJECT_NAME=$(basename "$PROJECT_ROOT")

echo "📁 Project: $PROJECT_NAME"
echo ""

# Check dependencies
echo "🔍 Checking dependencies..."
command -v npm >/dev/null 2>&1 && echo "  ✅ npm" || echo "  ❌ npm (not found)"
command -v tsx >/dev/null 2>&1 && echo "  ✅ tsx" || echo "  ❌ tsx (not found)"
command -v tsc >/dev/null 2>&1 && echo "  ✅ tsc" || echo "  ❌ tsc (not found)"
echo ""

# List active plugins (if detectable)
echo "🔌 Active Plugins:"
echo "  • skill-activation-core"
# (Would detect other plugins from settings)
echo ""

# List available skills/agents/commands
echo "🛠️  Available Components:"
echo "  • Skills: Check ~/.claude/skills/ and .claude/skills/"
echo "  • Agents: Check ~/.claude/agents/ and .claude/agents/"
echo "  • Commands: Use /help to see slash commands"
echo ""

echo "💡 Tip: Use skills to get context-aware guidance!"
echo "================================"
echo ""

exit 0
