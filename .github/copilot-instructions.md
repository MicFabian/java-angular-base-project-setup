# Copilot Instructions

## Repository Shape

- Frontend is in `client` (Angular + Nx).
- Backend is in `server` (Spring Boot + Gradle).
- ADRs are in `ADR`.
- Skills are in `.agents/skills`.

## Working Expectations

1. Prefer existing repository commands over ad hoc scripts.
2. Frontend work uses Node `22.15.x` with `pnpm nx ...`; backend work uses `./gradlew ...`.
3. Backend architecture rules are strict:
   - use package-by-feature
   - use Ports/Adapters for infrastructure communication
   - avoid generic multi-purpose `*Service` classes
4. If architecture direction changes, update/create an ADR in `ADR/`.
5. Keep API changes synchronized across frontend and backend in the same change.

## Minimum Validation

- Frontend: `pnpm nx build client && pnpm nx test client`
- Backend: `pnpm run test:server:architecture && ./gradlew :server:test`
- Repo quick pass: `pnpm run verify`
