# Versioning and Releases

Changes are grouped logically, versioned clearly, and released on Design System terms. Teams choose their own adoption timeline.

## Version types

| Type | Meaning | Includes |
|---|---|---|
| **Patch** | Safe to adopt immediately | Bug fixes, minor corrections, non-disruptive accessibility fixes |
| **Minor** | Additive and backward-compatible | New tokens, new components, additive updates |
| **Major** | Requires consumer action | Token removal or rename, component contract changes, required consumer action |

For the Swift package, a "component contract" is its public API: renaming or removing an initializer parameter, enum case or type is a major change. Adding a parameter with a default value is minor.

## Grouping strategy

Releases are bundled by theme so consumers can scan a changelog and immediately understand what kind of change they're looking at:

- **Theme updates:** brand color changes.
- **Token updates:** color, sizing, typography.
- **Component updates:** across platforms.
- **Platform parity releases:** iOS and Android together.
