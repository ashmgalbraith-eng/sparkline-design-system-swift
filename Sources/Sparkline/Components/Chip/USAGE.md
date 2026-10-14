# Chip

`SPChip` is a compact pill for a tag, filter or selection. Passing `onRemove` makes it clearable: a remove button appears on the right.

```swift
import Sparkline
```

## Use it for

- Showing applied filters or selections the user can remove (pass `onRemove`).
- Short, static tags or categories.

## Don't use it for

- Primary actions. Use `SPButton`.
- Filters the user toggles on and off. Chip has no selected state; use `SPButtonGroup` or `SPCheckbox`.

## Parameters

`SPChip(_ label:leftIcon:rightIcon:onRemove:)`

| Name | Type | Default | Angular | Notes |
|---|---|---|---|---|
| `label` | `String` | required | `label` | |
| `leftIcon` | `SPIconName?` | `nil` | `showLeftIcon` + `leftIconName` | `nil` hides it. |
| `rightIcon` | `SPIconName?` | `nil` | `showRightIcon` + `rightIconName` | `nil` hides it. Ignored when the chip is clearable. |
| `onRemove` | `(() -> Void)?` | `nil` | `type: 'clearable'`, `removed` | When set, the chip is clearable: it shows a remove button that calls this. |

Disable with `.disabled(true)`. Hover, pressed and focus (the web's `state`) come from the system.

## Behavior

- The remove control is a real `Button` labelled "Remove <label>", so VoiceOver and keyboard users can reach it (unlike the web chip).
- The chip itself is not tappable. Hover shows on iPad with a pointer.

## Gotchas

- The chip does not remove itself. Remove it from your data in `onRemove`.

## Example

```swift
SPFlowLayout(spacing: SPSpacing.sm) {
    ForEach(filters, id: \.self) { filter in
        SPChip(filter) { filters.removeAll { $0 == filter } }
    }
    SPButton("Clear all", type: .text, size: .small) { filters = [] }
}
```

## Related

`SPSelect` with a `Set` binding shows its own chips. `SPBadge` for counts. `SPFlowLayout` wraps chips onto rows.
