# 0001: Base Project Intent

- Status: Accepted
- Date: 2026-04-07
- Deciders: Project Maintainer
- Technical Story: Define the compact intended use and baseline of this starter

## Context

This repository is a reusable starter for future Angular and Spring Boot projects.
It needs one compact, durable statement of intent so new contributors and coding agents can understand the base without reading multiple ADRs.

The starter must optimize the first hours of a new project:

- personalize the copied repository once
- bootstrap a machine deterministically
- start building with clear frontend and backend boundaries
- validate changes with a small set of canonical commands

## Decision

Use this repository as a base project with the following baseline:

1. Repository shape:
   - `client` and `client-e2e` use Angular + Nx
   - `server` uses Spring Boot + Gradle
   - `ADR/` stores architecture records
2. Backend architecture:
   - roots: `controller`, `domain`, `accessor`, `config`, `shared`
   - request/response DTOs live in `controller/<feature>/resources`
   - domain may contain entities, Spring Data JPA repositories, and concrete use case/service classes
   - `accessor` is reserved for third-party integrations
   - Spring configuration lives in `config`
   - Hibernate is enabled with validation only; schema changes go through Flyway
3. AI-ready workspace:
   - `AGENTS.md`, scoped agent files, `llms.txt`, skills, and MCP config are part of the baseline
   - prefer deterministic commands and explicit repo rules over ad hoc agent behavior
4. Local workflow:
   - personalize with `pnpm run personalize -- ...`
   - check prerequisites with `pnpm run doctor` or `pnpm run doctor:db`
   - bootstrap with `pnpm run setup` or `pnpm run setup:db`
5. Quality gates:
   - frontend uses Nx build, test, lint, and Playwright E2E
   - backend uses Spock/Groovy tests, Testcontainers-backed integration tests, Flyway migrations, and Spotless with Palantir Java Format
   - `pnpm run verify` is the default fast full-repo validation command
6. Intended use:
   - copy this repository
   - personalize it into a new product repository
   - keep it as a modular monolith baseline unless a later ADR says otherwise

## Rationale

This keeps the starter opinionated enough to remove repeated setup decisions, but small enough to stay readable.
Nx is used where it clearly helps the frontend. Gradle stays standalone where that keeps backend complexity lower.
The backend roots stay simple while making controller DTOs, domain logic, configuration, and external integrations visibly separate.
Database migrations, Hibernate validation-only mode, integration tests, formatting, and agent guidance are treated as baseline engineering constraints rather than optional extras.

## Alternatives Considered

1. Keep multiple active ADRs for each baseline concern.
   - Pros: More detailed decision history.
   - Cons: Higher reading overhead for a starter that should be quickly understandable.
2. Keep no ADRs and rely only on `README.md` and `AGENTS.md`.
   - Pros: Less documentation structure.
   - Cons: Weaker long-term record of intended use and architectural direction.

## Consequences

### Positive

- One ADR explains how this starter is meant to be used.
- Future repositories created from it have a clear default operating model.

### Negative

- Detailed historical rationale is no longer in the main reading path.

### Neutral

- Future baseline changes should update or supersede this one ADR rather than creating multiple active baseline ADRs.

## Implementation Notes

- Treat this ADR as the current canonical statement of starter intent.
- Keep `README.md`, `AGENTS.md`, and starter scripts aligned with it.

## References

- `README.md`
- `AGENTS.md`
- `docs/starter/new-project.md`
- `scripts/personalize-template.sh`
- `scripts/bootstrap.sh`
- `scripts/verify-all.sh`
