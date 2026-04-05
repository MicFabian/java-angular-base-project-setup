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

- External skills are tracked by `skills-lock.json`.
- Refresh external skills with `pnpm run skills:update`.
- Validate skill integrity with `pnpm run skills:verify`.

## Local Standards Skills

- `backend-clean-architecture`
- `backend-solid-principles`
- `backend-programming-standards`
- `spring-boot-api`
- `fullstack-workflow`
- `write-adr`
