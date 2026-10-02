# CLAUDE.md - Sparkline Design System for SwiftUI

This file provides guidance for Claude Code when working with this codebase.

## Project Overview

Sparkline for SwiftUI is the iOS and iPadOS version of the Sparkline Design System, distributed as a Swift package. It is a port of the Angular library in `../sparkline-design-system`, which stays the source of truth for color tokens and icons.

## Tech Stack

- **Language**: Swift 6 (strict concurrency)
- **UI**: SwiftUI, iOS 18+ (the package also declares macOS 15 only so `swift build` can type-check without the iOS SDK)
- **IDE**: Xcode 27
- **Docs**: DocC (`Sources/Sparkline/Sparkline.docc`), the Catalog app (replaces Storybook), and agent docs (`llms.txt`, `USAGE.md`)
- **Tests**: Swift Testing (`Tests/SparklineTests`)

## Commands

```bash
node scripts/generate-tokens.mjs   # regenerate colors from ../sparkline-design-system/src/styles/global.css
node scripts/generate-icons.mjs    # regenerate icons from ../sparkline-design-system/src/app/components/icon/icon-registry.ts
node scripts/build-agent-docs.mjs  # regenerate llms.txt and the DocC component articles from USAGE.md files
swift build                        # type-check the package (macOS host)
```

In Xcode: open `Package.swift` for the library (previews, tests, Product › Build Documentation), or `Catalog/SparklineCatalog.xcodeproj` to run the catalog app in the simulator.

## Project Structure

```
sparkline-design-system-swift/
├── Package.swift
├── Sources/Sparkline/
│   ├── Tokens/                  # SPColor+Generated.swift (generated), SPLayout.swift, SPTypography.swift
│   ├── Components/<Name>/       # SP<Name>.swift + USAGE.md, one folder per component
│   │   └── Icon/                # SPIcon.swift + SPIconName+Generated.swift (generated)
│   ├── Support/                 # Color+Dynamic, SPInteractionState, SPFlowLayout
│   ├── Resources/Fonts/         # Roboto + Manrope TTFs, registered by SPFonts.register()
│   └── Sparkline.docc/          # DocC catalog; Components/*Article.md are generated
├── Tests/SparklineTests/
├── Catalog/                     # SparklineCatalog.xcodeproj + SparklineCatalog/ (synchronized folder)
├── docs/agents/                 # building-with-sparkline.md, tokens.md
├── scripts/                     # generators (Node, no dependencies)
└── llms.txt                     # generated
```

## Generated files: never edit by hand

- `Sources/Sparkline/Tokens/SPColor+Generated.swift`
- `Sources/Sparkline/Components/Icon/SPIconName+Generated.swift`
- `Sources/Sparkline/Sparkline.docc/Components/*Article.md`
- `llms.txt`

Change the source (web CSS, web icon registry, or `USAGE.md`) and re-run the script.

## Component Conventions

- Public types use the `SP` prefix: `SPButton`, `SPSelect`. Generic components hoist non-generic option enums to top level (`SPButtonGroupSize`, `SPCardVariant`) so callers can name them.
- Visual options are nested `enum`s that are `String, CaseIterable, Sendable` (`SPButton.Variant`), so the catalog can list them.
- Values are `Binding`s (`isOn:`, `text:`, `selection:`, `value:`); actions are closures; disabled comes from `@Environment(\.isEnabled)` (`.disabled(_:)`), never a `state: .disabled` parameter.
- Build on native controls (`Button` + `ButtonStyle`, `Toggle` + `ToggleStyle`, `Menu`) so accessibility comes for free. Custom-drawn controls must provide `.accessibilityRepresentation` (see `SPSlider`).
- Hover, pressed and focus come from `.onHover`, `configuration.isPressed` and `@Environment(\.isFocused)`, resolved by `SPInteractionResolver`. Support `.spInteractionState(_:)` so the catalog can pin states.
- Every component file ends with a `PreviewProvider` (not `#Preview`; the macro needs Xcode's plugin and would break `swift build` with the Command Line Tools).
- Every public initializer has `///` docs with a `- Parameters:` list.

## Styling Rule (enforced)

Component code uses semantic tokens only: `Color.sp…` / `.spName`, `SPSpacing`, `SPRadius`, `.spShadow(_:)`, `.spTextStyle(_:)`. No literal colors and no primitive palette (`SPPrimitive`) in components. The one exception is `Color.spFocusRing` (`--primary-30`) for focus rings. Literal point sizes are allowed only for component geometry that the web also hardcodes (control heights, icon sizes, track widths).

## Documentation

**When you change a component's parameters or behavior, update its `USAGE.md` in the same change, then run `node scripts/build-agent-docs.mjs`.** Document what the code actually does, including limitations. A new component needs: a folder under `Components/`, a `USAGE.md`, an entry in `exclude:` in `Package.swift`, an entry in the `symbols` map in `build-agent-docs.mjs`, a link in `Sparkline.docc/Sparkline.md`, and a page in the Catalog (`CatalogPage` + a `ComponentPage`).

## Known token issues (inherited from the web CSS)

- Dark: `spTextOnDisabled` = `spSurfaceDisabled` (neutral-70), so disabled filled buttons have unreadable labels.
- Light: `spTextDisabled` = `spSurfaceDisabled` (neutral-40), so disabled ButtonGroup labels are unreadable.
- Dark: elevated `SPCard` on `spSurfaceDefault` has no visible edge.

Fix these in the web tokens and regenerate; do not patch around them in Swift.
