# Sparkline tokens for app code

App code uses **semantic** tokens only. The primitive palette (`primary-50`, `neutral-20`, …) exists only to define the semantic colors and is internal to the package.

Color tokens are generated from the web design system's CSS (`scripts/generate-tokens.mjs`) and resolve to their light or dark value from the current color scheme. Spacing, radius, shadow and type tokens are the same in both themes.

## Color

Use `Color.spName` anywhere a `Color` is expected, or the shorthand `.spName` where a `ShapeStyle` is expected (`.foregroundStyle(.spTextPrimary)`, `.fill(.spSurfaceBrand)`). Pick by role, not by hue.

| Role | Tokens |
|---|---|
| Text | `spTextPrimary`, `spTextSecondary`, `spTextBrand`, `spTextInverse`, `spTextDisabled`, `spTextOnDisabled` |
| Status text | `spTextSuccess`, `spTextWarning`, `spTextError`, `spTextInfo` |
| Surfaces | `spSurfaceDefault` (screen and card background), `spSurfaceSubtle`, `spSurfaceBrand`, `spSurfaceBrandSubtle`, `spSurfaceInverse`, `spSurfaceOverlay`, `spSurfaceHoverBg`, `spSurfaceDisabled`, `spSurfaceSubtleDisabled` |
| Status surfaces | `spSurfaceSuccess`, `spSurfaceWarning`, `spSurfaceError`, `spSurfaceInfo` |
| Borders | `spBorderDefault`, `spBorderSubtle`, `spBorderStrong`, `spBorderDisabled`, `spBorderInverse` |
| Status borders | `spBorderSuccess`, `spBorderWarning`, `spBorderError`, `spBorderInfo` |
| Actions | `spActionBrandText`, `spActionBrandBorder`, `spActionStrongText`, `spActionStrongBorder`, `spActionStrongHoverBg`, `spActionSubtleHoverBg`, `spActionSubtleFocus` |
| Controls | `spControlTrack`, `spControlTrackActive`, `spControlTrackInactive`, `spControlTrackDisabled`, `spControlThumbBrand`, `spControlThumbInverse`, `spControlThumbDisabled` |

Each Swift name is the CSS name in camelCase: `--color-surface-brand` is `spSurfaceBrand`. `SPColorToken.allCases` lists them all.

Focus rings are the one exception to the semantic-only rule: use `Color.spFocusRing` (`--primary-30`), or `.spFocusRing(isFocused, cornerRadius:)`.

## Spacing

| Token | Value |
|---|---|
| `SPSpacing.xs` | 4pt |
| `SPSpacing.sm` | 8pt |
| `SPSpacing.md` | 16pt |
| `SPSpacing.lg` | 24pt |
| `SPSpacing.xl` | 32pt |

For larger gaps, combine tokens (`SPSpacing.xl * 2`) instead of hardcoding numbers.

## Radius

| Token | Value |
|---|---|
| `SPRadius.sm` | 2pt |
| `SPRadius.md` | 4pt |
| `SPRadius.lg` | 8pt |
| `SPRadius.xl` | 12pt |
| `SPRadius.full` | 999pt (pills and circles) |

## Shadow

`.spShadow(.sm)`, `.spShadow(.md)`, `.spShadow(.lg)` for raised surfaces; `.spShadow(.button)` is reserved for buttons and control thumbs.

## Typography

The font is Roboto (`SPFontFamily.primary`); Manrope (`.secondary`) is available for marketing headings. Apply a full style (font, weight, line height, tracking) with `.spTextStyle(_:)`:

```swift
Text("Open a CD")
    .spTextStyle(.headline4)
    .foregroundStyle(.spTextPrimary)
```

Styles, largest to smallest: `.display`, `.headline1` to `.headline4`, `.subtitle1`, `.body1`, `.body2`, `.label`, `.button`, `.caption`.

- Every style scales with Dynamic Type.
- `.display` and `.headline1`–`.headline3` step up on iPad (regular horizontal size class), matching the web tablet breakpoint.
- `SPTextStyle.font` gives just the `Font` (compact size) for APIs that need one.
