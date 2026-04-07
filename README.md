# Base Project

Nx workspace for the Angular frontend plus a standalone Gradle Spring Boot backend, prepared for Codex with repo-local skills and project-scoped MCP configuration.

## Version Baseline

- Angular: `21.2.6` runtime packages with `21.2.3` CLI/devkit
- Nx: `22.6.1`
- Node.js: `22.15.1`
- Spring Boot: `4.0.4`
- Gradle wrapper: `9.4.1`
- Java toolchain: `21`
- Spock: `2.4-groovy-5.0`
- springdoc-openapi: `3.0.2`
- Flyway: PostgreSQL migration baseline
- Testcontainers: PostgreSQL-backed backend integration tests

## Layout

- `client`: Angular application
- `client-e2e`: Playwright end-to-end tests
- `server`: Spring Boot application
- `ADR`: architecture decision records and template
- `.starter/project-metadata.env`: starter identity used by personalization and scaffolding scripts
- `docs/ai`: AI workspace governance docs (including skill structure guidance)
- `docs/starter`: starter onboarding and new-project workflow docs
- `docker/compose.yaml`: local PostgreSQL container for backend development
- `docker/init`: initialization scripts for local Postgres (tracked with `.gitkeep`)
- `libs`: reserved for shared libraries
- `.agents/skills`: repo-local Codex skills (including backend clean architecture, SOLID, and programming standards skills)
- `.codex/config.toml`: project-scoped MCP configuration for Codex
- `.github/copilot-instructions.md`: Copilot alignment with repo architecture and validation rules
- `llms.txt`: compact LLM-oriented repository map and guardrails
- `client/AGENTS.md` and `server/AGENTS.md`: scope-specific agent instruction layers

## Commands

- Personalize this starter for a new project: `pnpm run personalize -- --project-name your-project --display-name "Your Project" --java-base-package com.yourorg.yourproject`
- Check local prerequisites: `pnpm run doctor`
- Check local prerequisites including Docker: `pnpm run doctor:db`
- Bootstrap the workspace: `pnpm run setup`
- Bootstrap the workspace and start Postgres: `pnpm run setup:db`
- Bootstrap and run the full verification flow: `pnpm run setup:full`
- Format frontend/docs with Prettier: `pnpm run format:frontend`
- Format backend Java with Spotless + Palantir Java Format: `pnpm run format:backend`
- Format the whole repository: `pnpm run format`
- Check formatting: `pnpm run format:check`
- Select the pinned Node version: `nvm use` (reads `.nvmrc`) or use any compatible `22.x` runtime
- Enable the package manager shim if `pnpm` is missing: `corepack enable`
- Install or refresh frontend dependencies: `pnpm install`
- Show workspace projects: `pnpm nx show projects`
- Run the frontend locally: `pnpm nx serve client`
- Build the frontend: `pnpm nx build client`
- Run frontend unit tests: `pnpm nx test client`
- Run frontend E2E tests: `pnpm nx e2e client-e2e`
- Run the backend locally: `./gradlew :server:bootRun`
- Run the backend locally with repo-local Gradle state: `./scripts/gradlew-local.sh :server:bootRun`
- Run backend tests: `./gradlew :server:test`
- Update backend snapshots: `./gradlew :server:updateSnapshots` or `pnpm run test:server:snapshots:update`
- Run backend integration tests: `./gradlew :server:integrationTest`
- Run backend architecture rules: `pnpm run test:server:architecture`
- Build the backend: `./gradlew :server:build`
- Run full project verification: `pnpm run verify`
- Run full project verification including E2E: `pnpm run verify:e2e`
- Run the CI-equivalent verification pass: `pnpm run verify:ci`
- Scaffold a new backend feature: `pnpm run scaffold:backend-feature -- <feature-name>`
- Start local Postgres: `pnpm run infra:up`
- Stop local Postgres: `pnpm run infra:down`
- List project-scoped Codex skills: `pnpm run skills:list`
- Search skills with the official CLI: `pnpm run skills:find -- <query>`
- Add or refresh curated project skills: `pnpm run skills:add -- <source> [--skill <name> ... -a codex -y]`
- Restore project-scoped skills from `skills-lock.json`: `pnpm run skills:restore`
- Check globally tracked skill updates with the official CLI: `pnpm run skills:check`
- Update globally tracked skills with the official CLI: `pnpm run skills:update`
- Validate skill metadata and repository guardrails: `pnpm run skills:verify`

## Start A New Project

1. Personalize the copied repository:
   - `pnpm run personalize -- --project-name orders-platform --display-name "Orders Platform" --java-base-package com.acme.orders`
2. Bootstrap the machine and local infrastructure:
   - `pnpm run doctor:db`
   - `pnpm run setup:db`
3. Verify the starter before feature work:
   - `pnpm run verify`
4. Begin development:
   - `pnpm nx serve client`
   - `./gradlew :server:bootRun`

See [docs/starter/new-project.md](/Users/mivi/IdeaProjects/baseProject/docs/starter/new-project.md) for the detailed workflow and what the personalization script updates.

## Backend Base Structure

Backend code uses a simple hexagonal layout under:

- `server/src/main/java/com/example/baseproject/api/controller/<feature>`
- `server/src/main/java/com/example/baseproject/api/domain/<feature>`
- `server/src/main/java/com/example/baseproject/api/accessor/<feature>`
- `server/src/main/java/com/example/baseproject/api/shared`

Enforcement is provided by `CleanArchitectureRulesSpec` in:

- `server/src/test/groovy/com/example/baseproject/api/architecture`

Key enforced rules:

- domain must not depend on controller/accessor or Spring
- controller must not depend on accessor
- accessor must not depend on controller
- no backend class may end with `Service`

Practical meaning:

- `domain/<feature>` holds the model, use cases, and domain-owned accessor interfaces
- `controller/<feature>` holds inbound HTTP controllers and transport DTOs
- `accessor/<feature>` holds Spring wiring and outbound implementations of domain-owned accessor interfaces
- `shared` holds cross-cutting support such as persistence bootstrapping

## Database and Operations Baseline

- Flyway migrations live in `server/src/main/resources/db/migration`
- Spring Boot health probes are available at `/actuator/health/liveness` and `/actuator/health/readiness`
- Actuator metadata is exposed at `/actuator/info`
- OpenAPI docs stay available at `/v3/api-docs`
- Backend Java formatting is enforced by Spotless with Palantir Java Format
- Test-only overrides live in `server/src/test/resources/application-test.yml` and `application-integration-test.yml` so the main runtime config stays authoritative
- Boot 4 actuator configuration uses endpoint access properties instead of mixing legacy `enabled` flags with access settings
- Backend snapshots use Snappo and are stored under `server/src/test/resources/snapshots`

## Database (PostgreSQL)

`server/src/main/resources/application.yml` is wired to PostgreSQL via:

- `APP_DB_HOST` (default: `localhost`)
- `APP_DB_PORT` (default: `5432`)
- `APP_DB_NAME` (default: `base_project`)
- `APP_DB_USERNAME` (default: `base_project`)
- `APP_DB_PASSWORD` (default: `base_project`)

## Codex Setup

This repo is prepared for Codex in three layers:

- `AGENTS.md` defines repo-wide rules and command preferences.
- `client/AGENTS.md` and `server/AGENTS.md` provide closer-scope overrides for frontend/backend work.
- `.agents/skills` uses official Angular skills from `angular/skills` (`angular-new-app`, `angular-developer`) and official Nx skills from `nrwl/nx-ai-agents-config` (`nx-*`, `monitor-ci`, `link-workspace-packages`), installs the upstream Impeccable pack from `pbakaus/impeccable` (`frontend-design`, `polish`, `audit`, `teach-impeccable`, etc.), and keeps project-specific backend standards skills (`backend-clean-architecture`, `backend-solid-principles`, `backend-programming-standards`).
- One popular `clean` skill from [skills.sh](https://skills.sh/?q=clean) is installed: `clean-code` (`sickn33/antigravity-awesome-skills`).
- Re-audited on `2026-04-07`: no maintainer-owned Spring Boot, ADR, clean-architecture, or SOLID skill source was found in the current `skills` catalog, so those governance skills remain local to this repository.
- `.codex/config.toml` enables project-scoped MCP servers for `nx`, the Angular CLI MCP server, OpenAI Developer Docs, and Playwright MCP.
- `skills-lock.json` is the project lock file written by `npx skills add` for repo-scoped external skills.
- `write-adr` is a local skill for creating and maintaining consistent ADRs in `ADR/`.
- `docs/ai/skills-structure.md` defines the local skill folder quality bar.
- `docs/starter/new-project.md` documents the recommended project-start workflow for repositories created from this starter.
- `scripts/doctor.sh` is the local prerequisite check for fresh machines.
- `scripts/gradlew-local.sh` keeps backend tasks on the repository-local Gradle user home.
- `llms.txt` and `.github/copilot-instructions.md` align behavior for non-Codex assistants.
- `.github/workflows/verify.yml` runs the canonical verification commands in CI.

Current `skills` CLI note: `npx skills find`, `npx skills add`, `npx skills list`, and `npx skills experimental_install` work for this project-scoped setup. In the current upstream CLI release, `npx skills check` and `npx skills update` operate on the global lock rather than this repo's `skills-lock.json`.

If Codex does not pick up a new project-scoped MCP config immediately, restart Codex after trusting the project.

## Notes

- This starter intentionally pins Angular to `21.2.x` and Spring Boot to `4.0.4` per repository baseline decisions in `AGENTS.md` and ADRs.
- Node `22.15.1` is pinned because the Angular production build is stable there; the previously active Node `20.19.4` crashed in the native build process on this machine.
- Java is pinned to `21` for local reliability while remaining compatible with the chosen Spring Boot baseline. If you want to standardize on Java `25`, switch the toolchain in `server/build.gradle` and install/provision that JDK.
