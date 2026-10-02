# Button

`SPButton` triggers an action. Three emphasis levels: `.filled` (primary), `.outlined` (secondary), `.text` (tertiary or inline).

```swift
import Sparkline
```

## Use it for

- The main action on a screen or step (`.filled`, one per view).
- Secondary actions next to a primary one (`.outlined`).
- Low-emphasis or inline actions such as "Edit" or "Cancel" (`.text`).

## Don't use it for

- Navigation to another screen. Use a `NavigationLink`, styled with `SPButtonStyle` if it should look like a button.
- Toggling between options. Use `SPButtonGroup`.

## Parameters

`SPButton(_ label:variant:size:leftIcon:rightIcon:showsLabel:isFullWidth:action:)`

| Name | Type | Default | Notes |
|---|---|---|---|
| `label` | `String` | required | Visible text, and the VoiceOver label. |
| `variant` | `SPButton.Variant` | `.filled` | `.filled`, `.outlined`, `.text`. |
| `size` | `SPButton.Size` | `.large` | `.large` (48pt), `.small` (36pt). Grows taller with Dynamic Type. |
| `leftIcon` / `rightIcon` | `SPIconName?` | `nil` | Any icon from the registry. |
| `showsLabel` | `Bool` | `true` | `false` makes an icon-only button. Keep `label` set: it becomes the accessibility label. |
| `isFullWidth` | `Bool` | `false` | Stretches to the container's width. |
| `action` | `() -> Void` | required | Not called while disabled. |

Disable with the standard modifier: `.disabled(!canContinue)`.

`SPButtonStyle(variant:size:isFullWidth:)` is the same look as a `ButtonStyle`, for a `Button`, `NavigationLink` or `ShareLink` with custom content.

## Behavior

- It is a native `Button`, so VoiceOver, Full Keyboard Access, Return/Space and pointer hover all work.
- Pressed state: background darkens and corners round to a pill, as on the web.
- Hover state shows on iPad with a pointer. Focus shows the `--primary-30` ring when focused from a hardware keyboard.

## Gotchas

- There is no `state` parameter. Disabled comes from `.disabled(_:)`. To show hover/pressed/focus statically (catalogs, snapshots), use `.spInteractionState(.hover)`.
- **Known token issue (dark mode):** a disabled `.filled` button's label is not readable. `--color-text-on-disabled` and `--color-surface-disabled` are both `neutral-70` in the dark theme. Fix it in the web tokens; the Swift colors are generated from them.

## Example

```swift
HStack {
    SPButton("Back", variant: .text, leftIcon: .arrowLeft) { goBack() }
    SPButton("Continue") { goNext() }
}

SPButton("Create login", isFullWidth: true) { submit() }
    .disabled(!canSubmit)
```

## Related

`SPButtonGroup` for segmented choices. `SPIcon` for icon names.
