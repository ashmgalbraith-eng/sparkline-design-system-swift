# Icon

`SPIcon` renders an icon from the Sparkline registry, drawn on a 24×24 grid. `SPIconShape` is the same icon as a `Shape`.

```swift
import Sparkline
```

## Use it for

- Decorative or supporting icons in layouts, list rows and headers.
- Inside your own buttons or links when no Sparkline component fits.

Components that show icons (`SPButton`, `SPInput`, `SPChip`, `SPButtonGroup`) take an `SPIconName` parameter; you do not nest an `SPIcon` in them.

## Parameters

`SPIcon(_ name:size:accessibilityLabel:)`

| Name | Type | Default | Angular | Notes |
|---|---|---|---|---|
| `name` | `SPIconName` | required | `name` | A case of the generated enum. Raw values match the web registry keys. |
| `size` | `CGFloat` | `24` | `size` | Points. Common sizes: 16, 20, 24, 32. |
| `accessibilityLabel` | `String?` | `nil` | (none) | Set it when the icon carries meaning on its own. Without it the icon is hidden from VoiceOver. |

The web's `color` is `.foregroundStyle(_:)` in Swift.

## Behavior

- The icon fills with the current foreground style. Color it with `.foregroundStyle(SPColor.textBrand)` or let it inherit from its parent. (The web default color is a primitive; the Swift icon has no default color of its own.)
- Names are an enum, so a typo is a compile error rather than an empty box.
- Icons are vector `Path`s generated at build time; they stay sharp at any size.

## Available names

`SPIconName.allCases` lists all 62 icons. Raw values: account-outline, alert-circle-outline, alert-outline, arrow-down, arrow-left, arrow-right, arrow-up, bell-outline, block-helper, calendar-blank-outline, camera-outline, card-account-details-outline, cash, chart-line, check, check-circle-outline, chevron-down, chevron-left, chevron-right, chevron-up, clock-hands, clock-outline, close, close-circle-fill, close-circle-outline, cog-outline, content-copy, credit-card-outline, currency-usd, dots-grid, dots-vertical, download-outline, email-outline, eye-off-outline, eye-outline, file-document-outline, filter-outline, heart-outline, help-circle-outline, home-outline, information-outline, lock-outline, magnify-minus-outline, magnify-plus-outline, map-marker-outline, menu, menu-down-outline, menu-left-outline, menu-right-outline, menu-swap-outline, menu-up-outline, minus, minus-circle-outline, pencil-outline, percent-outline, plus-circle-outline, printer-outline, refresh, search-outline, shield-half-full, star, trash-can-outline.

Swift case names are camelCase: `help-circle-outline` is `.helpCircleOutline`.

There is no chat or phone icon yet. The source of truth is `icon-registry.ts` in the web design system; regenerate with `node scripts/generate-icons.mjs`.

## Example

```swift
Link(destination: helpURL) {
    Label {
        Text("Get help")
    } icon: {
        SPIcon(.helpCircleOutline, size: 20)
    }
}
.foregroundStyle(SPColor.textBrand)

SPIcon(.checkCircleOutline, size: 48, accessibilityLabel: "Success")
    .foregroundStyle(SPColor.textSuccess)
```
