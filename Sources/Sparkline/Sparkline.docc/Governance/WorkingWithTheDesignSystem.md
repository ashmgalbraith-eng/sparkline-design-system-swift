# Working with the Design System

Ownership, authority and process that protect system integrity without blocking delivery.

## Governance principles

1. The Design System evolves independently of product releases.
2. Versioning communicates impact and required action, not just what changed.
3. Consumers choose when to adopt updates.
4. The Design System is responsible for releasing system updates, not for driving adoption.
5. Governance is not meant to override Brand decisions or introduce unnecessary process.

## Who owns what

| Team | Owns |
|---|---|
| Design System | Tokens, colors, components, versioning, releases |
| Brand | Brand guidelines, frames and color systems |
| Product UX | Product-level design needs and formal requests |
| Engineering | Application implementation and version adoption |

### Boundaries

1. Brand defines direction; the Design System may alter it to meet accessibility requirements.
2. UX submits requests and collaborates, but does not directly modify the Design System.
3. Engineering integrates the Design System as provided and cannot override tokens without alignment.

## Submitting a request

The Design System has final approval on what gets built, when and how. All other teams engage through defined intake channels.

> Important: Submit requests at least **3 weeks** before the need date so the Design System can review, refine scope and prioritize the work.

1. The Design System reviews, refines scope and prioritizes all incoming work before committing to it.
2. Engineering may choose when to adopt a Design System version, but cannot hardcode values when tokens exist or override version classifications.

In this Swift package that means: no literal colors, spacing or radii in app code, and no editing generated token or icon files by hand. Token and icon changes go through the web source and the generator scripts.

For how feedback and approvals are handled once work is underway, see <doc:CommunicationAndEnforcement>.
