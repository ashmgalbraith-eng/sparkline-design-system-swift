# Select

`SPSelect` is a dropdown for choosing one option, or several. The trigger is styled by Sparkline; the option list is the system menu.

```swift
import Sparkline
```

## Use it for

- Picking from a known list of four or more options (states, terms, account types).
- Multi-select filters, shown as removable chips in the trigger.

## Don't use it for

- Two or three options that should all be visible. Use `SPRadioGroup` or `SPButtonGroup`.
- Free text or search-as-you-type. Use `SPInput`.

## Parameters

Single: `SPSelect(_ label:value: Binding<Value?>, options:placeholder:helperText:errorText:state:)`
Multiple: the same with `value: Binding<Set<Value>>`.

| Name | Type | Default | Angular | Notes |
|---|---|---|---|---|
| `label` | `String` | required | `label` | Shown above the trigger and used as the VoiceOver label. |
| `value` | `Binding<Value?>` or `Binding<Set<Value>>` | required | `value`, `multiple`, `valueChange` | The binding type picks single or multiple. `Value` is any `Hashable`, so ints and enums work directly. |
| `options` | `[SPSelectOption<Value>]` | required | `options` | `.init(value, label:isDisabled:)`, in display order. |
| `placeholder` | `String` | `"Select an option"` | `placeholder` | Shown when nothing is selected. |
| `helperText` | `String` | `""` | `helperText` | Hidden in `.error`. |
| `errorText` | `String` | `""` | `errorText` | Shown only in `.error`. |
| `state` | `SPSelectState` | `.default` | `state` | `.default` or `.error`. The web's `'disabled'` state is `.disabled(true)`. |

Disable with `.disabled(true)`.

## Behavior

- The list is a native `Menu`, so it gets system keyboard, pointer and VoiceOver support and is never clipped by a parent.
- Single selection shows a checkmark on the chosen option and closes on pick.
- Multiple selection shows checkmarks, stays open while you pick (iOS), and shows chips in option order. Each chip has a "Remove <label>" button.

## Gotchas

- The menu's look is the system's, not the web panel's. Only the trigger uses Sparkline styling.
- The trigger has no focused/open highlight, because SwiftUI does not report when a `Menu` is open.

## Example

```swift
@State private var term: Int? = 12

SPSelect("Term length", value: $term, options: [
    .init(6, label: "6 months"),
    .init(12, label: "12 months"),
    .init(24, label: "24 months"),
], placeholder: "Select term length")
```

## Related

`SPRadioGroup` and `SPButtonGroup` for short lists. `SPChip` for standalone tags.
