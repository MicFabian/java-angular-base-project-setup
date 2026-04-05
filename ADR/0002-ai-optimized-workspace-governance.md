# 0002: AI-Optimized Workspace Governance

- Status: Accepted
- Date: 2026-04-04
- Deciders: Project Maintainer
- Technical Story: Standardize an agent-ready project starter for repeated Angular + Spring Boot use

## Context

The repository already had strong technology defaults (Angular + Nx, Spring Boot + Gradle, backend clean architecture) but lacked formal governance for multi-agent instruction layering and skill quality checks.
Without this, behavior can drift across tools (Codex, Copilot, other MCP-capable agents), and external skill updates can silently break local assumptions.

## Decision

Adopt an AI workspace governance baseline with:

1. Layered instruction files:
   - root `AGENTS.md` for global repository rules
   - `client/AGENTS.md` for frontend scope
   - `server/AGENTS.md` for backend scope
2. Cross-agent context files:
   - `llms.txt` as compact project map for LLM-friendly discovery
   - `.github/copilot-instructions.md` for Copilot alignment
3. Skill governance and validation:
   - document skill structure in `docs/ai/skills-structure.md`
   - validate skill metadata and architectural guardrails with `scripts/verify-skills.sh`
   - include skills verification in `pnpm run verify`
4. Local toolchain pinning:
   - pin frontend Node.js to `22.15.1` via `.nvmrc` and `.node-version`
   - use a repository `pnpm` wrapper for shell scripts so `corepack pnpm` works without a globally installed `pnpm`
5. External skill update workflow:
   - keep external skills tracked in `skills-lock.json`
   - use `scripts/update-external-skills.sh` for `list`, `update`, and `check`

## Rationale

Layered instructions match modern agent resolution behavior and reduce accidental cross-stack policy violations.
Validation scripts turn conventions into enforceable checks, reducing regressions caused by prompt drift.
A lightweight cross-tool context layer improves consistency when different assistants operate in the same repository.

## Alternatives Considered

1. Keep only one root instruction file.
   - Pros: fewer files.
   - Cons: weaker scope isolation for frontend/backend specifics.
2. Store all guidance only inside skills.
   - Pros: agent-specific and explicit.
   - Cons: weaker compatibility with tools that read instruction files but not skill ecosystems.
3. Use manual external skill updates without checks.
   - Pros: minimal scripts.
   - Cons: update regressions are harder to detect and reproduce.

## Consequences

### Positive

- More deterministic assistant behavior across coding tools.
- Faster onboarding with clear scope-based instructions.
- Early detection of skill metadata or guardrail drift.

### Negative

- Additional maintenance for instruction and governance files.
- Slightly longer `verify` runtime due skills validation.

### Neutral

- External skill quality still depends on upstream projects; local validation only checks repository requirements.

## Implementation Notes

- Added scoped AGENTS files in `client/` and `server/`.
- Added `llms.txt` and Copilot instructions.
- Added `scripts/verify-skills.sh` and wired it into `scripts/verify-all.sh`.
- Added `.nvmrc`, `.node-version`, and `scripts/pnpmw.sh` for reproducible frontend tooling.
- Extended external skills update script with `check` mode and post-update validation.
- Added package scripts: `skills:verify`, `skills:check`, `skills:update`, `skills:list`.

## References

- https://developers.openai.com/codex/guides/agents-md
- https://developers.openai.com/codex/skills
- https://angular.dev/ai/mcp
- https://angular.dev/ai/agent-skills
- https://github.com/angular/skills
- https://nx.dev/docs/features/enhance-ai
- https://modelcontextprotocol.io/specification/2025-11-25/changelog
