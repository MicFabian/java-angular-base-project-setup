# Skills Structure

This project keeps agent skills in `.agents/skills` using a single-skill-per-directory model.

## Required Layout

Each skill should follow:

- `.agents/skills/<skill-name>/SKILL.md` (required)
- `.agents/skills/<skill-name>/agents/openai.yaml` (optional)
- `.agents/skills/<skill-name>/references/*` (optional)
- `.agents/skills/<skill-name>/scripts/*` (optional)
- `.agents/skills/<skill-name>/assets/*` (optional)

## Quality Bar

1. `SKILL.md` frontmatter includes `name` and `description`.
2. Frontmatter `name` equals folder name.
3. Backend governance skills include ADR guidance (`write-adr` references).
4. Keep only one external clean-code style skill (`clean-code`) to avoid overlap.

## Governance

- Project-scoped external skills are tracked by `skills-lock.json`, which is written by `npx skills add`.
- Preferred upstreams in this repository:
  - `angular/skills` for Angular workflow skills
  - `nrwl/nx-ai-agents-config` for Nx workflow skills
  - `pbakaus/impeccable` for the requested Impeccable design pack
- Audit result on `2026-04-07`:
  - keep Angular and Nx skills on maintainer-owned upstreams
  - keep Impeccable on the requested upstream pack
  - no maintainer-owned Spring Boot, ADR, clean-architecture, SOLID, or backend-programming-standards skill source was found in the current catalog, so those stay repo-local
  - keep exactly one external clean-code style skill (`clean-code`) until a clearly better maintainer-owned replacement exists
- Discover skills with `pnpm run skills:find -- <query>`.
- Add or refresh curated project skills with `pnpm run skills:add -- <source> [--skill <name> ... -a codex -y]`.
- Restore the committed project skill set with `pnpm run skills:restore`.
- The current upstream `npx skills check` / `npx skills update` flow only covers globally tracked skills, not this repo's project lock.
- Validate skill integrity with `pnpm run skills:verify`.

## Local Standards Skills

- `use-base-repository`
- `backend-clean-architecture`
- `backend-solid-principles`
- `backend-programming-standards`
- `spring-boot-api`
- `fullstack-workflow`
- `write-adr`
