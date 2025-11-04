# Skill Developer Toolkit Plugin

**Meta-skill for creating Claude Code skills, hooks, and plugins**

## Overview

Learn to create and manage Claude Code skills, hooks, and plugins following Anthropic best practices.

## Included Components

### Skills

- **skill-developer**: Comprehensive guide for skill development
  - Skill structure and YAML frontmatter
  - Trigger patterns (keywords, intent, file, content)
  - Hook mechanisms
  - skill-rules.json configuration
  - Progressive disclosure
  - Best practices

### Resources

- `SKILL.md`: Main skill guide
- `HOOK_MECHANISMS.md`: Hook system deep-dive
- `SKILL_RULES_REFERENCE.md`: Complete skill-rules.json reference
- `TRIGGER_TYPES.md`: Trigger pattern examples
- `TROUBLESHOOTING.md`: Common issues and solutions
- `ADVANCED.md`: Advanced techniques
- `PATTERNS_LIBRARY.md`: Reusable patterns

### Auto-Activation

Activates when:
- **Keywords**: skill system, create skill, hook system, skill-rules.json
- **Intent**: Questions about skills, creating skills, modifying skills

## Installation

```bash
cp -r plugins/skill-developer-toolkit ~/.claude/plugins/
```

## Usage

### Learn About Skills

```
How do I create a new Claude Code skill?
```

### Skill Development

```
Use skill-developer to create a skill for Python testing
```

### Understanding Triggers

The skill automatically activates when you ask about:
- Skill creation and management
- Hook systems
- Trigger configuration

## Key Concepts

### Skill Structure

```yaml
---
name: my-skill
description: Short description
trigger_keywords: [keyword1, keyword2]
---

# Skill Content

Detailed instructions for Claude...
```

### skill-rules.json

```json
{
  "version": "1.0",
  "skills": {
    "my-skill": {
      "type": "domain",
      "enforcement": "suggest",
      "promptTriggers": { ... },
      "fileTriggers": { ... }
    }
  }
}
```

## Dependencies

None - Pure documentation skill

## Related Plugins

- **skill-activation-core**: Reference implementation of hooks
- All other plugins: Real-world examples

## License

MIT License

## Learn More

Explore the `resources/` directory for comprehensive guides on every aspect of skill development.
