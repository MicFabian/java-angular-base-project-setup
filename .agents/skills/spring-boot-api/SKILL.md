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
7. Validate backend work with `./gradlew :server:test` first and `./gradlew :server:build` before finishing substantial changes.
8. ADR check: when architectural boundaries, foundational patterns, or platform decisions change, create or update an ADR in `ADR/` via `write-adr`.
9. Preserve API discoverability. If controllers or DTOs change, keep `/api-docs` working and make the frontend change in the same turn when it depends on the contract.
