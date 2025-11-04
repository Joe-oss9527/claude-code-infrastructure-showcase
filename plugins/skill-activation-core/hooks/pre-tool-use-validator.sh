#!/bin/bash
# PreToolUse Hook - Validate tool usage before execution

# Read input JSON from stdin
INPUT=$(cat)

# Extract tool name and file path
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name')
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""')

# Sensitive file patterns
SENSITIVE_PATTERNS=(
  "\\.env$"
  "\\.env\\."
  "credentials\\.json$"
  "\\.git/config$"
  "\\.ssh/"
  "private.*key"
)

# Check if file matches sensitive patterns
for pattern in "${SENSITIVE_PATTERNS[@]}"; do
  if echo "$FILE_PATH" | grep -qE "$pattern"; then
    # Block the operation
    echo "{\"decision\": \"block\", \"reason\": \"Refusing to write to sensitive file: $FILE_PATH\"}"
    exit 2
  fi
done

# Approve the operation
echo '{"decision": "approve"}'
exit 0
