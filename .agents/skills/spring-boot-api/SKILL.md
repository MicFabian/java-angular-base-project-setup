---
name: spring-boot-api
description: Use when working in server or changing Spring Boot, Gradle, Java, Spock, or OpenAPI-related backend code in this repository.
---

# Spring Boot API

1. Treat `server` as a Spring Boot 4 application built with the root Gradle wrapper.
2. Keep production code under `server/src/main/java/com/example/baseproject/api` and organize it with the repository roots `controller`, `domain`, `accessor`, `config`, and `shared`.
3. Put request/response DTOs under `controller/<feature>/resources`.
4. Keep JPA entities, Spring Data repositories, and concrete use case/service classes in `domain/<feature>`.
5. Reserve `accessor/<feature>` for third-party integrations and keep Spring configuration in `config/<feature>`.
6. Prefer Java records for immutable request/response DTOs and simple value objects.
7. Prefer Lombok for constructor and other boilerplate where records are not a fit.
8. Use Hibernate/JPA with validation-only schema management (`ddl-auto=validate`) and Flyway for schema changes.
9. Prefer constructor injection and explicit request/response types for HTTP endpoints.
10. Keep tests in `server/src/test/groovy`. Prefer Spock slice tests such as `@WebMvcTest`; use `@SpringBootTest` only for wiring or integration checks.
11. Prefer Flyway migrations for schema changes and keep them in `server/src/main/resources/db/migration`.
12. Put infrastructure-backed verification in `./gradlew :server:integrationTest` using Testcontainers rather than bloating the default fast test task.
13. Keep `server/src/main/resources/application.yml` as the source of truth for runtime settings. Put test overrides in profile-specific files such as `application-test.yml` and `application-integration-test.yml`; do not shadow the main file with another `src/test/resources/application.yml`.
14. For Boot 4 actuator configuration, prefer the access model (`management.endpoints.access.*`, `management.endpoint.<id>.access`) and do not mix it with legacy `management.endpoint.<id>.enabled` flags for the same endpoint.
15. Use Spock/Groovy for backend tests. For committed response or contract snapshots, use Snappo and update snapshots through `./gradlew :server:updateSnapshots`.
16. Validate backend work with `./gradlew :server:test` first, then `./gradlew :server:integrationTest` when infrastructure behavior changes, and `./gradlew :server:build` before finishing substantial changes.
17. ADR check: when architectural boundaries, foundational patterns, or platform decisions change, create or update an ADR in `ADR/` via `write-adr`.
18. Preserve API discoverability. If controllers or DTOs change, keep `/v3/api-docs` working and make the frontend change in the same turn when it depends on the contract.
