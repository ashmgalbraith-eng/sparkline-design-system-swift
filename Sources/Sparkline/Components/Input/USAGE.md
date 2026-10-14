# Input

`SPInput` is a single-line text field with a label, helper or error text, and optional icons. It binds to a `String`.

```swift
import Sparkline
```

## Use it for

- Any free-text entry: names, addresses, email, phone, amounts, search.

## Don't use it for

- Choosing from a known list. Use `SPSelect`.
- Multi-line text. Sparkline has no text area yet; use `TextField(axis: .vertical)` styled with tokens and note the gap.
- Passwords that need a show/hide toggle. The right icon is not tappable; build the toggle locally and note the gap.

## Parameters

`SPInput(_ label:value:placeholder:helperText:errorText:state:showsOptional:type:leftIcon:rightIcon:)`

Arguments after `value` are optional but must keep this order.

| Name | Type | Default | Angular | Notes |
|---|---|---|---|---|
| `label` | `String` | required | `label` | Shown above the field and used as the VoiceOver label. |
| `value` | `Binding<String>` | required | `valueChange` | The field's text. |
| `placeholder` | `String` | `""` | `placeholder` | Shown while empty. (The web default is "Placeholder".) |
| `helperText` | `String` | `""` | `helperText` | Below the field. Hidden in `.error`; green in `.success`. Read as the VoiceOver hint. |
| `errorText` | `String` | `""` | `errorText` | Shown only in `.error`. Read as the VoiceOver hint. |
| `state` | `SPInputState` | `.default` | `state` | `.default`, `.error`, `.success`. Focus and disabled are automatic. |
| `showsOptional` | `Bool` | `false` | `showOptional` | Appends "(optional)" to the label. |
| `type` | `SPInputType` | `.text` | `type` | `.text`, `.email`, `.phone`, `.number`, `.decimal`, `.password`, `.url`. Sets the keyboard, autofill and autocorrection; `.password` uses a `SecureField`. |
| `leftIcon` / `rightIcon` | `SPIconName?` | `nil` | `showLeftIcon` + `leftIconName`, `showRightIcon` + `rightIconName` | Decorative. `nil` hides it. |

Disable with `.disabled(true)`.

## Behavior

- **It fills the width of its container** (the web input is fixed at 213px). Constrain it with `.frame(maxWidth:)`.
- Tapping anywhere in the field box focuses it.
- In `.error`, an alert icon appears on the right unless you set `rightIcon`.

## Gotchas

- To move focus between fields, use your own `@FocusState` on a wrapper; `SPInput` manages its own focus internally and does not take a focus binding.
- Validation is up to you: set `state` from your own checks.

## Example

```swift
SPInput("Email", value: $email,
        placeholder: "name@example.com",
        errorText: "Enter a valid email address",
        state: emailInvalid ? .error : .default,
        type: .email,
        leftIcon: .emailOutline)
```

## Related

`SPSelect` for list choices. `SPIcon` for icon names.
