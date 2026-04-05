---
name: backend-clean-architecture
description: Use when creating or refactoring backend features in server and you need enforceable clean architecture boundaries (domain, application, infrastructure, presentation) and dependency direction.
---

# Backend Clean Architecture

Apply this skill for backend design and refactors in `server`.

1. Keep backend code package-by-feature under `com.example.baseproject.api.<feature>`.
2. Use these layers inside each feature when complexity requires them:
   - `domain`: entities, value objects, and domain rules
   - `application`: use cases, input/output ports, orchestration, transaction boundaries
   - `infrastructure`: JPA adapters, external clients, technical implementations
   - `presentation`: REST controllers and transport DTOs
3. Enforce dependency direction:
   - `domain` must not depend on Spring, persistence, HTTP, or infrastructure.
   - `application` may depend on `domain`, never on concrete infrastructure.
   - `infrastructure` may depend on `application` and `domain`.
   - `presentation` may depend on `application`, never directly on repositories.
4. Keep API DTOs and domain models separate. Map explicitly in `presentation` or dedicated mappers.
5. Infrastructure communication must always go through Ports/Adapters:
   - define ports (interfaces) in `application` (or `domain` if truly domain-owned)
   - implement those ports as adapters in `infrastructure`
   - call ports from use cases; do not call repositories/clients directly from `presentation` or domain logic
6. Avoid generic multi-purpose `*Service` classes. Prefer explicit `*UseCase` classes as application entry points.
7. If a service class is unavoidable, it must have exactly one responsibility and one business capability focus.
8. Keep transaction boundaries in use cases, not in controllers or adapters.
9. ADR check: if the change introduces or alters architectural decisions, create or update an ADR in `ADR/` using `write-adr`.
10. Validate after structural changes with:
   - `pnpm run test:server:architecture`
   - `./gradlew :server:test`
   - `./gradlew :server:build`
