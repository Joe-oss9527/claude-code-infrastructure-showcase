#!/bin/bash
set -e

# Post-tool-use hook that tracks edited files and their repos
# This runs after Edit, MultiEdit, or Write tools complete successfully


# Read tool information from stdin
tool_info=$(cat)

# Extract relevant data
tool_name=$(echo "$tool_info" | jq -r '.tool_name // empty')
file_path=$(echo "$tool_info" | jq -r '.tool_input.file_path // empty')
session_id=$(echo "$tool_info" | jq -r '.session_id // empty')
workspace_root=$(echo "$tool_info" | jq -r '.workspace_root // empty')
cwd_from_input=$(echo "$tool_info" | jq -r '.cwd // empty')

if [[ "$workspace_root" == "null" ]]; then
    workspace_root=""
fi
if [[ "$cwd_from_input" == "null" ]]; then
    cwd_from_input=""
fi
if [[ "$session_id" == "null" || -z "$session_id" ]]; then
    session_id="default"
fi

# Determine project root (workspace root preferred, then cwd, then current directory)
project_root="${workspace_root:-$cwd_from_input}"
if [[ -z "$project_root" ]]; then
    project_root=$(pwd)
fi
project_root="${project_root%/}"
PROJECT_ROOT="$project_root"

# Skip if not an edit tool or no file path
if [[ ! "$tool_name" =~ ^(Edit|MultiEdit|Write)$ ]] || [[ -z "$file_path" ]]; then
    exit 0  # Exit 0 for skip conditions
fi

# Resolve absolute file paths relative to project root
if [[ -n "$file_path" && "$file_path" != /* ]]; then
    file_path="${project_root}/${file_path}"
fi

# Skip markdown files
if [[ "$file_path" =~ \.(md|markdown)$ ]]; then
    exit 0  # Exit 0 for skip conditions
fi

# Create cache directory in user cache (follows Claude Code hook contract)
cache_dir="${HOME}/.claude/tsc-cache/${session_id}"
mkdir -p "$cache_dir"
edited_files_log="${cache_dir}/edited-files.log"

# Function to detect repo from file path
detect_repo() {
    local file="$1"
    local root="$PROJECT_ROOT"

    if [[ -z "$file" ]]; then
        echo ""
        return
    fi

    if [[ "$file" != /* ]]; then
        file="${root}/${file}"
    fi

    # Normalise project root (avoid trailing slash for pattern removal)
    local normalized_root="${root%/}"

    # Remove project root from path
    local relative_path="${file#$normalized_root/}"

    # Extract first directory component
    local repo=$(echo "$relative_path" | cut -d'/' -f1)

    # Common project directory patterns
    case "$repo" in
        # Frontend variations
        frontend|client|web|app|ui)
            echo "$repo"
            ;;
        # Backend variations
        backend|server|api|src|services)
            echo "$repo"
            ;;
        # Database
        database|prisma|migrations)
            echo "$repo"
            ;;
        # Package/monorepo structure
        packages)
            # For monorepos, get the package name
            local package=$(echo "$relative_path" | cut -d'/' -f2)
            if [[ -n "$package" ]]; then
                echo "packages/$package"
            else
                echo "$repo"
            fi
            ;;
        # Examples directory
        examples)
            local example=$(echo "$relative_path" | cut -d'/' -f2)
            if [[ -n "$example" ]]; then
                echo "examples/$example"
            else
                echo "$repo"
            fi
            ;;
        *)
            # General fallback: infer repo from first path segment
            if [[ -z "$relative_path" ]]; then
                echo "root"
            else
                local first_component=$(echo "$relative_path" | cut -d'/' -f1)
                if [[ "$relative_path" != */* ]]; then
                    echo "root"
                elif [[ -n "$first_component" ]]; then
                    echo "$first_component"
                else
                    echo "unknown"
                fi
            fi
            ;;
    esac
}

# Function to get build command for repo
get_build_command() {
    local repo="$1"
    local root="$PROJECT_ROOT"
    local repo_path="${root%/}/$repo"

    # Handle root repo
    if [[ "$repo" == "root" ]]; then
        repo_path="${root}"
    fi

    # Check if package.json exists and has a build script
    if [[ -f "$repo_path/package.json" ]]; then
        if grep -q '"build"' "$repo_path/package.json" 2>/dev/null; then
            # Detect package manager (prefer pnpm, then npm, then yarn)
            if [[ -f "$repo_path/pnpm-lock.yaml" ]]; then
                echo "cd \"$repo_path\" && pnpm build"
            elif [[ -f "$repo_path/package-lock.json" ]]; then
                echo "cd \"$repo_path\" && npm run build"
            elif [[ -f "$repo_path/yarn.lock" ]]; then
                echo "cd \"$repo_path\" && yarn build"
            else
                echo "cd \"$repo_path\" && npm run build"
            fi
            return
        fi
    fi

    # Special case for database with Prisma
    if [[ "$repo" == "database" ]] || [[ "$repo" =~ prisma ]]; then
        if [[ -f "$repo_path/schema.prisma" ]] || [[ -f "$repo_path/prisma/schema.prisma" ]]; then
            echo "cd \"$repo_path\" && npx prisma generate"
            return
        fi
    fi

    # No build command found
    echo ""
}

# Function to get TSC command for repo
get_tsc_command() {
    local repo="$1"
    local root="$PROJECT_ROOT"
    local repo_path="${root%/}/$repo"

    if [[ "$repo" == "root" ]]; then
        repo_path="${root}"
    fi

    # Check if tsconfig.json exists
    if [[ -f "$repo_path/tsconfig.json" ]]; then
        # Check for Vite/React-specific tsconfig
        if [[ -f "$repo_path/tsconfig.app.json" ]]; then
            echo "cd \"$repo_path\" && npx tsc --project tsconfig.app.json --noEmit"
        else
            echo "cd \"$repo_path\" && npx tsc --noEmit"
        fi
        return
    fi

    # No TypeScript config found
    echo ""
}

# Detect repo
repo=$(detect_repo "$file_path")

# Skip if unknown repo
if [[ "$repo" == "unknown" ]] || [[ -z "$repo" ]]; then
    exit 0  # Exit 0 for skip conditions
fi

# Ensure we have a real file path before logging
if [[ -z "$file_path" ]]; then
    exit 0
fi

# Log edited file (tab-delimited per hook contract)
printf "%s\t%s\t%s\n" "$(date +%s)" "$tool_name" "$file_path" >> "$edited_files_log"

# Update affected repos list
if ! grep -q "^$repo$" "$cache_dir/affected-repos.txt" 2>/dev/null; then
    echo "$repo" >> "$cache_dir/affected-repos.txt"
fi

# Store build commands
build_cmd=$(get_build_command "$repo")
tsc_cmd=$(get_tsc_command "$repo")

if [[ -n "$build_cmd" ]]; then
    echo "$repo:build:$build_cmd" >> "$cache_dir/commands.txt.tmp"
fi

if [[ -n "$tsc_cmd" ]]; then
    echo "$repo:tsc:$tsc_cmd" >> "$cache_dir/commands.txt.tmp"
fi

# Remove duplicates from commands
if [[ -f "$cache_dir/commands.txt.tmp" ]]; then
    sort -u "$cache_dir/commands.txt.tmp" > "$cache_dir/commands.txt"
    rm -f "$cache_dir/commands.txt.tmp"
fi

# Exit cleanly
exit 0
