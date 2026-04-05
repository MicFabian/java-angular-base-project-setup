# Client Instructions

## Scope

Applies to `client`, `client-e2e`, and frontend-facing libraries in `libs/web/*`.

## Baseline

- Angular `21.2.x`
- Node.js `22.15.x`
- Nx `22.x` via `pnpm nx`
- Unit tests with Vitest, E2E with Playwright

## Working Rules

1. Prefer existing skills first: `angular-new-app`, `angular-developer`, `nx-*`, and Impeccable skills for frontend quality.
2. Keep routes in `src/app/app.routes.ts` and feature screens in `src/app/pages`.
3. Use Angular standalone APIs and signals-first patterns for new code.
4. Keep component logic thin and push non-trivial business orchestration to backend use cases.
5. If an API contract changes, update frontend consumers in the same turn and align with `server`.
6. Run `pnpm nx build client` after non-trivial generation/refactors.
7. If structural or architectural frontend direction changes, create/update an ADR in `ADR/` via `write-adr`.

## Validation

- `pnpm nx test client`
- `pnpm nx build client`
- `pnpm nx e2e client-e2e` (for user flow changes)
