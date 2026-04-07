---
name: backend-clean-architecture
description: Use when creating or refactoring backend features in server and you need enforceable clean architecture boundaries across the repo's `controller`, `domain`, `accessor`, and `shared` roots.
---

# Backend Clean Architecture

Apply this skill for backend design and refactors in `server`.

1. Keep backend code under:
   - `com.example.baseproject.api.controller.<feature>`
   - `com.example.baseproject.api.domain.<feature>`
   - `com.example.baseproject.api.accessor.<feature>`
   - `com.example.baseproject.api.shared`
2. Use these roots consistently:
   - `domain`: entities, value objects, use cases, and domain-owned accessor interfaces
   - `controller`: REST controllers and transport DTOs
   - `accessor`: Spring wiring plus outbound implementations of domain-owned accessor interfaces
   - `shared`: cross-cutting support that is not feature-specific
3. Enforce dependency direction:
   - `domain` must not depend on Spring, HTTP, or `accessor`/`controller`.
   - `controller` may depend on `domain`, never on `accessor`.
   - `accessor` may depend on `domain`, never on `controller`.
4. Keep API DTOs and domain models separate. Map explicitly in `controller`.
5. Infrastructure communication must always go through domain-owned accessor interfaces:
   - define the abstraction in `domain/<feature>`
   - implement it in `accessor/<feature>`
   - call it from domain use cases/interactors, not from controllers
6. Avoid generic multi-purpose `*Service` classes. Prefer explicit `*UseCase` and `*Interactor` classes.
7. If a service class is unavoidable, it must have exactly one responsibility and one business capability focus.
8. ADR check: if the change introduces or alters architectural decisions, create or update an ADR in `ADR/` using `write-adr`.
9. Validate after structural changes with:

- `pnpm run test:server:architecture`
- `./gradlew :server:test`
- `./gradlew :server:build`
