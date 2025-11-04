# Backend Development Plugin

**Backend dev patterns for Node.js/Express/TypeScript/Prisma**

## Overview

Comprehensive backend development guidelines for building microservices with Node.js, Express, TypeScript, and Prisma. Includes skills, agents, and auto-activation rules.

## Included Components

### Skills

- **backend-dev-guidelines**: Complete guide for backend architecture
  - Layered architecture (routes → controllers → services → repositories)
  - BaseController pattern
  - Error handling with Sentry
  - Dependency injection
  - Configuration management
  - Prisma best practices

### Agents

- **auth-route-tester**: Test authenticated API routes with cookie-based auth
- **auth-route-debugger**: Debug authentication issues (401/403 errors)

### Auto-Activation

The plugin includes `skill-rules.json` that automatically activates the backend skill when:

- **Keywords**: backend, controller, service, route, API, Prisma, etc.
- **File patterns**: `**/src/**/*.ts` in backend directories
- **Content patterns**: `router.`, `app.get`, `export.*Controller`, etc.

## Installation

```bash
# Copy plugin to Claude Code plugins directory
cp -r plugins/backend-development ~/.claude/plugins/

# Install with skill-activation-core for auto-activation (recommended)
cp -r plugins/skill-activation-core ~/.claude/plugins/
```

## Usage

### Manual Skill Activation

```
Use the backend-dev-guidelines skill
```

### Auto-Activation

The skill automatically activates when you:
- Mention backend-related keywords in prompts
- Edit backend TypeScript files
- Work with routes, controllers, or services

### Testing Routes

```
Use the auth-route-tester agent to test /api/users
```

### Debugging Auth Issues

```
Use the auth-route-debugger agent to debug 401 errors
```

## Configuration

### Customize Triggers

Edit `skill-rules.json` to match your project structure:

```json
{
  "skills": {
    "backend-dev-guidelines": {
      "fileTriggers": {
        "pathPatterns": [
          "your-service/src/**/*.ts",
          "backend/**/*.ts"
        ]
      }
    }
  }
}
```

## Key Patterns

### Layered Architecture

```
Routes → Controllers → Services → Repositories → Database
```

### BaseController Pattern

```typescript
import { BaseController } from './base/BaseController';

export class UserController extends BaseController {
  async getUser(req: Request, res: Response) {
    return this.handleRequest(req, res, async () => {
      const user = await this.userService.findById(req.params.id);
      return user;
    });
  }
}
```

### Error Handling

All errors are automatically captured to Sentry in BaseController.

## Dependencies

- Node.js 18+
- TypeScript 5+
- Express
- Prisma (optional)
- Sentry SDK

## Related Plugins

- **skill-activation-core**: Required for auto-activation
- **testing-utilities**: Additional testing tools
- **code-quality-suite**: Code review and refactoring agents

## License

MIT License

## Learn More

See skill resources in `skills/backend-dev-guidelines/resources/` for detailed guides on:
- Architecture patterns
- Error handling
- Database access
- Testing strategies
- And more...
