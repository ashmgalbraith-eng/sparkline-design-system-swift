# Badge

`SPBadge` is a small status marker: a numeric count or a colored dot.

```swift
import Sparkline
```

## Use it for

- Unread or notification counts on an icon or avatar (`.numeric`).
- A compact status indicator next to a name (`.dot`).

## Don't use it for

- Status text such as "Pending" or "Active". Sparkline has no text badge yet; use `SPChip`, or build a small label with status tokens and note the gap.

## Parameters

`SPBadge(_ label:type:status:)` and `SPBadge.dot(_ status:)`

| Name | Type | Default | Angular | Notes |
|---|---|---|---|---|
| `label` | `String` | `"9"` | `label` | The count. Only shown for `.numeric`. Keep it short ("9", "99+"). |
| `type` | `SPBadgeType` | `.numeric` | `type` | `.numeric` or `.dot`. |
| `status` | `SPBadgeStatus` | `.notification` | `status` | `.success`, `.error`, `.warning`, `.info`, `.notification`. Sets the color. |

## Gotchas

- There is no positioning. Pin it with `.overlay(alignment: .topTrailing) { SPBadge("3").offset(x: 8, y: -8) }`. `SPAvatar` does this for you.
- A dot is hidden from VoiceOver. A numeric badge reads its label only ("3"); add context on the parent, e.g. `.accessibilityLabel("Notifications, 3 unread")`.
- Color alone carries a dot's meaning. Pair it with text nearby.

## Example

```swift
SPIcon(.bellOutline)
    .foregroundStyle(SPColor.textPrimary)
    .overlay(alignment: .topTrailing) {
        SPBadge("3").offset(x: 10, y: -8)
    }
    .accessibilityElement(children: .ignore)
    .accessibilityLabel("Notifications, 3 unread")
```

## Related

`SPAvatar` for badges on profile images. `SPChip` for text labels.
