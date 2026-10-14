# Building an app with Sparkline

This guide is for AI coding agents (and people) building SwiftUI screens for iOS and iPadOS with the Sparkline Design System. Read it once before writing UI, then read the `USAGE.md` for each component you use.

## Setup (required)

1. **Add the package.** In Xcode: File › Add Package Dependencies… › Add Local… and choose the `sparkline-design-system-swift` folder (or its Git URL). Add the `Sparkline` library to your app target. In a `Package.swift`:
   ```swift
   .package(path: "../sparkline-design-system-swift"),
   // target dependency:
   .product(name: "Sparkline", package: "sparkline-design-system-swift"),
   ```
2. **Register the fonts once at launch.** Without this, text falls back to the system font.
   ```swift
   import SwiftUI
   import Sparkline

   @main
   struct MyApp: App {
       init() { SPFonts.register() }
       var body: some Scene { WindowGroup { ContentView() } }
   }
   ```
3. **Nothing else.** Colors follow the system light/dark setting automatically. To force a theme, use `.preferredColorScheme(.dark)`.

## Rules

- **Use a Sparkline component whenever one fits.** Check the component list in `llms.txt` before building anything yourself.
- **Style with semantic tokens only.** Colors: `SPColor` (`.foregroundStyle(SPColor.textPrimary)`). Spacing: `SPSpacing`. Radius: `SPRadius`. Shadows: `.spShadow(_:)`. Type: `.spType(_:)`. Never write literal colors (`Color(red:…)`, `.purple`, hex), and never hardcode spacing or radius numbers. See `tokens.md`.
- **Use the standard SwiftUI patterns the components are built for.** Values are `Binding`s (`$agreed`, `$email`, `$term`), actions are closures, and disabled state is `.disabled(_:)`. There is no `state: .disabled` parameter anywhere.
- **Icons come from `SPIconName`.** Names are an enum, so an unknown icon is a compile error. Color icons with `.foregroundStyle`.
- **Match the naming.** Sparkline types use the `SP` prefix. Do not prefix your own types with `SP`.
- **Do not restyle components from outside** beyond layout (`.frame`, `.padding`). If a component cannot do what you need, treat it as a gap (below).

## When the library does not have what you need

Build it in the app, not in the library, and keep it on-system:

- Compose it from existing components and tokens where you can (a card list is `SPCard` + `SPIcon` + `SPButton`).
- Style it with semantic tokens only, so it themes correctly and could be promoted later.
- Leave a short comment naming the gap, e.g. `// Not in Sparkline yet: bottom sheet`.
- Report the gap in your summary so the design system team can decide whether to add it.

Known gaps: app header, bottom sheet styling, sticky footer, compact mobile stepper, text area, rate and receipt cards, camera capture, help center / chat, marketing blocks, and a password field with a show/hide toggle.

## Accessibility

The Swift components are built on native controls, so most of the web gaps are closed:

- `SPButton`, `SPCheckbox`, `SPRadio`, `SPSwitch` and `SPButtonGroup` segments are real buttons/toggles: VoiceOver, Full Keyboard Access and Return/Space work.
- `SPInput` and `SPSelect` use their `label` as the VoiceOver label and their helper/error text as the hint.
- `SPSlider` is announced and adjusted as a native slider.
- `SPChip`'s remove control is a labelled button.

What you still have to do:

- Give `SPRadioGroup` and `SPSlider` a visible label; their `title`/`label` are VoiceOver-only.
- Add an `accessibilityLabel` to `SPIcon`s and `SPAvatar`s that carry meaning.
- Test with Dynamic Type at accessibility sizes; components grow, but your layouts must allow it.

## Checklist before you finish

- [ ] `SPFonts.register()` called once at launch
- [ ] Every control comes from Sparkline where one exists
- [ ] No literal colors, spacing or radii in app code
- [ ] Values bound with `Binding`s; disabled state via `.disabled(_:)`
- [ ] Gaps built locally are commented and listed in your summary
