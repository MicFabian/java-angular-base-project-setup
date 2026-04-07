---
name: fullstack-workflow
description: Use when a change touches both Angular and Spring Boot, or when a task needs coordinated validation across Nx and Gradle in this repository.
---

# Fullstack Workflow

1. Start by identifying whether the change touches `client`, `server`, or both.
2. If the HTTP contract changes, update the backend endpoint and the frontend consumer in one turn. Do not leave the repo in a half-migrated state.
3. Prefer `pnpm nx` commands for frontend validation and the Gradle wrapper for backend validation.
4. For coordinated checks, run the narrowest commands that prove correctness first:
   - `pnpm nx build client`
   - `pnpm nx test client`
   - `pnpm run test:server:architecture`
   - `./gradlew :server:test`
   - `./gradlew :server:updateSnapshots` when intentional backend snapshot changes need to be recorded
   - `./gradlew :server:integrationTest` when infrastructure behavior changes
5. ADR check: if architectural direction, platform boundaries, or core workflow assumptions change, create/update an ADR in `ADR/` using `write-adr`.
6. Before finishing broad changes, run `pnpm run verify` for the fast baseline and `pnpm run verify:ci` when the change touches infrastructure-backed backend behavior.
7. If a task requires repo guidance, read `AGENTS.md` before making structural changes.
