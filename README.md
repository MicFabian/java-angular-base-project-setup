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

## Layout

- `client`: Angular application
- `client-e2e`: Playwright end-to-end tests
- `server`: Spring Boot application
- `ADR`: architecture decision records and template
- `docs/ai`: AI workspace governance docs (including skill structure guidance)
- `docker/compose.yaml`: local PostgreSQL container for backend development
- `docker/init`: initialization scripts for local Postgres (tracked with `.gitkeep`)
- `libs`: reserved for shared libraries
- `.agents/skills`: repo-local Codex skills (including backend clean architecture, SOLID, and programming standards skills)
- `.codex/config.toml`: project-scoped MCP configuration for Codex
- `.github/copilot-instructions.md`: Copilot alignment with repo architecture and validation rules
- `llms.txt`: compact LLM-oriented repository map and guardrails
- `client/AGENTS.md` and `server/AGENTS.md`: scope-specific agent instruction layers

## Commands

- Select the pinned Node version: `nvm use` (reads `.nvmrc`) or use any compatible `22.x` runtime
- Enable the package manager shim if `pnpm` is missing: `corepack enable`
- Install or refresh frontend dependencies: `pnpm install`
- Show workspace projects: `pnpm nx show projects`
- Run the frontend locally: `pnpm nx serve client`
- Build the frontend: `pnpm nx build client`
- Run frontend unit tests: `pnpm nx test client`
- Run frontend E2E tests: `pnpm nx e2e client-e2e`
- Run the backend locally: `./gradlew :server:bootRun`
- Run backend tests: `./gradlew :server:test`
- Run backend architecture rules: `pnpm run test:server:architecture`
- Build the backend: `./gradlew :server:build`
- Run full project verification: `pnpm run verify`
- Run full project verification including E2E: `pnpm run verify:e2e`
- Scaffold a new backend feature: `pnpm run scaffold:backend-feature -- <feature-name>`
- Start local Postgres: `docker compose -f docker/compose.yaml up -d db`
- Stop local Postgres: `docker compose -f docker/compose.yaml down`
- List tracked external skill sources: `pnpm run skills:list`
- Update all tracked external skills: `pnpm run skills:update`
- Validate skill metadata and repository guardrails: `pnpm run skills:verify`
- Validate lock + skills integrity: `pnpm run skills:check`

## Backend Base Structure

Backend features follow package-by-feature clean architecture under:

- `server/src/main/java/com/example/baseproject/api/features/<feature>/domain`
- `server/src/main/java/com/example/baseproject/api/features/<feature>/application`
- `server/src/main/java/com/example/baseproject/api/features/<feature>/infrastructure`
- `server/src/main/java/com/example/baseproject/api/features/<feature>/presentation`

Enforcement is provided by `CleanArchitectureRulesTest` in:

- `server/src/test/java/com/example/baseproject/api/architecture`

Key enforced rules:

- domain must not depend on application/infrastructure/presentation or Spring
- application must not depend on infrastructure/presentation or Spring
- presentation must not depend on infrastructure
- infrastructure must not depend on presentation
- no backend class may end with `Service` (use `*UseCase`, `*Port`, `*Adapter`, etc.)

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
- `.agents/skills` uses known existing skills for Nx/Angular workflows (`nx-*`, `angular-new-app`, `angular-developer`), installs the upstream Impeccable pack from `pbakaus/impeccable` (`frontend-design`, `polish`, `audit`, `teach-impeccable`, etc.), and keeps project-specific backend standards skills (`backend-clean-architecture`, `backend-solid-principles`, `backend-programming-standards`).
- One popular `clean` skill from [skills.sh](https://skills.sh/?q=clean) is installed: `clean-code` (`sickn33/antigravity-awesome-skills`).
- `.codex/config.toml` enables project-scoped MCP servers for `nx`, the Angular CLI MCP server, OpenAI Developer Docs, and Playwright MCP.
- `skills-lock.json` tracks the installed external skill package versions.
- `write-adr` is a local skill for creating and maintaining consistent ADRs in `ADR/`.
- `docs/ai/skills-structure.md` defines the local skill folder quality bar.
- `llms.txt` and `.github/copilot-instructions.md` align behavior for non-Codex assistants.

If Codex does not pick up a new project-scoped MCP config immediately, restart Codex after trusting the project.

## Notes

- This starter intentionally pins Angular to `21.2.x` and Spring Boot to `4.0.4` per repository baseline decisions in `AGENTS.md` and ADRs.
- Node `22.15.1` is pinned because the Angular production build is stable there; the previously active Node `20.19.4` crashed in the native build process on this machine.
- Java is pinned to `21` for local reliability while remaining compatible with the chosen Spring Boot baseline. If you want to standardize on Java `25`, switch the toolchain in `server/build.gradle` and install/provision that JDK.
