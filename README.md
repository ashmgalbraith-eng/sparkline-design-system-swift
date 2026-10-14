# Sparkline Design System for SwiftUI

The iOS and iPadOS version of the Sparkline Design System: semantic tokens, 62 icons and 14 SwiftUI components, with a catalog app and DocC documentation.

| | |
|---|---|
| Platforms | iOS 18+, iPadOS 18+ |
| Tooling | Xcode 27, Swift 6 |
| Components | Avatar, Badge, Button, ButtonGroup, Card, Checkbox, Chip, Icon, Input, Radio, Select, Slider, Stepper, Switch |

## Install

Add the package in Xcode (**File › Add Package Dependencies… › Add Local…**), or in `Package.swift`:

```swift
.package(path: "../sparkline-design-system-swift")
```

Then register the fonts once at launch:

```swift
@main
struct MyApp: App {
    init() { SPFonts.register() }
    var body: some Scene { WindowGroup { ContentView() } }
}
```

## Use

```swift
import Sparkline

SPInput("Email", value: $email, type: .email)
SPCheckbox("I agree to the account disclosures", isChecked: $agreed)
SPButton("Open account", isFullWidth: true) { submit() }
    .disabled(!agreed)
```

Style your own views with tokens: `.foregroundStyle(SPColor.textPrimary)`, `.padding(SPSpacing.md)`, `.spType(.headline4)`.

## Explore

- **Catalog app:** open `Sparkline.xcworkspace` and run it on an iPhone or iPad simulator. It replaces Storybook: every component has a playground with live controls, plus variants and states, with light/dark and Dynamic Type switches.
- **Documentation:** open `Package.swift` in Xcode and choose **Product › Build Documentation**.
- **For AI agents:** start at [`llms.txt`](llms.txt).

## Keeping in sync with the web design system

Tokens and icons are generated from the Angular repo (`../sparkline-design-system`) under the same names (`--color-surface-brand` is `SPColor.surfaceBrand`), and every Angular input is mapped to its Swift parameter in [`docs/parity.md`](docs/parity.md):

```bash
node scripts/generate-tokens.mjs
node scripts/generate-icons.mjs
node scripts/check-parity.mjs
node scripts/build-agent-docs.mjs
```

See [CLAUDE.md](CLAUDE.md) for conventions.
