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
- `server/src/main/java/com/example/baseproject/api/domain/<feature>`
- `server/src/main/java/com/example/baseproject/api/accessor/<feature>`
- `server/src/main/java/com/example/baseproject/api/shared`

Use them like this:

- `controller/<feature>`: inbound HTTP controllers and transport DTOs
- `domain/<feature>`: model, use cases/interactors, and domain-owned accessor interfaces
- `accessor/<feature>`: Spring wiring and outbound implementations of domain-owned accessor interfaces
- `shared`: cross-cutting support such as persistence bootstrapping

Guardrails:

- Keep Spring and infrastructure details out of `domain/<feature>`.
- Do not let controllers call accessors directly.
- Avoid generic multi-purpose `*Service` classes.
- Keep use cases/interactors single-purpose.
- Keep infrastructure communication behind domain-owned accessor interfaces.

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
