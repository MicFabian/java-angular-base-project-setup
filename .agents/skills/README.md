# Skills Workspace

This folder contains the repository-scoped skills used by Codex.

## Layout

Each skill lives in its own directory:

- `.agents/skills/<skill-name>/SKILL.md`
- `.agents/skills/<skill-name>/agents/openai.yaml` when agent-specific triggers are needed
- optional `references/`, `scripts/`, and `assets/` subfolders

## Rules

- Keep one responsibility per skill.
- Prefer maintained upstream skills where they exist.
- Keep repository-specific standards local here.
- Use `write-adr` when a skill changes architectural direction or governance.

## Validation

- Run `pnpm run skills:verify` to validate skill metadata and required guardrails.
- Run `pnpm run skills:update` to refresh tracked external skills from `skills-lock.json`.

See [docs/ai/skills-structure.md](/Users/mivi/IdeaProjects/baseProject/docs/ai/skills-structure.md) for the repository-wide skill governance reference.
