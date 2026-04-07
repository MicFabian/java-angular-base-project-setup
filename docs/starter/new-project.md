# New Project Workflow

Use this repository as a starter in four steps:

1. Personalize the template.
   - `pnpm run personalize -- --project-name orders-platform --display-name "Orders Platform" --java-base-package com.acme.orders`
2. Bootstrap the workspace.
   - `pnpm run doctor:db`
   - `pnpm run setup:db`
3. Verify the baseline before feature work.
   - `pnpm run verify`
4. Start development.
   - `pnpm nx serve client`
   - `./gradlew :server:bootRun`

## What The Personalization Script Updates

- root project names in Gradle and `package.json`
- display name in the Angular starter shell and tests
- Java package paths under `server/src/main/java` and `server/src/test/groovy`
- snapshot directories under `server/src/test/resources/snapshots`
- Spring application name
- local PostgreSQL defaults in Docker, Spring config, and Testcontainers support
- documentation references that should follow the new project identity

## Recommended First Commit

Make the personalization commit before feature work. That keeps the template rename separate from product changes and makes future diffs easier to review.

## Machine Baseline

- Use `pnpm run doctor` on a new machine before working in the repo.
- Use `pnpm run doctor:db` before database-backed local development.
- Backend package scripts run through `scripts/gradlew-local.sh` so Gradle state stays inside the repository by default.

## Backend Feature Scaffolding

After personalization, create new backend features with:

- `pnpm run scaffold:backend-feature -- billing`

The scaffold script reads the current starter metadata, so new features land under the current Java base package rather than the original placeholder package.
