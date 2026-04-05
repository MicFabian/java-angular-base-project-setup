# Server Instructions

## Scope

Applies to all code under `server`.

## Baseline

- Spring Boot `4.0.4`
- Java toolchain `21`
- Gradle wrapper (`./gradlew`)
- Spock + Groovy for backend tests

## Architecture Rules

1. Keep package-by-feature under `com.example.baseproject.api.features.<feature>`.
2. Keep clean architecture boundaries:
   - `domain` does not depend on Spring or infrastructure.
   - `application` orchestrates use cases and depends on abstractions.
   - `infrastructure` contains adapters and framework-specific implementations.
   - `presentation` maps HTTP to/from use cases.
3. Infrastructure communication must go through Ports/Adapters.
4. Do not introduce generic multi-purpose `*Service` classes.
5. If a service class is unavoidable, it must have exactly one responsibility.
6. Keep transaction boundaries in use cases, not controllers/adapters.
7. Preserve or extend `CleanArchitectureRulesTest` when adding patterns.
8. If architecture direction changes, create or update an ADR in `ADR/` via `write-adr`.

## Validation

- `pnpm run test:server:architecture`
- `./gradlew :server:test`
- `./gradlew :server:build`
