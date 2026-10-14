# Colors

Semantic color tokens that adapt to light and dark mode.

## Overview

The palette has four primitive scales: **primary** (purple), **secondary** (magenta), **neutral** (grayscale) and **alert** (info, success, warning, error). Primitives are internal to the package. Components and apps use **semantic** tokens, named by role, which map to a primitive per theme.

The tokens are generated from the web design system's `global.css` by `scripts/generate-tokens.mjs`, so a token change in the web source reaches SwiftUI with one command:

```sh
node scripts/generate-tokens.mjs
```

## Using color tokens

Every semantic token is a static `Color` with an `sp` prefix: `--color-surface-brand` becomes `SPColor.surfaceBrand`. Where SwiftUI expects a `ShapeStyle`, use the leading-dot shorthand:

```swift
Text("Balance")
    .foregroundStyle(SPColor.textSecondary)

RoundedRectangle(cornerRadius: SPRadius.lg)
    .fill(SPColor.surfaceSubtle)
```

``SPColorToken`` lists every token, for galleries and tests.

## Token groups

| Group | Use for | Examples |
|---|---|---|
| Text | Foreground text and icons | `SPColor.textPrimary`, `SPColor.textSecondary`, `SPColor.textBrand`, `SPColor.textInverse` |
| Status | Feedback text, fills and borders | `SPColor.textError`, `SPColor.surfaceSuccess`, `SPColor.borderWarning` |
| Surface | Backgrounds | `SPColor.surfaceDefault`, `SPColor.surfaceSubtle`, `SPColor.surfaceBrand`, `SPColor.surfaceBrandSubtle` |
| Border | Strokes and dividers | `SPColor.borderDefault`, `SPColor.borderSubtle`, `SPColor.borderStrong` |
| Action | Interactive hover, pressed and focus states | `SPColor.actionBrandBorder`, `SPColor.actionBrandText` |
| Control | Tracks and thumbs of switches and sliders | `SPColor.controlTrack`, `SPColor.controlTrackActive`, `SPColor.controlThumbInverse` |

## Focus rings

Focus rings are the single exception to the semantic-only rule: use `SPColor.focusRing` (`primary-30`), or the `.spFocusRing(_:cornerRadius:)` modifier.

## Rules

- Never write literal colors (`Color(red:…)`, `.purple`, hex values) in components or app code.
- Pick tokens by role, not by hue. A brand-colored border is `SPColor.borderDefault`, not "the purple one".
- Status colors always need a second cue (an icon or text); color alone is not enough.

## Known token issues

These come from the web tokens and are reproduced faithfully:

- Dark mode: `SPColor.textOnDisabled` and `SPColor.surfaceDisabled` are both `neutral-70`, so disabled filled buttons have unreadable labels.
- Light mode: `SPColor.textDisabled` and `SPColor.surfaceDisabled` are both `neutral-40`, so disabled button-group labels are unreadable.
- Dark mode: `SPColor.surfaceDefault` is `neutral-90` (black), so elevated cards on the default surface have no visible edge.
