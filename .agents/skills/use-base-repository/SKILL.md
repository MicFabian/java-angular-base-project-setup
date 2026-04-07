---
name: use-base-repository
description: Use when starting a project from this starter, onboarding to this repository, or choosing the correct commands, structure, and validation flow for Angular + Spring Boot work here.
---

# Use Base Repository

Use this skill when the task is about how to work in this starter correctly rather than implementing one specific frontend or backend feature.

## Apply This Workflow

1. Read the nearest instructions first:
   - `AGENTS.md`
   - `client/AGENTS.md` for frontend work
   - `server/AGENTS.md` for backend work
2. If this starter is being turned into a new project, do not rename files manually.
   - Use `pnpm run personalize -- --project-name <name> --display-name "<Display Name>" --java-base-package <package>`
   - Treat `personalize` as mandatory before feature work. It renames the repo identity across package paths, snapshots, ADR filenames, Spring app naming, and local database defaults.
3. Before debugging environment issues, run:
   - `pnpm run doctor`
   - `pnpm run doctor:db` when Docker/Postgres is involved
4. Use the repository commands instead of ad hoc command sequences.
   - Frontend: `pnpm nx ...`
   - Backend: `./scripts/gradlew-local.sh ...` or `./gradlew ...`
   - Full repo: `pnpm run verify`

## Backend Structure

Keep backend code under these roots:

- `server/src/main/java/com/example/baseproject/api/controller/<feature>`
- `server/src/main/java/com/example/baseproject/api/controller/<feature>/resources`
- `server/src/main/java/com/example/baseproject/api/domain/<feature>`
- `server/src/main/java/com/example/baseproject/api/accessor/<feature>`
- `server/src/main/java/com/example/baseproject/api/config/<feature>`
- `server/src/main/java/com/example/baseproject/api/shared`

Use them like this:

- `controller/<feature>`: controllers
- `controller/<feature>/resources`: request and response DTOs
- `domain/<feature>`: model, JPA entities, Spring Data repositories, and concrete use case/service classes
- `config/<feature>`: Spring configuration and persistence/bootstrap wiring
- `accessor/<feature>`: third-party integrations only
- `shared`: cross-cutting support such as persistence bootstrapping

Guardrails:

- Keep request/response DTOs under `controller/<feature>/resources`.
- Do not let controllers call accessors directly.
- Keep application-database entities and Spring Data repositories in `domain/<feature>`.
- Keep third-party integrations under `accessor/<feature>`.
- Keep Spring configuration under `config/<feature>`.
- Hibernate may be used, but schema changes must go through Flyway migrations.

## Validation

Use the smallest correct validation set:

- Formatting: `pnpm run format:check`
- Backend architecture: `pnpm run test:server:architecture`
- Backend fast pass: `./scripts/gradlew-local.sh :server:test`
- Backend infrastructure pass: `./scripts/gradlew-local.sh :server:integrationTest`
- Frontend: `pnpm nx build client && pnpm nx test client`
- Full repo: `pnpm run verify`
- Full repo with E2E: `pnpm run verify:e2e`

## ADR Rule

If the change alters architecture, repository structure, or foundational workflow, update the ADR in `ADR/` with `write-adr`.

## Skill Routing

Prefer the existing specialized skills once the work is clear:

- `nx-workspace`, `nx-generate`, `nx-run-tasks`
- `angular-new-app`, `angular-developer`
- `spring-boot-api`
- `backend-clean-architecture`, `backend-solid-principles`, `backend-programming-standards`
- `fullstack-workflow`
- `write-adr`
- `playwright`
