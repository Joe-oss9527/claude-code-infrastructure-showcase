# Testing Utilities Plugin

**API route testing patterns with JWT cookie auth**

## Overview

Tools and patterns for testing authenticated API routes with JWT cookie-based authentication.

## Included Components

### Skills

- **route-tester**: Patterns for testing authenticated routes
  - JWT cookie authentication
  - Mock authentication helpers
  - Route verification
  - Response validation

### Auto-Activation

Activates when:
- **Keywords**: test route, test API, API testing, authenticated route
- **File patterns**: `**/routes/**/*.ts`, `**/test-*.js`
- **Content patterns**: `router.get`, `router.post`, etc.

## Installation

```bash
cp -r plugins/testing-utilities ~/.claude/plugins/
```

## Usage

### Manual Activation

```
Use the route-tester skill to test /api/users endpoint
```

### Auto-Activation

Automatically suggests when working with routes or test files.

## Testing Pattern

```javascript
const response = await fetch('http://localhost:3000/api/users', {
  headers: {
    'Cookie': `auth_token=${jwtToken}`
  }
});
```

## Dependencies

- Node.js
- Your API framework (Express, Fastify, etc.)

## Related Plugins

- **backend-development**: Backend patterns (includes auth-route-tester agent)
- **skill-activation-core**: For auto-activation

## License

MIT License
