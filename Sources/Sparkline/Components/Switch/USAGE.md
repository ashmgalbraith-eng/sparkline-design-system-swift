# Switch

`SPSwitch` is an on/off toggle for settings that take effect immediately. It shows its label leading and the switch trailing, like a Settings row. `.toggleStyle(.sparkline)` applies the same look to any `Toggle`.

```swift
import Sparkline
```

## Use it for

- Preferences that apply as soon as they change (paperless statements, notifications).

## Don't use it for

- Choices that are only saved when a form is submitted. Use `SPCheckbox`.
- Consent or agreement. Use `SPCheckbox`.

## Parameters

`SPSwitch(_ label:isChecked:showsLabel:)`

| Name | Type | Default | Angular | Notes |
|---|---|---|---|---|
| `label` | `String` | required | (none) | Shown leading. Always read by VoiceOver. The web switch has no label. |
| `isChecked` | `Binding<Bool>` | required | `checked`, `checkedChange` | |
| `showsLabel` | `Bool` | `true` | (none) | `false` hides the text visually only. |

Disable with `.disabled(true)`.

## Behavior

- Built on `Toggle`, with a native toggle as its accessibility representation: VoiceOver reads "Paperless statements, switch button, on".
- Tapping anywhere on the row toggles it.
- The row fills the available width.

## Gotchas

- The disabled track is very light in light mode (`--color-control-track-disabled` is `neutral-20` on white). This matches the web.

## Example

```swift
VStack(spacing: 0) {
    SPSwitch("Paperless statements", isChecked: $paperless)
        .padding(.vertical, SPSpacing.md)
    Divider().overlay(SPColor.borderSubtle)
    SPSwitch("Push notifications", isChecked: $push)
        .padding(.vertical, SPSpacing.md)
}
```

## Related

`SPCheckbox` for choices saved on submit.
