# Slider

`SPSlider` is a range control for picking a number between a minimum and maximum.

```swift
import Sparkline
```

## Use it for

- Approximate values where exploring matters more than precision (a deposit amount in a savings calculator).

## Don't use it for

- Exact amounts the user must type. Use `SPInput` with `contentType: .decimal`, or pair the slider with one.
- A small set of named choices. Use `SPButtonGroup` or `SPRadioGroup`.

## Parameters

`SPSlider(_ label:value:in:step:showsValue:)`

| Name | Type | Default | Notes |
|---|---|---|---|
| `label` | `String` | required | VoiceOver label. Not shown; put a visible label above. |
| `value` | `Binding<Double>` | required | |
| `range` (`in:`) | `ClosedRange<Double>` | `0...100` | |
| `step` | `Double` | `1` | `0` for continuous values. |
| `showsValue` | `Bool` | `false` | Shows the raw number to the right, unformatted. |

Disable with `.disabled(true)`.

## Behavior

- Drag or tap anywhere on the track. Values snap to `step` and clamp to `range`.
- Its accessibility representation is a native `Slider`, so VoiceOver swipe up/down adjusts it by one step.
- It fills the available width.

## Gotchas

- Show a formatted value yourself (`$5,000`) instead of `showsValue`.
- A `value` outside `range` draws the thumb at the nearest end but is not changed until the user drags.

## Example

```swift
VStack(alignment: .leading, spacing: SPSpacing.sm) {
    Text("Deposit amount").spTextStyle(.body2).foregroundStyle(.spTextSecondary)
    Text(deposit, format: .currency(code: "USD").precision(.fractionLength(0)))
        .spTextStyle(.headline3)
    SPSlider("Deposit amount", value: $deposit, in: 500...50_000, step: 500)
}
```

## Related

`SPInput` for exact values.
