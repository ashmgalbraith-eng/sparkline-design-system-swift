# Card

`SPCard` is a container surface for grouping related content. It only draws the surface (background, border or shadow, radius, padding); you supply the content.

```swift
import Sparkline
```

## Use it for

- Summaries and receipts (account details, rate tables, review screens).
- Tiles or list items, with your own content and tap handling inside.

## Don't use it for

- Page sections that should sit flat on the background. Use a plain stack with token spacing.
- Modals or bottom sheets. Use SwiftUI's `.sheet`, styled with tokens.

## Parameters

`SPCard(variant:padding:content:)`

| Name | Type | Default | Angular | Notes |
|---|---|---|---|---|
| `variant` | `SPCardVariant` | `.elevated` | `variant` | `.elevated` uses a shadow, `.outlined` a border, `.filled` a subtle background. |
| `padding` | `SPCardPadding` | `.md` | `padding` | `.none`, `.sm`, `.md`, `.lg`: 0, 8, 16 or 24pt. Use `.none` when the content has its own rows and dividers. |
| `content` | `@ViewBuilder` | required | (projected content) | Laid out in a leading-aligned `VStack` with no spacing. |

## Behavior

- The card fills the available width. Constrain it with `.frame(maxWidth:)`.
- The radius is `SPRadius.xl` (12pt) and content is clipped to it.

## Gotchas

- Card is not interactive. For a tappable card, wrap it: `Button { … } label: { SPCard { … } }.buttonStyle(.plain)`.
- **Known token issue (dark mode):** `.elevated` is invisible on a `SPColor.surfaceDefault` background, because the card and page are both `neutral-90` and the black shadow does not show. Use `.outlined` on dark default surfaces, or fix the token in the web design system.

## Example

```swift
SPCard(variant: .outlined, padding: .none) {
    ForEach(rows) { row in
        HStack {
            Text(row.key).foregroundStyle(SPColor.textSecondary)
            Spacer()
            Text(row.value).foregroundStyle(SPColor.textPrimary)
        }
        .spType(.body2)
        .padding(SPSpacing.md)
        if row.id != rows.last?.id {
            Divider().overlay(SPColor.borderSubtle)
        }
    }
}
```

## Related

`SPBadge` and `SPChip` for small status labels inside a card.
