#!/bin/bash
# SessionStart Hook - Environment setup and welcome message

HOOK_INPUT=$(cat)

workspace_root=$(echo "$HOOK_INPUT" | jq -r '.workspace_root // empty' 2>/dev/null)
cwd_from_input=$(echo "$HOOK_INPUT" | jq -r '.cwd // empty' 2>/dev/null)

if [[ "$workspace_root" == "null" ]]; then
  workspace_root=""
fi
if [[ "$cwd_from_input" == "null" ]]; then
  cwd_from_input=""
fi

PROJECT_ROOT="${workspace_root:-$cwd_from_input}"
if [[ -z "$PROJECT_ROOT" ]]; then
  PROJECT_ROOT=$(pwd)
fi
PROJECT_ROOT="${PROJECT_ROOT%/}"
PROJECT_NAME=$(basename "$PROJECT_ROOT")

echo ""
echo "🚀 Claude Code Session Started"
echo "================================"
echo ""

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
