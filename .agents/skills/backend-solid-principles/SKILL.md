---
name: backend-solid-principles
description: Use when reviewing or implementing backend classes in server and you need concrete SOLID checks to improve extensibility, cohesion, and maintainability.
---

# Backend SOLID Principles

Use this skill as a coding and review checklist for Java/Groovy backend changes.

1. `S` Single Responsibility:
   - Keep each class focused on one reason to change.
   - Split controllers, resources, use cases, validators, repositories, and third-party integrations.
   - Do not create "god" `*Service` classes that coordinate unrelated behavior.
2. `O` Open/Closed:
   - Prefer extension through strategy interfaces, composition, and polymorphism.
   - Avoid editing large conditional blocks for every new behavior.
3. `L` Liskov Substitution:
   - Subtypes must preserve base contract behavior and null/error expectations.
   - Avoid inheritance when behavior diverges; use composition instead.
4. `I` Interface Segregation:
   - Keep interfaces small and use-case-oriented.
   - Do not force clients to depend on methods they do not need.
5. `D` Dependency Inversion:
   - Keep controllers dependent on domain use cases, not config/accessor code.
   - Keep Spring configuration in `config` and third-party integrations in `accessor`.
   - Let domain use cases depend on repositories or narrow abstractions, not unrelated controllers or integration classes.

When applying SOLID, keep these outcomes measurable:

- Smaller units with focused tests.
- Reduced feature coupling across packages.
- Fewer regressions when adding new behavior.

Validation:

- ADR check for architecture-impacting changes: update or create an ADR in `ADR/` via `write-adr`.
- `pnpm run test:server:architecture`
- `./gradlew :server:test`
- Add or adjust Spock tests for changed classes/contracts.
