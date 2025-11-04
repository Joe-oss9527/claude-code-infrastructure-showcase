# Frontend Development Plugin

**React/TypeScript/MUI v7 patterns with Sentry integration**

## Overview

Frontend development best practices for React/TypeScript with MUI v7, including error tracking with Sentry. Features guardrail enforcement for MUI v7 compatibility.

## Included Components

### Skills

- **frontend-dev-guidelines**: React/TypeScript best practices (BLOCKS incompatible code)
  - MUI v7 migration patterns (Grid with size={{}} prop)
  - Suspense and lazy loading
  - TanStack Router patterns
  - File organization
  - TypeScript best practices

- **error-tracking**: Sentry integration patterns
  - Error boundaries
  - Performance monitoring
  - User feedback

### Agents

- **frontend-error-fixer**: Debug and fix frontend build/runtime errors

### Auto-Activation & Blocking

**Enforcement**: BLOCK mode - requires skill usage before editing frontend files

Activates/blocks when:
- **Keywords**: component, React, MUI, Grid, styling
- **File patterns**: `**/*.tsx`, `**/*.ts` in frontend directories
- **Content patterns**: MUI imports, Grid components

## Installation

```bash
cp -r plugins/frontend-development ~/.claude/plugins/
cp -r plugins/skill-activation-core ~/.claude/plugins/  # For auto-activation
```

## Usage

### Skill will auto-activate when editing .tsx files

If blocked, use the skill first:
```
Use frontend-dev-guidelines skill
```

### Skip validation (if needed)

Add to file:
```typescript
// @skip-validation
```

Or set environment:
```bash
export SKIP_FRONTEND_GUIDELINES=1
```

## Key Patterns

### MUI v7 Grid (IMPORTANT)

```typescript
// ✅ CORRECT (v7)
<Grid container size={{ xs: 12, md: 6 }}>

// ❌ WRONG (v4/v5)
<Grid container xs={12} md={6}>
```

### Component Structure

```typescript
export default function MyComponent() {
  return (
    <Suspense fallback={<LoadingSpinner />}>
      <AsyncContent />
    </Suspense>
  );
}
```

## Dependencies

- React 18+
- MUI v7
- TypeScript 5+
- Sentry (optional)

## Related Plugins

- **skill-activation-core**: Required for blocking behavior
- **code-quality-suite**: Code review agents

## License

MIT License
