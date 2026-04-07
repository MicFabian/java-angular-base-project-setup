---
name: backend-programming-standards
description: Use when implementing or reviewing backend code in server and you need consistent engineering standards for naming, validation, errors, logging, security, and testing.
---

# Backend Programming Standards

Apply these standards to all backend work in `server`.

1. Naming and structure:
   - Use explicit names (`*Controller`, `*UseCase`, `*Service`, `*Repository`, `*Resource`, `*Accessor`).
   - Keep methods small and intention-revealing.
   - Use `controller/<feature>/resources` for request/response DTOs.
   - Prefer Java records for immutable DTOs and simple value objects.
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
   - Keep JPA entities and Spring Data repositories in `domain/<feature>` when they represent application-database persistence.
   - Keep Spring configuration and persistence/bootstrap wiring in `config/<feature>`.
   - Reserve `accessor/<feature>` for third-party integrations.
   - Keep JPA entities as classes; records are for immutable value types, not entities.
   - Keep business orchestration in the domain use-case/service layer.
   - Apply database changes through Flyway migrations, not ad hoc startup SQL.
   - Keep Hibernate schema management on validation only, never on create/update.
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
