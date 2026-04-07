# Copilot Instructions

## Repository Shape

- Frontend is in `client` (Angular + Nx).
- Backend is in `server` (Spring Boot + Gradle).
- ADRs are in `ADR`.
- Skills are in `.agents/skills`.

## Working Expectations

1. Prefer existing repository commands over ad hoc scripts.
2. Frontend work uses Node `22.15.x` with `pnpm nx ...`; backend work uses `./scripts/gradlew-local.sh ...` or `./gradlew ...`.
3. Backend architecture rules are strict:
   - use `controller`, `domain`, `accessor`, `config`, and `shared`
   - put request/response DTOs under `controller/<feature>/resources`
   - keep JPA entities, Spring Data repositories, and concrete use case/service classes in `domain`
   - reserve `accessor` for third-party integrations
   - keep Spring configuration in `config`
4. Use Hibernate/JPA with validation-only schema management and Flyway for backend schema changes.
5. Use Spock/Groovy for backend tests; for committed backend snapshots use Snappo and update them with `./gradlew :server:updateSnapshots`.
6. Use Lombok for constructor and value-object boilerplate when it reduces noise.
7. Use Prettier for frontend/docs files and Spotless with Palantir Java Format for backend Java sources.
8. If architecture direction changes, update/create an ADR in `ADR/`.
9. Keep API changes synchronized across frontend and backend in the same change.

## Minimum Validation

- Formatting: `pnpm run format:check`
- Frontend: `pnpm nx build client && pnpm nx test client`
- Backend: `pnpm run test:server:architecture && ./scripts/gradlew-local.sh :server:test`
- Backend integration: `./scripts/gradlew-local.sh :server:integrationTest`
- Repo quick pass: `pnpm run verify`
- CI-equivalent pass: `pnpm run verify:ci`
