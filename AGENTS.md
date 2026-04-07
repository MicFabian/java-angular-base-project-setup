# Repository Guidelines

## Structure

- `client` contains the Angular frontend. Keep routing in `src/app/app.routes.ts` and feature code in `src/app/pages` or future `libs/web/*` libraries.
- `server` contains the Spring Boot backend. Use package-by-feature under `src/main/java/com/example/baseproject/api` and place Spock specs in `src/test/groovy`.
- `libs` is reserved for shared code. Use `libs/web/*` for Angular libraries and `libs/shared/*` for TypeScript-only contracts or utilities.
- `ADR` stores architecture decision records. Use `ADR/0000-template.md` and naming `NNNN-short-kebab-title.md`.
- `.starter/project-metadata.env` stores the current starter identity for renaming and scaffolding scripts.
- `.agents/skills` contains repo-local skills for Codex. Prefer those over ad hoc repo exploration when they match the task.
- `.codex/config.toml` contains the project-scoped MCP setup for Codex.
- `client/AGENTS.md` and `server/AGENTS.md` add scope-specific overrides for frontend/backend work.
- `docs/ai/skills-structure.md` defines skills-folder governance and validation expectations.

## Working Rules

- Prefer `nx` commands for frontend work and use the Gradle wrapper directly for backend work.
- Use `pnpm run personalize -- ...` when turning this starter into a new repository instead of manual search-and-replace.
- Use `pnpm run setup` or `pnpm run setup:db` for first-machine bootstrap instead of ad hoc install steps.
- Use `pnpm run doctor` or `pnpm run doctor:db` to check the local toolchain before debugging environment issues.
- Use `pnpm run format` for repo-wide formatting, `pnpm run format:frontend` for Prettier, and `pnpm run format:backend` for Spotless + Palantir Java Format.
- Treat Angular `21.2.x` as the current stable line in this repo. Do not jump to Angular `22` prereleases unless explicitly requested.
- Treat Node.js `22.15.x` as the frontend runtime baseline for this repo.
- Treat Spring Boot `4.0.4` as the backend baseline. Java is pinned to toolchain `21` for local reliability; raise it only with an explicit runtime decision.
- Keep backend HTTP contracts simple and explicit. If the API surface changes, update the frontend consumer in the same change.
- Use Flyway for backend schema changes and keep Docker-backed backend verification in `:server:integrationTest`.
- Keep `server/src/main/resources/application.yml` authoritative. Use profile-specific test configs in `server/src/test/resources/` instead of shadowing the main file with another `application.yml`.
- For Boot 4 actuator setup, prefer endpoint access properties over legacy enable/disable flags.
- For architectural changes, create or update an ADR in `ADR/` in the same turn.
- Enforce clean architecture boundaries on backend changes:
  - infrastructure communication must go through Ports/Adapters
  - avoid generic multi-purpose `*Service` classes
  - keep use cases/services single-purpose with one responsibility
  - preserve or extend `CleanArchitectureRulesSpec` when adding new backend patterns
- `scripts/new-backend-feature.sh` must keep reading `.starter/project-metadata.env` so backend scaffolds follow the current Java base package.
- Prefer `scripts/gradlew-local.sh` in repo automation so Gradle state stays inside `.gradle-user`.
- Use Spock/Groovy for backend tests. For backend snapshots, use Snappo and update them via `./gradlew :server:updateSnapshots`.
- Prefer slice tests on the backend (`@WebMvcTest`, repository tests, etc.) and use `@SpringBootTest` sparingly.
- Prefer known existing skills first:
  - `nx-workspace` for workspace discovery/debugging
  - `nx-generate` for scaffolding
  - `nx-run-tasks` for running targets
  - `angular-new-app` and `angular-developer` for Angular work
  - Impeccable design pack skills from `pbakaus/impeccable` (`frontend-design`, `polish`, `audit`, `teach-impeccable`, etc.) for frontend quality
  - `spring-boot-api` and `fullstack-workflow` for backend/full-stack changes
  - `write-adr` for architecture decision records
  - `playwright` for browser automation and UI flow checks
- Prefer maintainer-owned upstream skills over community copies when the capability exists.
- For backend architecture and quality guidance, use:
  - `backend-clean-architecture`
  - `backend-solid-principles`
  - `backend-programming-standards`
  - one external clean skill: `clean-code`

## Validation

- Frontend: `pnpm nx build client`, `pnpm nx test client`, `pnpm nx e2e client-e2e`
- Backend: `./gradlew :server:test`, `./gradlew :server:build`, `./gradlew :server:bootRun`
- Backend integration: `./gradlew :server:integrationTest`
- Backend architecture: `pnpm run test:server:architecture`
- Formatting: `pnpm run format:check`
- Repo-wide quick pass: `pnpm run verify`
- Full pass including E2E: `pnpm run verify:e2e`
- CI-equivalent backend pass: `pnpm run verify:ci`
- Skills integrity checks: `pnpm run skills:verify`

<!-- nx configuration start-->
<!-- Leave the start & end comments to automatically receive updates. -->

# General Guidelines for working with Nx

- For navigating/exploring the workspace, invoke the `nx-workspace` skill first - it has patterns for querying projects, targets, and dependencies
- When running tasks (for example build, lint, test, e2e, etc.), always prefer running the task through `nx` (i.e. `nx run`, `nx run-many`, `nx affected`) instead of using the underlying tooling directly
- Prefix nx commands with the workspace's package manager (e.g., `pnpm nx build`, `npm exec nx test`) - avoids using globally installed CLI
- You have access to the Nx MCP server and its tools, use them to help the user
- For Nx plugin best practices, check `node_modules/@nx/<plugin>/PLUGIN.md`. Not all plugins have this file - proceed without it if unavailable.
- NEVER guess CLI flags - always check nx_docs or `--help` first when unsure

## Scaffolding & Generators

- For scaffolding tasks (creating apps, libs, project structure, setup), ALWAYS invoke the `nx-generate` skill FIRST before exploring or calling MCP tools

## When to use nx_docs

- USE for: advanced config options, unfamiliar flags, migration guides, plugin configuration, edge cases
- DON'T USE for: basic generator syntax (`nx g @nx/react:app`), standard commands, things you already know
- The `nx-generate` skill handles generator discovery internally - don't call nx_docs just to look up generator syntax

<!-- nx configuration end-->
