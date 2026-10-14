# Sparkline tokens for app code

App code uses **semantic** tokens only. The primitive palette (`primary-50`, `neutral-20`, …) exists only to define the semantic colors and is internal to the package.

Every token is generated from the web design system's CSS (`scripts/generate-tokens.mjs`), so web and iOS share one set of names and values. Colors resolve to their light or dark value from the current color scheme; spacing, radius, shadow and type are the same in both themes.

## One set of names

The rule: `--{group}-{name}` in CSS is `SP{Group}.{camelName}` in Swift.

| CSS | Swift |
|---|---|
| `--color-surface-brand` | `SPColor.surfaceBrand` |
| `--color-text-primary` | `SPColor.textPrimary` |
| `--spacing-md` | `SPSpacing.md` |
| `--radius-lg` | `SPRadius.lg` |
| `--shadow-md` | `SPShadow.md`, applied with `.spShadow(.md)` |
| `--type-headline-1-*` | `SPType.headline1`, applied with `.spType(.headline1)` |

`SPColorToken`, `SPShadow` and `SPType` carry the CSS name as their raw value (`SPType.headline1.rawValue == "--type-headline-1"`).

## Color

Each `SPColor` token is a `Color`, so it works anywhere a color or shape style is expected: `.foregroundStyle(SPColor.textPrimary)`, `.fill(SPColor.surfaceBrand)`. Pick by role, not by hue.

| Role | Tokens |
|---|---|
| Text | `SPColor.textPrimary`, `SPColor.textSecondary`, `SPColor.textBrand`, `SPColor.textInverse`, `SPColor.textDisabled`, `SPColor.textOnDisabled` |
| Status text | `SPColor.textSuccess`, `SPColor.textWarning`, `SPColor.textError`, `SPColor.textInfo` |
| Surfaces | `SPColor.surfaceDefault` (screen and card background), `SPColor.surfaceSubtle`, `SPColor.surfaceBrand`, `SPColor.surfaceBrandSubtle`, `SPColor.surfaceInverse`, `SPColor.surfaceOverlay`, `SPColor.surfaceHoverBg`, `SPColor.surfaceDisabled`, `SPColor.surfaceSubtleDisabled` |
| Status surfaces | `SPColor.surfaceSuccess`, `SPColor.surfaceWarning`, `SPColor.surfaceError`, `SPColor.surfaceInfo` |
| Borders | `SPColor.borderDefault`, `SPColor.borderSubtle`, `SPColor.borderStrong`, `SPColor.borderDisabled`, `SPColor.borderInverse` |
| Status borders | `SPColor.borderSuccess`, `SPColor.borderWarning`, `SPColor.borderError`, `SPColor.borderInfo` |
| Actions | `SPColor.actionBrandText`, `SPColor.actionBrandBorder`, `SPColor.actionStrongText`, `SPColor.actionStrongBorder`, `SPColor.actionStrongHoverBg`, `SPColor.actionSubtleHoverBg`, `SPColor.actionSubtleFocus` |
| Controls | `SPColor.controlTrack`, `SPColor.controlTrackActive`, `SPColor.controlTrackInactive`, `SPColor.controlTrackDisabled`, `SPColor.controlThumbBrand`, `SPColor.controlThumbInverse`, `SPColor.controlThumbDisabled` |

`SPColorToken.allCases` lists them all.

Focus rings are the one exception to the semantic-only rule: use `SPColor.focusRing` (`--primary-30`), or `.spFocusRing(isFocused, cornerRadius:)`.

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

`.spShadow(.sm)`, `.spShadow(.md)`, `.spShadow(.lg)` for raised surfaces; `.spShadow(.button)` is reserved for buttons and control thumbs. CSS blur and spread are converted to a SwiftUI radius of (blur + spread) / 2.

## Typography

The font is Roboto (`SPFontFamily.base`, from `--type-font-family-base`); Manrope (`.secondary`) is available for marketing headings. Apply a full style (font, weight, line height, tracking) with `.spType(_:)`:

```swift
Text("Open a CD")
    .spType(.headline4)
    .foregroundStyle(SPColor.textPrimary)
```

Styles, largest to smallest: `.display`, `.headline1` to `.headline4`, `.subtitle1`, `.body1`, `.body2`, `.label`, `.button`, `.caption`.

- Every style scales with Dynamic Type.
- `.display` and `.headline1`–`.headline3` step up on iPad (regular horizontal size class), using the CSS `@media (min-width: 768px)` values.
- `SPType.font` gives just the `Font` (compact size) for APIs that need one.
