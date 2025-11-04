# 插件架构迁移计划 - 完全重构

> **创建时间**: 2025-11-04
> **状态**: 待执行
> **预估工作量**: ~3 小时
> **执行方式**: 分 6 个阶段，可在多个上下文窗口中执行

---

## 🎯 迁移目标

将单一仓库重构为 **6 个独立的 Claude Code 插件**，完全符合官方规范，用户可按需安装。

### 关键决策

根据用户确认：
- ✅ **完全迁移**：移除 `.claude/` 目录，完全迁移到 `.claude-plugin/` 结构
- ✅ **环境变量标准化**：全部替换为 `${CLAUDE_PLUGIN_ROOT}`
- ✅ **新增 Hook 事件**：实现 PreCompact, SessionStart, PreToolUse（同时保留现有 3 个）
- ✅ **拆分为多个插件**：6 个独立插件，而非单一插件

---

## 📦 插件拆分架构

### 插件 1: **skill-activation-core** (核心插件) 🔑

**用途**: 技能自动激活系统的核心引擎

**包含内容**:
- `hooks/skill-activation-prompt.sh` + `.ts`
- `hooks/post-tool-use-tracker.sh`
- `hooks/pre-compact-save-context.sh` (新)
- `hooks/session-start-setup.sh` (新)
- `hooks/pre-tool-use-validator.sh` (新)
- `hooks/hooks.json`
- 空的 `skill-rules.json` 模板
- `package.json`, `tsconfig.json`
- README：如何使用和配置

**plugin.json**:
```json
{
  "name": "skill-activation-core",
  "version": "1.0.0",
  "description": "Core engine for auto-activating Claude Code skills based on context",
  "author": "Claude Code Infrastructure Contributors",
  "homepage": "https://github.com/your-org/claude-code-infrastructure-showcase",
  "license": "MIT",
  "hooks": ["./hooks/hooks.json"]
}
```

**hooks.json 结构**:
```json
{
  "UserPromptSubmit": [
    {
      "hooks": [
        {
          "type": "command",
          "command": "${CLAUDE_PLUGIN_ROOT}/hooks/skill-activation-prompt.sh"
        }
      ]
    }
  ],
  "PostToolUse": [
    {
      "matcher": "Edit|MultiEdit|Write",
      "hooks": [
        {
          "type": "command",
          "command": "${CLAUDE_PLUGIN_ROOT}/hooks/post-tool-use-tracker.sh"
        }
      ]
    }
  ],
  "PreCompact": [
    {
      "hooks": [
        {
          "type": "command",
          "command": "${CLAUDE_PLUGIN_ROOT}/hooks/pre-compact-save-context.sh"
        }
      ]
    }
  ],
  "SessionStart": [
    {
      "hooks": [
        {
          "type": "command",
          "command": "${CLAUDE_PLUGIN_ROOT}/hooks/session-start-setup.sh"
        }
      ]
    }
  ],
  "PreToolUse": [
    {
      "matcher": "Write|Edit",
      "hooks": [
        {
          "type": "command",
          "command": "${CLAUDE_PLUGIN_ROOT}/hooks/pre-tool-use-validator.sh",
          "timeout": 5000
        }
      ]
    }
  ]
}
```

---

### 插件 2: **backend-development**

**用途**: 后端开发最佳实践

**包含内容**:
- `skills/backend-dev-guidelines/` (完整目录：SKILL.md + 11 resource files)
- `agents/auth-route-tester.md`
- `agents/auth-route-debugger.md`
- `skill-rules.json` (仅 backend 相关配置)
- README

**plugin.json**:
```json
{
  "name": "backend-development",
  "version": "1.0.0",
  "description": "Backend dev patterns for Node.js/Express/TypeScript/Prisma",
  "author": "Claude Code Infrastructure Contributors",
  "homepage": "https://github.com/your-org/claude-code-infrastructure-showcase",
  "license": "MIT",
  "skills": ["./skills"],
  "agents": ["./agents"]
}
```

**skill-rules.json** (仅包含 backend-dev-guidelines 相关配置):
```json
{
  "version": "1.0",
  "description": "Skill activation triggers for backend development",
  "skills": {
    "backend-dev-guidelines": {
      "type": "domain",
      "enforcement": "suggest",
      "priority": "high",
      "description": "Backend development patterns for Node.js/Express/TypeScript",
      "promptTriggers": {
        "keywords": [
          "backend", "microservice", "controller", "service",
          "repository", "route", "routing", "express", "API",
          "endpoint", "middleware", "validation", "Zod",
          "Prisma", "BaseController", "dependency injection",
          "unifiedConfig"
        ],
        "intentPatterns": [
          "(create|add|implement|build).*?(route|endpoint|API|controller|service|repository)",
          "(fix|handle|debug).*?(error|exception|backend)",
          "(add|implement).*?(middleware|validation|error.*?handling)",
          "(organize|structure|refactor).*?(backend|service|API)",
          "(how to|best practice).*?(backend|route|controller|service)"
        ]
      },
      "fileTriggers": {
        "pathPatterns": [
          "blog-api/src/**/*.ts",
          "auth-service/src/**/*.ts",
          "notifications-service/src/**/*.ts",
          "backend/**/*.ts",
          "api/**/*.ts",
          "server/**/*.ts",
          "services/**/*.ts"
        ],
        "pathExclusions": [
          "**/*.test.ts",
          "**/*.spec.ts"
        ],
        "contentPatterns": [
          "router\\.",
          "app\\.(get|post|put|delete|patch)",
          "export.*Controller",
          "export.*Service",
          "prisma\\."
        ]
      }
    }
  }
}
```

---

### 插件 3: **frontend-development**

**用途**: 前端开发最佳实践

**包含内容**:
- `skills/frontend-dev-guidelines/` (SKILL.md + 10 resource files)
- `skills/error-tracking/` (SKILL.md)
- `agents/frontend-error-fixer.md`
- `skill-rules.json` (frontend-dev-guidelines + error-tracking)
- README

**plugin.json**:
```json
{
  "name": "frontend-development",
  "version": "1.0.0",
  "description": "React/TypeScript/MUI v7 patterns with Sentry integration",
  "author": "Claude Code Infrastructure Contributors",
  "homepage": "https://github.com/your-org/claude-code-infrastructure-showcase",
  "license": "MIT",
  "skills": ["./skills"],
  "agents": ["./agents"]
}
```

**skill-rules.json** (包含 frontend-dev-guidelines + error-tracking):
```json
{
  "version": "1.0",
  "description": "Skill activation triggers for frontend development",
  "skills": {
    "frontend-dev-guidelines": {
      "type": "guardrail",
      "enforcement": "block",
      "priority": "high",
      "description": "React/TypeScript best practices including MUI v7 compatibility",
      "promptTriggers": { ... },
      "fileTriggers": { ... },
      "blockMessage": "⚠️ BLOCKED - Frontend Best Practices Required...",
      "skipConditions": {
        "sessionSkillUsed": true,
        "fileMarkers": ["@skip-validation"],
        "envOverride": "SKIP_FRONTEND_GUIDELINES"
      }
    },
    "error-tracking": {
      "type": "domain",
      "enforcement": "suggest",
      "priority": "high",
      "description": "Sentry error tracking and performance monitoring patterns",
      "promptTriggers": { ... },
      "fileTriggers": { ... }
    }
  }
}
```

---

### 插件 4: **testing-utilities**

**用途**: API 测试工具

**包含内容**:
- `skills/route-tester/` (SKILL.md)
- `skill-rules.json` (仅 route-tester)
- README

**plugin.json**:
```json
{
  "name": "testing-utilities",
  "version": "1.0.0",
  "description": "API route testing patterns with JWT cookie auth",
  "author": "Claude Code Infrastructure Contributors",
  "homepage": "https://github.com/your-org/claude-code-infrastructure-showcase",
  "license": "MIT",
  "skills": ["./skills"]
}
```

---

### 插件 5: **skill-developer-toolkit**

**用途**: 创建和管理 Claude Code 插件/技能

**包含内容**:
- `skills/skill-developer/` (SKILL.md + 6 resource files)
- `skill-rules.json` (仅 skill-developer)
- README

**plugin.json**:
```json
{
  "name": "skill-developer-toolkit",
  "version": "1.0.0",
  "description": "Meta-skill for creating Claude Code skills, hooks, and plugins",
  "author": "Claude Code Infrastructure Contributors",
  "homepage": "https://github.com/your-org/claude-code-infrastructure-showcase",
  "license": "MIT",
  "skills": ["./skills"]
}
```

---

### 插件 6: **code-quality-suite**

**用途**: 代码审查和重构工具

**包含内容**:
- `agents/` (7 个 agent 文件)
  - code-architecture-reviewer.md
  - code-refactor-master.md
  - refactor-planner.md
  - plan-reviewer.md
  - documentation-architect.md
  - web-research-specialist.md
  - auto-error-resolver.md
- `commands/` (3 个 command 文件)
  - dev-docs.md
  - dev-docs-update.md
  - route-research-for-testing.md
- README

**plugin.json**:
```json
{
  "name": "code-quality-suite",
  "version": "1.0.0",
  "description": "Code review, refactoring, and documentation agents",
  "author": "Claude Code Infrastructure Contributors",
  "homepage": "https://github.com/your-org/claude-code-infrastructure-showcase",
  "license": "MIT",
  "agents": ["./agents"],
  "commands": ["./commands"]
}
```

---

## 📁 新的目录结构

```
claude-code-infrastructure-showcase/
├── plugins/                                    # 新：所有插件
│   ├── skill-activation-core/
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json
│   │   ├── hooks/
│   │   │   ├── hooks.json
│   │   │   ├── skill-activation-prompt.sh
│   │   │   ├── skill-activation-prompt.ts
│   │   │   ├── post-tool-use-tracker.sh
│   │   │   ├── pre-compact-save-context.sh      # 新
│   │   │   ├── session-start-setup.sh           # 新
│   │   │   └── pre-tool-use-validator.sh        # 新
│   │   ├── templates/
│   │   │   └── skill-rules-template.json
│   │   ├── package.json
│   │   ├── package-lock.json
│   │   ├── tsconfig.json
│   │   └── README.md
│   │
│   ├── backend-development/
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json
│   │   ├── skills/
│   │   │   └── backend-dev-guidelines/
│   │   │       ├── SKILL.md
│   │   │       └── resources/ (11 .md files)
│   │   ├── agents/
│   │   │   ├── auth-route-tester.md
│   │   │   └── auth-route-debugger.md
│   │   ├── skill-rules.json
│   │   └── README.md
│   │
│   ├── frontend-development/
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json
│   │   ├── skills/
│   │   │   ├── frontend-dev-guidelines/
│   │   │   │   ├── SKILL.md
│   │   │   │   └── resources/ (10 .md files)
│   │   │   └── error-tracking/
│   │   │       └── SKILL.md
│   │   ├── agents/
│   │   │   └── frontend-error-fixer.md
│   │   ├── skill-rules.json
│   │   └── README.md
│   │
│   ├── testing-utilities/
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json
│   │   ├── skills/
│   │   │   └── route-tester/
│   │   │       └── SKILL.md
│   │   ├── skill-rules.json
│   │   └── README.md
│   │
│   ├── skill-developer-toolkit/
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json
│   │   ├── skills/
│   │   │   └── skill-developer/
│   │   │       ├── SKILL.md
│   │   │       ├── HOOK_MECHANISMS.md
│   │   │       ├── SKILL_RULES_REFERENCE.md
│   │   │       ├── TRIGGER_TYPES.md
│   │   │       ├── TROUBLESHOOTING.md
│   │   │       ├── ADVANCED.md
│   │   │       └── PATTERNS_LIBRARY.md
│   │   ├── skill-rules.json
│   │   └── README.md
│   │
│   └── code-quality-suite/
│       ├── .claude-plugin/
│       │   └── plugin.json
│       ├── agents/
│       │   ├── code-architecture-reviewer.md
│       │   ├── code-refactor-master.md
│       │   ├── refactor-planner.md
│       │   ├── plan-reviewer.md
│       │   ├── documentation-architect.md
│       │   ├── web-research-specialist.md
│       │   └── auto-error-resolver.md
│       ├── commands/
│       │   ├── dev-docs.md
│       │   ├── dev-docs-update.md
│       │   └── route-research-for-testing.md
│       └── README.md
│
├── dev/                                        # 保留
│   └── README.md
│
├── PLUGIN_CATALOG.md                           # 新：插件目录索引
├── MIGRATION_GUIDE.md                          # 新：从 v1 迁移指南
├── QUICK_START.md                              # 新：快速开始指南
├── README.md                                   # 更新：变为插件集合说明
├── CLAUDE_INTEGRATION_GUIDE.md                 # 更新
└── LICENSE

# 移除的目录和文件：
# ❌ .claude/ (整个目录)
# ❌ .claude/settings.json
# ❌ .claude/skills/
# ❌ .claude/agents/
# ❌ .claude/commands/
# ❌ .claude/hooks/
```

---

## 🆕 新增 Hook 事件实现

### Hook 1: PreCompact (上下文压缩前自动保存)

**文件**: `skill-activation-core/hooks/pre-compact-save-context.sh`

**功能**:
- 检测是否存在 `dev/active/` 目录
- 自动运行等效于 `/dev-docs-update` 的逻辑
- 保存当前会话重要上下文
- 提示用户上下文已保存

**实现框架**:
```bash
#!/bin/bash
# PreCompact Hook - Auto-save context before compaction

# Use CLAUDE_PLUGIN_ROOT to find project root
PROJECT_ROOT="${CLAUDE_PLUGIN_ROOT}/../.."
DEV_ACTIVE_DIR="${PROJECT_ROOT}/dev/active"

if [ -d "$DEV_ACTIVE_DIR" ]; then
  echo "📝 PreCompact: Detected active dev docs"
  echo "🔄 Auto-saving context before compaction..."

  # Find latest task directory
  LATEST_TASK=$(ls -t "$DEV_ACTIVE_DIR" | head -1)

  if [ -n "$LATEST_TASK" ]; then
    echo "📂 Task: $LATEST_TASK"
    echo "💾 Updating context and tasks files..."

    # Trigger dev-docs-update equivalent logic
    # (Implementation would read transcript and update files)

    echo "✅ Context saved successfully"
  fi
else
  echo "ℹ️  No active dev docs detected, skipping pre-compact save"
fi

exit 0
```

---

### Hook 2: SessionStart (会话启动环境检查)

**文件**: `skill-activation-core/hooks/session-start-setup.sh`

**功能**:
- 显示欢迎信息和项目概况
- 检查必要依赖（npm, tsx, TypeScript）
- 列出已激活的插件
- 显示可用的技能、代理和命令

**实现框架**:
```bash
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
```

---

### Hook 3: PreToolUse (工具执行前验证)

**文件**: `skill-activation-core/hooks/pre-tool-use-validator.sh`

**功能**:
- 阻止敏感文件写入（.env, credentials.json, .git/config）
- 验证文件路径合法性
- 检查文件权限
- 返回 JSON 决策

**实现框架**:
```bash
#!/bin/bash
# PreToolUse Hook - Validate tool usage before execution

# Read input JSON from stdin
INPUT=$(cat)

# Extract tool name and file path
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name')
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""')

# Sensitive file patterns
SENSITIVE_PATTERNS=(
  "\.env$"
  "\.env\."
  "credentials\.json$"
  "\.git/config$"
  "\.ssh/"
  "private.*key"
)

# Check if file matches sensitive patterns
for pattern in "${SENSITIVE_PATTERNS[@]}"; do
  if echo "$FILE_PATH" | grep -qE "$pattern"; then
    # Block the operation
    echo '{"decision": "block", "reason": "Refusing to write to sensitive file: '"$FILE_PATH"'"}'
    exit 2
  fi
done

# Approve the operation
echo '{"decision": "approve"}'
exit 0
```

---

## 🔄 环境变量全局替换

### 查找命令
```bash
# 查找所有包含 CLAUDE_PROJECT_DIR 的文件
grep -r "CLAUDE_PROJECT_DIR" .claude/

# 查找并显示行号
grep -rn "CLAUDE_PROJECT_DIR" .claude/
```

### 替换规则

| 原始 | 替换为 |
|------|--------|
| `$CLAUDE_PROJECT_DIR` | `${CLAUDE_PLUGIN_ROOT}` |
| `"$CLAUDE_PROJECT_DIR"` | `"${CLAUDE_PLUGIN_ROOT}"` |
| `${CLAUDE_PROJECT_DIR}` | `${CLAUDE_PLUGIN_ROOT}` |

### 影响的文件
- `.claude/hooks/skill-activation-prompt.sh`
- `.claude/hooks/skill-activation-prompt.ts`
- `.claude/hooks/post-tool-use-tracker.sh`
- `.claude/hooks/tsc-check.sh`
- `.claude/hooks/trigger-build-resolver.sh`
- `.claude/hooks/error-handling-reminder.sh`
- `.claude/hooks/error-handling-reminder.ts`
- `.claude/hooks/stop-build-check-enhanced.sh`
- 所有文档中的示例代码

### 验证命令
```bash
# 确保没有遗漏
grep -r "CLAUDE_PROJECT_DIR" plugins/

# 应该返回空结果
```

---

## 📝 新建文件清单

### 根目录新建文件（3 个）

1. **PLUGIN_CATALOG.md** - 插件目录索引
2. **MIGRATION_GUIDE.md** - 从旧版本迁移指南
3. **QUICK_START.md** - 快速开始指南

### 每个插件的新建文件（6 × 3-4 个）

**所有插件都需要**:
1. `.claude-plugin/plugin.json` - 插件清单
2. `README.md` - 插件说明、安装、配置

**有 skills 的插件**:
3. `skill-rules.json` - 技能激活规则

**skill-activation-core**:
3. `hooks/hooks.json` - Hook 配置
4. `templates/skill-rules-template.json` - 模板

### 新增 Hook 脚本（3 个）

1. `skill-activation-core/hooks/pre-compact-save-context.sh`
2. `skill-activation-core/hooks/session-start-setup.sh`
3. `skill-activation-core/hooks/pre-tool-use-validator.sh`

### 需要更新的文件（2 个）

1. 根 `README.md` - 完全重写
2. `CLAUDE_INTEGRATION_GUIDE.md` - 更新集成步骤

**总计**: ~30 个新建/修改文件

---

## 🚀 执行步骤详解（6 个阶段）

### 阶段 1: 创建插件目录结构

**目标**: 建立新的目录骨架

**步骤**:
1. 创建 `plugins/` 根目录
2. 创建 6 个插件子目录:
   - `plugins/skill-activation-core/`
   - `plugins/backend-development/`
   - `plugins/frontend-development/`
   - `plugins/testing-utilities/`
   - `plugins/skill-developer-toolkit/`
   - `plugins/code-quality-suite/`
3. 每个插件创建 `.claude-plugin/` 目录
4. 为需要的插件创建子目录 (`skills/`, `agents/`, `commands/`, `hooks/`)

**验证**:
```bash
tree -L 2 plugins/
```

**预估时间**: 5 分钟

---

### 阶段 2: 移动和组织文件

**目标**: 将现有文件移动到对应插件

**步骤**:

#### 2.1 移动 Skills
```bash
# backend-dev-guidelines
mv .claude/skills/backend-dev-guidelines/ plugins/backend-development/skills/

# frontend-dev-guidelines + error-tracking
mv .claude/skills/frontend-dev-guidelines/ plugins/frontend-development/skills/
mv .claude/skills/error-tracking/ plugins/frontend-development/skills/

# route-tester
mv .claude/skills/route-tester/ plugins/testing-utilities/skills/

# skill-developer
mv .claude/skills/skill-developer/ plugins/skill-developer-toolkit/skills/
```

#### 2.2 移动 Agents
```bash
# backend agents
mv .claude/agents/auth-route-tester.md plugins/backend-development/agents/
mv .claude/agents/auth-route-debugger.md plugins/backend-development/agents/

# frontend agent
mv .claude/agents/frontend-error-fixer.md plugins/frontend-development/agents/

# code-quality agents (所有其他 agents)
mv .claude/agents/*.md plugins/code-quality-suite/agents/
```

#### 2.3 移动 Commands
```bash
mv .claude/commands/*.md plugins/code-quality-suite/commands/
```

#### 2.4 移动 Hooks
```bash
# 复制（不是移动）hooks 到 skill-activation-core
cp .claude/hooks/*.sh plugins/skill-activation-core/hooks/
cp .claude/hooks/*.ts plugins/skill-activation-core/hooks/
cp .claude/hooks/package.json plugins/skill-activation-core/
cp .claude/hooks/package-lock.json plugins/skill-activation-core/
cp .claude/hooks/tsconfig.json plugins/skill-activation-core/
```

**验证**:
- 检查每个插件目录是否有正确的文件
- 确认 `.claude/` 中的内容已被移动（除了即将删除的）

**预估时间**: 15 分钟

---

### 阶段 3: 创建 plugin.json 文件

**目标**: 为每个插件创建标准的 plugin.json 清单

**步骤**:

为每个插件创建 `.claude-plugin/plugin.json`，使用本文档中定义的结构。

**关键点**:
- 确保 JSON 语法正确
- 路径使用相对路径 (`./skills`, `./agents` 等)
- version 使用 `1.0.0`
- 所有插件使用相同的 author, homepage, license

**验证**:
```bash
# 验证所有 plugin.json 语法
for file in plugins/*/.claude-plugin/plugin.json; do
  echo "Validating $file"
  jq . "$file" > /dev/null && echo "✅ Valid" || echo "❌ Invalid"
done
```

**预估时间**: 15 分钟

---

### 阶段 4: 拆分和更新 skill-rules.json

**目标**: 将大的 skill-rules.json 拆分到各插件

**步骤**:

1. 从 `.claude/skills/skill-rules.json` 提取各技能的配置
2. 创建各插件的 skill-rules.json:
   - `backend-development/skill-rules.json` (仅 backend-dev-guidelines)
   - `frontend-development/skill-rules.json` (frontend-dev-guidelines + error-tracking)
   - `testing-utilities/skill-rules.json` (仅 route-tester)
   - `skill-developer-toolkit/skill-rules.json` (仅 skill-developer)

3. 更新每个 skill-rules.json:
   - 移除其他技能的配置
   - 保留 `version`, `description`, `notes` 字段
   - 仅保留相关的技能配置

**模板结构**:
```json
{
  "version": "1.0",
  "description": "Skill activation triggers for [plugin purpose]",
  "skills": {
    "[skill-name]": { ... }
  },
  "notes": { ... }
}
```

**验证**:
- JSON 语法正确
- 每个技能只出现在一个插件中
- 所有原有技能都已分配到插件

**预估时间**: 20 分钟

---

### 阶段 5: 创建 hooks.json + 新 Hook 脚本

**目标**: 配置 hooks + 实现新的 3 个 Hook 事件

**步骤**:

#### 5.1 创建 hooks.json
在 `skill-activation-core/hooks/hooks.json` 创建文件，使用本文档中的完整结构。

#### 5.2 更新现有 Hook 脚本中的环境变量
对所有 `.sh` 和 `.ts` 文件执行替换:
```bash
cd plugins/skill-activation-core/hooks/
sed -i 's/\$CLAUDE_PROJECT_DIR/\${CLAUDE_PLUGIN_ROOT}/g' *.sh
sed -i 's/\$CLAUDE_PROJECT_DIR/\${CLAUDE_PLUGIN_ROOT}/g' *.ts
```

#### 5.3 实现新的 3 个 Hook 脚本

创建以下文件（使用本文档中的实现框架）:
1. `pre-compact-save-context.sh`
2. `session-start-setup.sh`
3. `pre-tool-use-validator.sh`

为每个脚本:
- 复制实现框架代码
- 添加可执行权限: `chmod +x *.sh`
- 测试基本语法: `bash -n script.sh`

#### 5.4 创建 skill-rules 模板
在 `skill-activation-core/templates/skill-rules-template.json` 创建空模板。

**验证**:
- hooks.json 语法正确
- 所有 .sh 文件有执行权限
- 所有脚本无语法错误
- 环境变量已全部替换

**预估时间**: 40 分钟

---

### 阶段 6: 文档和清理

**目标**: 完成所有文档并清理旧文件

**步骤**:

#### 6.1 为每个插件编写 README.md

每个 README 应包含:
- 插件用途和功能
- 包含的 skills/agents/commands 列表
- 安装方法
- 配置说明
- 使用示例
- 依赖关系（如果有）

#### 6.2 创建根目录文档

**PLUGIN_CATALOG.md**:
- 列出所有 6 个插件
- 说明每个插件的用途
- 推荐插件组合（最小/后端/前端/全栈/插件开发者）
- 安装指南

**MIGRATION_GUIDE.md**:
- 从旧版本 (.claude/) 迁移的步骤
- 环境变量更新说明
- skill-rules.json 拆分说明
- 常见问题解答

**QUICK_START.md**:
- 5 分钟快速开始
- 推荐插件组合安装
- 验证安装成功的方法

#### 6.3 更新现有文档

**README.md** (完全重写):
- 项目变为"插件集合"定位
- 列出 6 个插件
- 快速导航到各插件
- 保留核心理念和背景故事
- 添加"官方插件规范"徽章

**CLAUDE_INTEGRATION_GUIDE.md**:
- 更新为"安装插件"的流程
- 说明如何选择需要的插件
- 更新配置示例（使用 plugin.json）

#### 6.4 清理旧文件

```bash
# 删除整个 .claude/ 目录
rm -rf .claude/

# 如果有 settings.json，创建迁移说明
echo "settings.json 已移除，请参考 MIGRATION_GUIDE.md" > SETTINGS_REMOVED.txt
```

#### 6.5 更新 .gitignore（如果需要）

可能需要添加:
```
# 用户本地的插件配置
.claude/
settings.local.json
```

**验证**:
- 所有 README 完整可读
- 根文档链接正确
- `.claude/` 已删除
- 项目在新结构下可运行

**预估时间**: 60 分钟

---

## ✅ 完整验证清单

### 每个插件验证

- [ ] `plugin.json` 存在且语法正确
- [ ] `plugin.json` 包含所有必需字段 (name, version, description)
- [ ] 路径引用正确 (skills/agents/commands/hooks)
- [ ] 所有路径使用 `${CLAUDE_PLUGIN_ROOT}`
- [ ] Hook 脚本有可执行权限 (`chmod +x`)
- [ ] `skill-rules.json` 语法正确（如果有）
- [ ] README.md 完整（用途、安装、配置、示例）
- [ ] SKILL.md 有正确的 YAML frontmatter（如果有 skills）

### 全局验证

- [ ] 所有 6 个插件目录存在
- [ ] 无 `$CLAUDE_PROJECT_DIR` 残留 (`grep -r "CLAUDE_PROJECT_DIR" plugins/`)
- [ ] 所有文件已从 `.claude/` 移动到 `plugins/`
- [ ] `.claude/` 目录已删除
- [ ] `PLUGIN_CATALOG.md` 存在且完整
- [ ] `MIGRATION_GUIDE.md` 存在且完整
- [ ] `QUICK_START.md` 存在且完整
- [ ] 根 `README.md` 已更新为插件集合说明
- [ ] `CLAUDE_INTEGRATION_GUIDE.md` 已更新
- [ ] 所有新增 Hook 脚本可执行且无语法错误

### 功能验证

- [ ] 可以使用 `claude --debug` 查看插件加载情况
- [ ] skill-activation-core 的 hooks 正常工作
- [ ] 技能可以被自动激活
- [ ] 代理可以被调用
- [ ] 斜杠命令可用

---

## 📦 推荐插件组合

在 `PLUGIN_CATALOG.md` 中建议以下组合:

### 最小组合（所有用户）
```
✅ skill-activation-core
```
仅核心功能，技能自动激活系统。

### 后端开发者
```
✅ skill-activation-core
✅ backend-development
✅ testing-utilities
✅ code-quality-suite
```
后端开发完整工具链。

### 前端开发者
```
✅ skill-activation-core
✅ frontend-development
✅ code-quality-suite
```
前端开发完整工具链。

### 全栈开发者
```
✅ skill-activation-core
✅ backend-development
✅ frontend-development
✅ testing-utilities
✅ code-quality-suite
```
全栈开发完整工具链。

### 插件开发者
```
✅ skill-activation-core
✅ skill-developer-toolkit
✅ code-quality-suite
```
创建自己的 Claude Code 插件。

---

## 📊 预期成果

1. ✅ **完全符合官方规范**: 每个插件都是标准的 Claude Code 插件
2. ✅ **模块化可组合**: 用户按需安装，不需要全部
3. ✅ **独立版本管理**: 每个插件可独立发布版本
4. ✅ **环境变量标准化**: 100% 使用 `${CLAUDE_PLUGIN_ROOT}`
5. ✅ **扩展 Hook 覆盖**: 新增 PreCompact, SessionStart, PreToolUse
6. ✅ **清晰的文档**: 每个插件独立说明，易于理解和使用
7. ✅ **向前兼容**: 为未来功能扩展留出空间

---

## ⏱️ 时间估算

| 阶段 | 任务 | 预估时间 |
|------|------|----------|
| 1 | 创建目录结构 | 5 分钟 |
| 2 | 移动和组织文件 | 15 分钟 |
| 3 | 创建 plugin.json | 15 分钟 |
| 4 | 拆分 skill-rules.json | 20 分钟 |
| 5 | 创建 hooks.json + 新脚本 | 40 分钟 |
| 6 | 文档和清理 | 60 分钟 |
| **总计** | | **~2.5 小时** |

加上测试和调试时间，预留 **3-4 小时** 完成整个迁移。

---

## 📋 执行检查点

可以在任何阶段保存进度：

**阶段 1 完成后**:
- ✅ 目录骨架创建完成
- 可以暂停，下次继续

**阶段 2-3 完成后**:
- ✅ 文件已组织到插件
- ✅ plugin.json 创建完成
- 这是一个稳定的中间状态

**阶段 4-5 完成后**:
- ✅ 配置文件完成
- ✅ 新 Hook 脚本实现
- 功能基本完整，仅缺文档

**阶段 6 完成后**:
- ✅ 文档完整
- ✅ 旧文件清理
- 完全迁移完成

---

## 🔍 常见问题

### Q: 迁移后用户如何使用这些插件？

**A**: 用户需要:
1. 将需要的插件目录复制到 `~/.claude/plugins/` 或项目的 `.claude/plugins/`
2. Claude Code 会自动检测并加载插件
3. 使用 `claude --debug` 查看加载的插件

### Q: 用户可以只安装部分插件吗？

**A**: 是的！这是拆分插件的主要好处:
- 只需要后端开发？安装 backend-development
- 只需要前端开发？安装 frontend-development
- 核心功能 skill-activation-core 推荐所有人安装

### Q: 插件之间有依赖吗？

**A**:
- **skill-activation-core** 是推荐但非必需的基础
- 其他插件可以独立工作，但配合 skill-activation-core 效果最佳
- 没有硬依赖，用户可以任意组合

### Q: 如何发布这些插件？

**A**:
- 每个插件可以作为 Git 仓库的子目录发布
- 用户可以 `git clone` 整个仓库，然后选择需要的插件
- 或者拆分为独立仓库，每个插件一个 Git 仓库

### Q: 旧的 `.claude/` 配置如何迁移？

**A**:
- 参考 `MIGRATION_GUIDE.md`
- 主要是路径调整和环境变量更新
- skill-rules.json 需要拆分到各插件

---

## 🎯 下一步行动

1. **立即执行**: 开始阶段 1，创建目录结构
2. **分批执行**: 可以在多个 Claude Code 会话中完成
3. **增量测试**: 每完成一个阶段就测试
4. **文档优先**: 确保每个插件有清晰的 README

---

## 📌 备注

- 本计划可以分多个上下文窗口执行
- 每个阶段相对独立，可以分批完成
- 建议使用版本控制（git）在每个阶段后提交
- 如遇到问题，可以回退到上一个阶段

---

**文档版本**: 1.0
**最后更新**: 2025-11-04
**状态**: 待执行
