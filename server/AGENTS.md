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

1. Keep backend code under:
   - `com.example.baseproject.api.controller.<feature>`
   - `com.example.baseproject.api.domain.<feature>`
   - `com.example.baseproject.api.accessor.<feature>`
   - `com.example.baseproject.api.shared`
2. Keep clean architecture boundaries:
   - `domain` contains the core model, use cases, and domain-owned accessor interfaces.
   - `controller` maps HTTP to and from domain use cases.
   - `accessor` contains Spring wiring and outbound implementations of domain-owned accessor interfaces.
3. Domain-owned accessor interfaces must mediate infrastructure communication.
4. Do not introduce generic multi-purpose `*Service` classes.
5. If a service class is unavoidable, it must have exactly one responsibility.
6. Keep business orchestration in domain use cases/interactors, not controllers/accessors.
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
