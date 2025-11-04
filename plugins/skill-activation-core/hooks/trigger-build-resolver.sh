#!/bin/bash

HOOK_INPUT=$(cat)

{
    echo "Hook triggered at $(date)"
    echo "Args: $@"
    echo "Stdin:"
    echo "$HOOK_INPUT"
    echo "=== DEBUG SECTION ==="
} >> /tmp/claude-hook-debug.log

workspace_root=$(echo "$HOOK_INPUT" | jq -r '.workspace_root // empty' 2>/dev/null)
cwd_from_input=$(echo "$HOOK_INPUT" | jq -r '.cwd // empty' 2>/dev/null)

if [[ "$workspace_root" == "null" ]]; then
    workspace_root=""
fi
if [[ "$cwd_from_input" == "null" ]]; then
    cwd_from_input=""
fi

project_root="${workspace_root:-$cwd_from_input}"
if [[ -z "$project_root" ]]; then
    project_root=$(pwd)
fi
project_root="${project_root%/}"

{
    echo "Workspace root: $project_root"
    echo "Current working directory: $(pwd)"
} >> /tmp/claude-hook-debug.log

# Define the service directories to check
services_dirs=("email" "exports" "form" "frontend" "projects" "uploads" "users" "utilities" "events" "database")
services_with_changes=()

# Check each service directory for git changes
for service in "${services_dirs[@]}"; do
    service_path="${project_root}/$service"
    echo "Checking service: $service at $service_path" >> /tmp/claude-hook-debug.log

    if [ -d "$service_path" ] && [ -d "$service_path/.git" ]; then
        echo "  -> Is a git repository" >> /tmp/claude-hook-debug.log

        git_status=$(cd "$service_path" && git status --porcelain 2>/dev/null)

        if [ -n "$git_status" ]; then
            echo "  -> Has changes:" >> /tmp/claude-hook-debug.log
            echo "$git_status" | sed 's/^/    /' >> /tmp/claude-hook-debug.log
            services_with_changes+=("$service")
        else
            echo "  -> No changes" >> /tmp/claude-hook-debug.log
        fi
    else
        echo "  -> Not a git repository or doesn't exist" >> /tmp/claude-hook-debug.log
    fi
done

echo "Services with changes: ${services_with_changes[*]}" >> /tmp/claude-hook-debug.log

if [[ ${#services_with_changes[@]} -gt 0 ]]; then
    services_list=$(IFS=', '; echo "${services_with_changes[*]}")
    echo "Changes detected in: $services_list — triggering build-error-resolver..." >> /tmp/claude-hook-debug.log
    echo "Changes detected in: $services_list — triggering build-error-resolver..." >&2

    echo "Attempting to run claude with sub-agent..." >> /tmp/claude-hook-debug.log

    if command -v claude >/dev/null 2>&1; then
        claude --agent build-error-resolver <<EOF 2>> /tmp/claude-hook-debug.log
Build and fix errors in these specific services only: ${services_list}

Focus on these services in the monorepo structure. Each service has its own build process.
EOF

        if [ $? -ne 0 ]; then
            echo "First attempt failed, trying alternative syntax..." >> /tmp/claude-hook-debug.log
            claude chat "Use the build-error-resolver agent to build and fix errors in: ${services_list}" 2>> /tmp/claude-hook-debug.log
        fi
    else
        echo "Claude CLI not found in PATH" >> /tmp/claude-hook-debug.log
    fi

    echo "Claude command completed with exit code: $?" >> /tmp/claude-hook-debug.log
else
    echo "No services with changes detected — skipping build-error-resolver." >> /tmp/claude-hook-debug.log
    echo "No services with changes detected — skipping build-error-resolver." >&2
fi

echo "=== END DEBUG SECTION ===" >> /tmp/claude-hook-debug.log
exit 0
