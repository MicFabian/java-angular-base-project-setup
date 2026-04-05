---
name: write-adr
description: Use when creating or updating Architecture Decision Records (ADRs) in this repository. Produces concise, decision-focused ADRs using the project template in ADR/ and proper status/lifecycle handling.
---

# Write ADR

Use this skill whenever the task involves architectural decisions, trade-offs, or documenting why a technical choice was made.

## Where ADRs Live

- Store ADRs in `ADR/`.
- Follow file naming `NNNN-short-kebab-title.md` (4-digit sequence).
- Use `ADR/0000-template.md` as the baseline format.

## Required ADR Quality Bar

1. Be explicit about the decision and scope.
2. Include real constraints (time, compatibility, operations, team capability).
3. Compare at least two alternatives.
4. Record concrete consequences (positive and negative).
5. Include implementation notes and how correctness will be validated.
6. Avoid generic claims without evidence or rationale.

## ADR Structure

Include these sections in order:

1. Header metadata (`Status`, `Date`, `Deciders`, optional link)
2. `Context`
3. `Decision`
4. `Rationale`
5. `Alternatives Considered`
6. `Consequences` (`Positive`, `Negative`, `Neutral`)
7. `Implementation Notes`
8. `References`

## Status and Lifecycle Rules

- New ADRs default to `Proposed` unless user asks otherwise.
- Mark as `Accepted` when the team confirms implementation direction.
- Never delete historical ADRs that were superseded.
- If replaced, set old ADR status to `Superseded` and link to the new ADR.

## Writing Style

- Keep language direct and specific.
- Use short paragraphs and concrete statements.
- Prefer measurable criteria and actionable follow-up tasks.
- Keep ADRs self-contained so a future contributor can understand the decision without chat history.
