---
name: backend-programming-standards
description: Use when implementing or reviewing backend code in server and you need consistent engineering standards for naming, validation, errors, logging, security, and testing.
---

# Backend Programming Standards

Apply these standards to all backend work in `server`.

1. Naming and structure:
   - Use explicit names (`*Controller`, `*UseCase`, `*Port`, `*Adapter`, `*Mapper`).
   - Keep methods small and intention-revealing.
   - Avoid generic `*Service` naming for orchestration classes; prefer use-case names.
2. Validation and input handling:
   - Validate request DTOs at boundaries.
   - Fail fast on invalid input; avoid partial side effects.
3. Error handling:
   - Map domain/application errors to stable API responses.
   - Avoid leaking stack traces or infrastructure details in HTTP responses.
4. Logging:
   - Structured, contextual logs for state transitions and failures.
   - Do not log secrets, tokens, credentials, or sensitive payloads.
5. Persistence and transactions:
   - Keep queries/adapters in infrastructure classes.
   - Access infrastructure only through ports from the application layer.
   - Keep transactional orchestration in the application/use-case layer.
6. Security defaults:
   - Explicitly validate access assumptions.
   - Sanitize and constrain external input before use.
7. Testing standards:
   - Unit/slice tests for business rules and adapters.
   - Prefer deterministic tests; mock only external boundaries.
8. ADR check:
   - If structure, architecture, or major technical direction changes, update/create an ADR in `ADR/` with `write-adr`.

Minimum verification for non-trivial backend changes:
- `pnpm run test:server:architecture`
- `./gradlew :server:test`
- `./gradlew :server:build`
