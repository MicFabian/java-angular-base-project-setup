---
name: backend-clean-architecture
description: Use when creating or refactoring backend features in server and you need enforceable clean architecture boundaries across the repo's `controller`, `domain`, `accessor`, `config`, and `shared` roots.
---

# Backend Clean Architecture

Apply this skill for backend design and refactors in `server`.

1. Keep backend code under:
   - `com.example.baseproject.api.controller.<feature>`
   - `com.example.baseproject.api.controller.<feature>.resources`
   - `com.example.baseproject.api.domain.<feature>`
   - `com.example.baseproject.api.accessor.<feature>`
   - `com.example.baseproject.api.config.<feature>`
   - `com.example.baseproject.api.shared`
2. Use these roots consistently:
   - `controller`: REST controllers
   - `controller.<feature>.resources`: request/response DTOs
   - `domain`: entities, value objects, Spring Data JPA repositories, and concrete use case/service classes
   - `config`: Spring configuration and persistence/bootstrap wiring
   - `accessor`: third-party integrations only
   - `shared`: cross-cutting support that is not feature-specific
3. Enforce dependency direction:
   - `domain` must not depend on `controller`, `accessor`, or `config`.
   - `controller` may depend on `domain`, never on `accessor` or `config`.
   - `accessor` may depend on `domain`, never on `controller`.
   - `config` may wire the other roots together.
4. Keep API DTOs and domain models separate. Put request/response DTOs under `controller.<feature>.resources`.
5. Domain use case/service classes may be concrete classes; do not add interface/interactor pairs unless there is a real need.
6. Keep Spring Data JPA repositories for the application's own database in `domain/<feature>`.
7. Reserve `accessor/<feature>` for third-party integrations.
8. Hibernate is allowed, but schema changes must go through Flyway rather than Hibernate DDL updates.
9. ADR check: if the change introduces or alters architectural decisions, create or update an ADR in `ADR/` using `write-adr`.
10. Validate after structural changes with:

- `pnpm run test:server:architecture`
- `./gradlew :server:test`
- `./gradlew :server:build`
