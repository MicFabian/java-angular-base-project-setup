# Skills Workspace

This folder contains the repository-scoped skills used by Codex.

## Layout

Each skill lives in its own directory:

- `.agents/skills/<skill-name>/SKILL.md`
- `.agents/skills/<skill-name>/agents/openai.yaml` when agent-specific triggers are needed
- optional `references/`, `scripts/`, and `assets/` subfolders

## Rules

- Keep one responsibility per skill.
- Prefer maintainer-owned upstream skills where they exist.
- In this repository, that means `angular/skills`, `nrwl/nx-ai-agents-config`, and `pbakaus/impeccable`.
- Keep Spring/backend governance skills local unless a genuine maintainer-owned replacement appears.
- Keep repository-specific standards local here.
- Use `write-adr` when a skill changes architectural direction or governance.

## Validation

- Run `pnpm run skills:verify` to validate skill metadata and required guardrails.
- Run `pnpm run skills:find -- <query>` to discover upstream skills.
- Run `pnpm run skills:add -- <source> [--skill <name> ... -a codex -y]` to add or refresh project-scoped external skills.
- Run `pnpm run skills:restore` to restore project-scoped external skills from `skills-lock.json`.

See [docs/ai/skills-structure.md](/Users/mivi/IdeaProjects/baseProject/docs/ai/skills-structure.md) for the repository-wide skill governance reference.
