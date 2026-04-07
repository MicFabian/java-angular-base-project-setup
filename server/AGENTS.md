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
   - `com.example.baseproject.api.controller.<feature>.resources`
   - `com.example.baseproject.api.domain.<feature>`
   - `com.example.baseproject.api.accessor.<feature>`
   - `com.example.baseproject.api.config.<feature>`
   - `com.example.baseproject.api.shared`
2. Keep clean architecture boundaries:
   - `controller` contains controllers.
   - `controller.<feature>.resources` contains request/response DTOs.
   - `domain` contains the core model, JPA entities, Spring Data repositories, and concrete use case/service classes.
   - `config` contains Spring configuration and persistence/bootstrap wiring.
   - `accessor` is reserved for third-party integrations.
3. Keep business orchestration in domain use cases/services, not controllers.
4. Keep application-database entities and Spring Data JPA repositories in `domain`, not in `config` or `accessor`.
5. Hibernate/JPA is allowed, but schema changes must go through Flyway migrations rather than Hibernate DDL generation.
6. Keep `spring.jpa.hibernate.ddl-auto` on validation only; do not enable schema creation or update.
7. Preserve or extend `CleanArchitectureRulesSpec` when adding patterns.
8. Prefer Flyway migrations over ad hoc schema SQL when the database model changes.
9. Keep Docker-backed database verification in dedicated integration tests instead of the default fast test task.
10. Keep `server/src/main/resources/application.yml` as the authoritative runtime config. Put test-only overrides in profile-specific files such as `application-test.yml` or `application-integration-test.yml`; do not shadow the main file with `src/test/resources/application.yml`.
11. For Boot 4 actuator configuration, use the access model (`management.endpoints.access.*`, `management.endpoint.<id>.access`) and avoid mixing legacy `management.endpoint.<id>.enabled` flags with access properties.
12. Prefer Java records for immutable request/response DTOs and simple value objects. Keep JPA entities, Spring configuration, and managed components as classes.
13. Use Spock/Groovy for backend tests. For committed response or contract snapshots, use Snappo and update snapshots through `./gradlew :server:updateSnapshots`.
14. Use Lombok for constructor and other boilerplate where records are not a fit.
15. If architecture direction changes, create or update an ADR in `ADR/` via `write-adr`.
16. Backend Java formatting is enforced with Spotless using Palantir Java Format. Use `pnpm run format:backend` or `./scripts/gradlew-local.sh :server:spotlessApply`.

## Validation

- `pnpm run format:backend:check`
- `pnpm run test:server:architecture`
- `./gradlew :server:test`
- `./gradlew :server:integrationTest`
- `./gradlew :server:build`
