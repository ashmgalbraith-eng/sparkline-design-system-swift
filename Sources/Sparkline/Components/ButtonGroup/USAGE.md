# ButtonGroup

`SPButtonGroup` is a segmented control: a row of connected buttons where exactly one is selected. It binds to a value of any `Hashable` type.

```swift
import Sparkline
```

## Use it for

- Switching between two to four views or modes (Monthly / Yearly, List / Map).
- A compact single choice where every option is short.

## Don't use it for

- Actions. Use separate `SPButton`s.
- Options with long labels, or more than four options. Use `SPRadioGroup` or `SPSelect`.

## Parameters

`SPButtonGroup(selection:items:size:showsLabel:)`

| Name | Type | Default | Angular | Notes |
|---|---|---|---|---|
| `selection` | `Binding<Value>` | required | `activeIndex`, `selectionChange` | The selected item's value. |
| `items` | `[SPButtonGroup<Value>.Item]` | required | `items`, `showLeftIcon`, `showRightIcon` | `.init(value, label:leftIcon:rightIcon:)`. Icons are per item and optional. |
| `size` | `SPButtonGroupSize` | `.large` | `size` | `.large` (48pt) or `.small` (36pt). |
| `showsLabel` | `Bool` | `true` | `showLabel` | `false` shows icons only; labels stay as VoiceOver labels. |

Disable the whole group with `.disabled(true)` (the web's `disabled`).

## Behavior

- Each segment is a native `Button`. The selected one has the `.isSelected` accessibility trait.
- Selection is by value, not index: no mapping needed in your code.

## Gotchas

- You cannot disable a single segment.
- Put a visible label above the group; the group itself has no title.
- **Known token issue (light mode):** disabled segment labels are not readable. `--color-text-disabled` and `--color-surface-disabled` are both `neutral-40` in the light theme. The web component has the same problem; fix it in the web tokens.

## Example

```swift
enum ViewMode: Hashable { case list, map }
@State private var mode = ViewMode.list

SPButtonGroup(selection: $mode, items: [
    .init(.list, label: "List", leftIcon: .menu),
    .init(.map, label: "Map", leftIcon: .mapMarkerOutline),
], size: .small)
```

## Related

`SPRadioGroup` for longer labels. `SPButton` for actions.
