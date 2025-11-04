# Code Quality Suite Plugin

**Code review, refactoring, and documentation agents**

## Overview

Specialized agents for code review, refactoring, planning, and documentation tasks.

## Included Components

### Agents

**Code Review & Architecture**
- **code-architecture-reviewer**: Review code for best practices and architecture
- **plan-reviewer**: Review implementation plans before execution

**Refactoring**
- **refactor-planner**: Create comprehensive refactoring plans
- **code-refactor-master**: Execute complex refactoring tasks

**Documentation**
- **documentation-architect**: Create and update project documentation

**Research & Debugging**
- **web-research-specialist**: Research solutions and gather information
- **auto-error-resolver**: Automatically fix TypeScript compilation errors

### Commands

- **/dev-docs**: Create comprehensive development plans
- **/dev-docs-update**: Update dev documentation before context compaction
- **/route-research-for-testing**: Map edited routes and launch tests

## Installation

```bash
cp -r plugins/code-quality-suite ~/.claude/plugins/
```

## Usage

### Code Review

```
Use code-architecture-reviewer to review my UserController
```

### Refactoring

```
Use refactor-planner to plan refactoring the auth system
```

### Documentation

```
Use documentation-architect to document the API endpoints
```

### Research

```
Use web-research-specialist to find solutions for webpack errors
```

### Slash Commands

```
/dev-docs Create a plan to implement user notifications
/dev-docs-update
/route-research-for-testing
```

## Agent Descriptions

### code-architecture-reviewer
Reviews recently written code for adherence to best practices, architectural consistency, and system integration.

### refactor-planner
Analyzes code structure and creates comprehensive refactoring plans with risk assessment.

### code-refactor-master
Executes complex refactoring including file reorganization, import updates, and pattern migrations.

### documentation-architect
Creates comprehensive documentation by gathering context from memory, existing docs, and related files.

### plan-reviewer
Reviews development plans before implementation to identify potential issues and missing considerations.

### web-research-specialist
Searches web for solutions, particularly for debugging and gathering information from GitHub, Stack Overflow, forums.

### auto-error-resolver
Automatically fixes TypeScript compilation errors.

## Dependencies

None - Uses Claude Code's built-in agent system

## Related Plugins

Works well with all other plugins to improve code quality across your entire project.

## License

MIT License

## Pro Tips

1. Use **plan-reviewer** before starting complex features
2. Use **code-architecture-reviewer** after completing features
3. Use **refactor-planner** when code becomes hard to maintain
4. Use **documentation-architect** regularly to keep docs updated
5. Use **web-research-specialist** when stuck on errors
