---
name: backend-programming-standards
description: Use when implementing or reviewing backend code in server and you need consistent engineering standards for naming, validation, errors, logging, security, and testing.
---

# Backend Programming Standards

Apply these standards to all backend work in `server`.

1. Naming and structure:
   - Use explicit names (`*Controller`, `*UseCase`, `*Interactor`, `*Accessor`, `*Mapper`).
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
   - Keep database/client/config access in `accessor` classes.
   - Access infrastructure only through domain-owned accessor interfaces.
   - Keep business orchestration in the domain use-case/interactor layer.
   - Apply database changes through Flyway migrations, not ad hoc startup SQL.
6. Security defaults:
   - Explicitly validate access assumptions.
   - Sanitize and constrain external input before use.
7. Testing standards:
   - Use Spock/Groovy for backend tests.
   - Unit/slice tests for business rules and adapters.
   - Prefer deterministic tests; mock only external boundaries.
   - Use Snappo for committed response or contract snapshots instead of hand-rolled snapshot helpers.
   - Use dedicated Testcontainers-backed integration tests when behavior depends on the real database or other infrastructure.
8. ADR check:
   - If structure, architecture, or major technical direction changes, update/create an ADR in `ADR/` with `write-adr`.

Minimum verification for non-trivial backend changes:

- `pnpm run test:server:architecture`
- `./gradlew :server:test`
- `./gradlew :server:integrationTest` when database or infrastructure behavior changes
- `./gradlew :server:build`
