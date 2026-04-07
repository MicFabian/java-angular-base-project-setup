---
name: spring-boot-api
description: Use when working in server or changing Spring Boot, Gradle, Java, Spock, or OpenAPI-related backend code in this repository.
---

# Spring Boot API

1. Treat `server` as a Spring Boot 4 application built with the root Gradle wrapper.
2. Keep production code under `server/src/main/java/com/example/baseproject/api` and organize packages by feature, not by technical layer.
3. Prefer constructor injection and explicit request/response types for HTTP endpoints.
4. Use Ports/Adapters for infrastructure communication: use cases depend on ports; infrastructure provides adapter implementations.
5. Avoid broad `*Service` classes. Prefer single-purpose `*UseCase` classes; if a service exists, keep one responsibility only.
6. Keep tests in `server/src/test/groovy`. Prefer Spock slice tests such as `@WebMvcTest`; use `@SpringBootTest` only for wiring or integration checks.
7. Prefer Flyway migrations for schema changes and keep them in `server/src/main/resources/db/migration`.
8. Put infrastructure-backed verification in `./gradlew :server:integrationTest` using Testcontainers rather than bloating the default fast test task.
9. Keep `server/src/main/resources/application.yml` as the source of truth for runtime settings. Put test overrides in profile-specific files such as `application-test.yml` and `application-integration-test.yml`; do not shadow the main file with another `src/test/resources/application.yml`.
10. For Boot 4 actuator configuration, prefer the access model (`management.endpoints.access.*`, `management.endpoint.<id>.access`) and do not mix it with legacy `management.endpoint.<id>.enabled` flags for the same endpoint.
11. Use Spock/Groovy for backend tests. For committed response or contract snapshots, use Snappo and update snapshots through `./gradlew :server:updateSnapshots`.
12. Validate backend work with `./gradlew :server:test` first, then `./gradlew :server:integrationTest` when infrastructure behavior changes, and `./gradlew :server:build` before finishing substantial changes.
13. ADR check: when architectural boundaries, foundational patterns, or platform decisions change, create or update an ADR in `ADR/` via `write-adr`.
14. Preserve API discoverability. If controllers or DTOs change, keep `/v3/api-docs` working and make the frontend change in the same turn when it depends on the contract.
