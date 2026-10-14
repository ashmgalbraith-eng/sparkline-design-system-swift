# Stepper

`SPStepper` is a progress indicator for multi-step flows: numbered steps with labels, horizontal or vertical. Display only. (Not SwiftUI's `Stepper`, which is a +/- control.)

```swift
import Sparkline
```

## Use it for

- Showing where the user is in a flow with three to six steps (account opening, applications).
- A vertical checklist of steps with descriptions.

## Don't use it for

- Navigation. Steps are not tappable.
- Narrow screens with many steps. The horizontal stepper shows every label, which gets crowded on iPhone. A compact mobile stepper is a known gap; build it locally and note it.

## Parameters

`SPStepper(steps:activeStep:orientation:)`

| Name | Type | Default | Angular | Notes |
|---|---|---|---|---|
| `steps` | `[SPStepperStep]` | required | `steps` | `.init(label, description:state:)`. |
| `activeStep` | `Int` | `0` | `activeStep` | Zero-based. Earlier steps show as completed, later ones as pending. |
| `orientation` | `SPStepperOrientation` | `.horizontal` | `orientation` | `.horizontal` or `.vertical`. |

`SPStepState` is `.pending`, `.active`, `.completed` or `.error`. Setting `state` on a step overrides the automatic state, e.g. to flag an error.

## Behavior

- Each step is one VoiceOver element: "Step 2 of 5, Personal info, current".
- Changing `activeStep` animates the indicators and connectors.
- Horizontal: the indicator sits at the leading edge of each column with the connector running to the next step, and the label is centered below (as on the web).

## Gotchas

- `activeStep` is zero-based: the second step is `1`.

## Example

```swift
SPStepper(steps: [
    .init("Choose CD"),
    .init("Personal info"),
    .init("Verify identity"),
    .init("Fund account"),
    .init("Review"),
], activeStep: 1)
```

## Related

`SPButton` for the Back / Continue actions that move between steps.
