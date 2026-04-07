# Server Instructions

## Scope

Applies to all code under `server`.

## Baseline

- Spring Boot `4.0.4`
- Java toolchain `21`
- Gradle wrapper (`./gradlew`)
- Spock + Groovy for backend tests
- Flyway for schema migrations
- Testcontainers for infrastructure-backed integration tests

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
7. Preserve or extend `CleanArchitectureRulesSpec` when adding patterns.
8. Prefer Flyway migrations over ad hoc schema SQL when the database model changes.
9. Keep Docker-backed database verification in dedicated integration tests instead of the default fast test task.
10. Keep `server/src/main/resources/application.yml` as the authoritative runtime config. Put test-only overrides in profile-specific files such as `application-test.yml` or `application-integration-test.yml`; do not shadow the main file with `src/test/resources/application.yml`.
11. For Boot 4 actuator configuration, use the access model (`management.endpoints.access.*`, `management.endpoint.<id>.access`) and avoid mixing legacy `management.endpoint.<id>.enabled` flags with access properties.
12. Use Spock/Groovy for backend tests. For committed response or contract snapshots, use Snappo and update snapshots through `./gradlew :server:updateSnapshots`.
13. If architecture direction changes, create or update an ADR in `ADR/` via `write-adr`.
14. Backend Java formatting is enforced with Spotless using Palantir Java Format. Use `pnpm run format:backend` or `./scripts/gradlew-local.sh :server:spotlessApply`.

## Validation

- `pnpm run format:backend:check`
- `pnpm run test:server:architecture`
- `./gradlew :server:test`
- `./gradlew :server:integrationTest`
- `./gradlew :server:build`
