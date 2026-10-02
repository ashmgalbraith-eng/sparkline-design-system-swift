# Spacing, Shape and Elevation

The spacing scale, corner radii and shadows.

## Spacing

``SPSpacing`` is a 4-point scale. Use it for padding, stack spacing and offsets.

| Token | Value |
|---|---|
| `SPSpacing.xs` | 4pt |
| `SPSpacing.sm` | 8pt |
| `SPSpacing.md` | 16pt |
| `SPSpacing.lg` | 24pt |
| `SPSpacing.xl` | 32pt |

For larger gaps, combine tokens (`SPSpacing.xl * 2`) rather than writing a new number.

## Shape

``SPRadius`` defines corner rounding.

| Token | Value | Typical use |
|---|---|---|
| `SPRadius.sm` | 2pt | Checkbox boxes |
| `SPRadius.md` | 4pt | Buttons, inputs, selects |
| `SPRadius.lg` | 8pt | Focused chips, tiles |
| `SPRadius.xl` | 12pt | Cards |
| `SPRadius.full` | 999pt | Pills, avatars, pressed buttons |

Borders are 1pt for fields and outlined surfaces, 1.5pt for select triggers and badges, and 2pt for checkboxes, radios, step indicators and button groups.

## Elevation

``SPShadow`` provides four shadows, applied with `.spShadow(_:)`:

- `.button`: buttons and control thumbs only.
- `.sm`, `.md`, `.lg`: raised surfaces, from subtle to prominent. Elevated cards use `.md`.

CSS shadows with negative spread have no exact SwiftUI equivalent; the Swift values are tuned to look the same.
