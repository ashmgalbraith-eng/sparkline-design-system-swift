# Angular ↔ Swift parity

Generated from `parity.json` by `scripts/check-parity.mjs`. Do not edit by hand.

Every input and output of the Angular library, and its Swift equivalent. Names match where Swift allows;
booleans read as `is…`/`shows…`, values are Bindings, and disabled is the standard `.disabled(_:)` modifier.
"Native" means iOS provides it without a parameter.

## avatar → `SPAvatar`

| Angular | Swift | Notes |
|---|---|---|
| `size` | `size` |  |
| `type` | `type` | `.text(initials)`, `.image(Image)`, `.imageURL(URL?)`, `.icon`. |
| `initials` | `type` | Carried by `.text(initials)`. |
| `imageSrc` | `type` | Carried by `.imageURL(url)`, or `.image(Image)` for a local image. |
| `imageAlt` | `accessibilityLabel` | Labels every type, not only images. |
| `showNotification` | `notificationCount` | A count shows the badge; `nil` hides it. |
| `notificationCount` | `notificationCount` |  |
| `showStatus` | `statusColor` | A color shows the dot; `nil` hides it. |
| `statusColor` | `statusColor` |  |

## badge → `SPBadge`

| Angular | Swift | Notes |
|---|---|---|
| `label` | `label (first argument)` |  |
| `type` | `type` |  |
| `status` | `status` |  |

## button → `SPButton`

| Angular | Swift | Notes |
|---|---|---|
| `label` | `label (first argument)` |  |
| `type` | `type` |  |
| `size` | `size` |  |
| `state` | Native | Hover, pressed and focus come from the system. Disabled is `.disabled(_:)`. |
| `showLeftIcon` | `leftIcon` | An icon shows it; `nil` hides it. |
| `leftIconName` | `leftIcon` |  |
| `showRightIcon` | `rightIcon` | An icon shows it; `nil` hides it. |
| `rightIconName` | `rightIcon` |  |
| `showText` | `showsText` |  |
| `buttonClick` (output) | `action` | Trailing closure. |

## button-group → `SPButtonGroup`

| Angular | Swift | Notes |
|---|---|---|
| `items` | `items` | `Item(value, label:leftIcon:rightIcon:)`. |
| `size` | `size` |  |
| `showLeftIcon` | `leftIcon` | Set per item. |
| `showRightIcon` | `rightIcon` | Set per item. |
| `showLabel` | `showsLabel` |  |
| `disabled` | Native | `.disabled(_:)`. |
| `activeIndex` | `selection` | A Binding to the selected item's value. |
| `selectionChange` (output) | `selection` | The Binding updates on tap. |

## card → `SPCard`

| Angular | Swift | Notes |
|---|---|---|
| `variant` | `variant` |  |
| `padding` | `padding` |  |

## checkbox → `SPCheckbox`

| Angular | Swift | Notes |
|---|---|---|
| `checked` | `isChecked` | A Binding. |
| `indeterminate` | `isIndeterminate` |  |
| `label` | `label (first argument)` |  |
| `disabled` | Native | `.disabled(_:)`. |
| `checkedChange` (output) | `isChecked` | The Binding updates on tap. |

## chip → `SPChip`

| Angular | Swift | Notes |
|---|---|---|
| `label` | `label (first argument)` |  |
| `type` | `onRemove` | Passing `onRemove` makes the chip clearable. |
| `state` | Native | Hover, pressed and focus come from the system. Disabled is `.disabled(_:)`. |
| `showLeftIcon` | `leftIcon` | An icon shows it; `nil` hides it. |
| `leftIconName` | `leftIcon` |  |
| `showRightIcon` | `rightIcon` | An icon shows it; `nil` hides it. |
| `rightIconName` | `rightIcon` |  |
| `removed` (output) | `onRemove` |  |

## icon → `SPIcon`

| Angular | Swift | Notes |
|---|---|---|
| `name` | `name (first argument)` |  |
| `size` | `size` |  |
| `color` | Native | `.foregroundStyle(_:)`, like any SwiftUI view. |

## input → `SPInput`

| Angular | Swift | Notes |
|---|---|---|
| `label` | `label (first argument)` |  |
| `placeholder` | `placeholder` |  |
| `helperText` | `helperText` |  |
| `errorText` | `errorText` |  |
| `state` | `state` | `.default`, `.error`, `.success`. Focus and disabled are native. |
| `showOptional` | `showsOptional` |  |
| `type` | `type` |  |
| `showLeftIcon` | `leftIcon` | An icon shows it; `nil` hides it. |
| `leftIconName` | `leftIcon` |  |
| `showRightIcon` | `rightIcon` | An icon shows it; `nil` hides it. |
| `rightIconName` | `rightIcon` |  |
| `valueChange` (output) | `value` | A Binding. |

## radio → `SPRadio`

| Angular | Swift | Notes |
|---|---|---|
| `checked` | `isChecked` |  |
| `label` | `label (first argument)` |  |
| `disabled` | Native | `.disabled(_:)`. |
| `checkedChange` (output) | `action` | Or use `SPRadioGroup`, which manages the selection. |

## select → `SPSelect`

| Angular | Swift | Notes |
|---|---|---|
| `options` | `options` | `SPSelectOption(value, label:isDisabled:)`. |
| `value` | `value` | A Binding: `Value?` for one, `Set<Value>` for several. |
| `multiple` | `value` | Chosen by the Binding's type. |
| `placeholder` | `placeholder` |  |
| `label` | `label (first argument)` |  |
| `helperText` | `helperText` |  |
| `errorText` | `errorText` |  |
| `state` | `state` | `.default`, `.error`. Disabled is `.disabled(_:)`. |
| `valueChange` (output) | `value` | The Binding updates on selection. |

## slider → `SPSlider`

| Angular | Swift | Notes |
|---|---|---|
| `value` | `value` | A Binding. |
| `min` | `in range` | `in: min...max`. |
| `max` | `in range` | `in: min...max`. |
| `step` | `step` |  |
| `disabled` | Native | `.disabled(_:)`. |
| `showValue` | `showsValue` |  |
| `valueChange` (output) | `value` | The Binding updates while dragging. |

## stepper → `SPStepper`

| Angular | Swift | Notes |
|---|---|---|
| `steps` | `steps` | `SPStepperStep(label, description:state:)`. |
| `activeStep` | `activeStep` |  |
| `orientation` | `orientation` |  |

## switch → `SPSwitch`

| Angular | Swift | Notes |
|---|---|---|
| `checked` | `isChecked` | A Binding. Swift also requires a `label` for VoiceOver. |
| `disabled` | Native | `.disabled(_:)`. |
| `checkedChange` (output) | `isChecked` | The Binding updates on tap. |
