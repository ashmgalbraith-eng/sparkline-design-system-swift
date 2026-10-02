# Colors

Semantic color tokens that adapt to light and dark mode.

## Overview

The palette has four primitive scales: **primary** (purple), **secondary** (magenta), **neutral** (grayscale) and **alert** (info, success, warning, error). Primitives are internal to the package. Components and apps use **semantic** tokens, named by role, which map to a primitive per theme.

The tokens are generated from the web design system's `global.css` by `scripts/generate-tokens.mjs`, so a token change in the web source reaches SwiftUI with one command:

```sh
node scripts/generate-tokens.mjs
```

## Using color tokens

Every semantic token is a static `Color` with an `sp` prefix: `--color-surface-brand` becomes `Color.spSurfaceBrand`. Where SwiftUI expects a `ShapeStyle`, use the leading-dot shorthand:

```swift
Text("Balance")
    .foregroundStyle(.spTextSecondary)

RoundedRectangle(cornerRadius: SPRadius.lg)
    .fill(.spSurfaceSubtle)
```

``SPColorToken`` lists every token, for galleries and tests.

## Token groups

| Group | Use for | Examples |
|---|---|---|
| Text | Foreground text and icons | `spTextPrimary`, `spTextSecondary`, `spTextBrand`, `spTextInverse` |
| Status | Feedback text, fills and borders | `spTextError`, `spSurfaceSuccess`, `spBorderWarning` |
| Surface | Backgrounds | `spSurfaceDefault`, `spSurfaceSubtle`, `spSurfaceBrand`, `spSurfaceBrandSubtle` |
| Border | Strokes and dividers | `spBorderDefault`, `spBorderSubtle`, `spBorderStrong` |
| Action | Interactive hover, pressed and focus states | `spActionBrandBorder`, `spActionBrandText` |
| Control | Tracks and thumbs of switches and sliders | `spControlTrack`, `spControlTrackActive`, `spControlThumbInverse` |

## Focus rings

Focus rings are the single exception to the semantic-only rule: use `Color.spFocusRing` (`primary-30`), or the `.spFocusRing(_:cornerRadius:)` modifier.

## Rules

- Never write literal colors (`Color(red:…)`, `.purple`, hex values) in components or app code.
- Pick tokens by role, not by hue. A brand-colored border is `spBorderDefault`, not "the purple one".
- Status colors always need a second cue (an icon or text); color alone is not enough.

## Known token issues

These come from the web tokens and are reproduced faithfully:

- Dark mode: `spTextOnDisabled` and `spSurfaceDisabled` are both `neutral-70`, so disabled filled buttons have unreadable labels.
- Light mode: `spTextDisabled` and `spSurfaceDisabled` are both `neutral-40`, so disabled button-group labels are unreadable.
- Dark mode: `spSurfaceDefault` is `neutral-90` (black), so elevated cards on the default surface have no visible edge.
