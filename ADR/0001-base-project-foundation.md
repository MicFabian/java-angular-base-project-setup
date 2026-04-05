# 0001: Base Project Foundation

- Status: Accepted
- Date: 2026-03-27
- Deciders: Project Maintainer
- Technical Story: Establish reusable baseline for future Angular + Java projects

## Context

This repository is intended to be a repeatable base project for future product work using Angular and Spring Boot.
Without explicit baseline decisions, each new project would re-debate structure, tooling boundaries, and quality checks, which increases drift and slows delivery.
The project needs a stable default for frontend orchestration, backend architecture boundaries, local database setup, and verification workflows.

## Decision

Adopt the following baseline:

1. Keep a single repository with Nx for frontend (`client`, `client-e2e`) and standalone Gradle for backend (`server`).
2. Enforce backend package-by-feature clean architecture with Ports/Adapters and no generic `*Service` classes.
3. Enforce architecture rules through automated backend tests (`CleanArchitectureRulesTest`).
4. Keep local database orchestration in `docker/compose.yaml` with init scripts in `docker/init`.
5. Use `pnpm run verify` as the default full-project quality gate.

## Rationale

This setup keeps frontend workflows fast and standardized with Nx while avoiding unnecessary backend coupling to Nx.
A clean-architecture backend default lowers long-term change risk and keeps domain logic independent from frameworks.
Automated architecture checks convert conventions into enforceable rules.
A colocated Docker setup supports predictable local onboarding.
A single verification command reduces accidental partial validation.

## Alternatives Considered

1. Split frontend and backend into separate repositories.
   - Pros: Independent release cycles.
   - Cons: Higher coordination cost, duplicated tooling setup, weaker cross-stack discoverability.
2. Manage backend through Nx Gradle integration.
   - Pros: Unified task graph.
   - Cons: Additional integration complexity for limited value in this baseline.
3. Organize backend by technical layers globally (controller/service/repository).
   - Pros: Familiar for some teams.
   - Cons: Weaker feature cohesion, harder modular evolution, easier boundary violations.

## Consequences

### Positive

- Faster bootstrap for new projects with fewer architectural decisions to re-make.
- Enforced backend boundaries reduce coupling and refactor risk.
- Shared verification and Docker conventions improve onboarding consistency.

### Negative

- Additional upfront discipline is required to maintain ADRs and architecture checks.
- Some contributors may need adaptation to package-by-feature and Ports/Adapters.

### Neutral

- Future changes to baseline decisions should be recorded as follow-up ADRs that supersede this one when needed.

## Implementation Notes

- Use `scripts/new-backend-feature.sh` to scaffold new backend features in the approved structure.
- Use `pnpm run test:server:architecture` and `pnpm run verify` during normal development and CI.
- For architecture-impacting changes, create or update ADRs in `ADR/` with the `write-adr` skill.

## References

- `README.md`
- `AGENTS.md`
- `server/src/test/java/com/example/baseproject/api/architecture/CleanArchitectureRulesTest.java`
- `scripts/verify-all.sh`
- `scripts/new-backend-feature.sh`
- `docker/compose.yaml`
