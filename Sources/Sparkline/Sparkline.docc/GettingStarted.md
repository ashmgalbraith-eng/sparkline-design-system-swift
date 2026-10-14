# Getting Started

Add Sparkline to an app, register its fonts, and build your first screen.

## Add the package

In Xcode choose **File › Add Package Dependencies…**, then **Add Local…** and pick the `sparkline-design-system-swift` folder (or enter its Git URL). Add the **Sparkline** library to your app target.

In a `Package.swift`:

```swift
dependencies: [
    .package(path: "../sparkline-design-system-swift"),
],
targets: [
    .target(name: "MyFeature", dependencies: [
        .product(name: "Sparkline", package: "sparkline-design-system-swift"),
    ]),
]
```

Sparkline requires iOS 18 or later.

## Register the fonts

Sparkline uses Roboto (and Manrope for marketing headings). Register the bundled font files once when your app launches:

```swift
@main
struct MyApp: App {
    init() { SPFonts.register() }

    var body: some Scene {
        WindowGroup { ContentView() }
    }
}
```

If the fonts are missing, text falls back to the system font and nothing breaks.

## Follow the conventions

- Values are bindings: `SPCheckbox("…", isOn: $agreed)`, `SPInput("Email", text: $email)`.
- Actions are closures: `SPButton("Continue") { next() }`.
- Disabled state is the standard `.disabled(_:)` modifier.
- Style your own views with semantic tokens only: `Color.sp…`, ``SPSpacing``, ``SPRadius``, `.spShadow(_:)`, `.spTextStyle(_:)`.
- Light and dark mode follow the system. Use `.preferredColorScheme(_:)` to force one.

## Explore the catalog

Open `Sparkline.xcworkspace` and run **SparklineCatalog** on an iPhone or iPad simulator. Every component has a playground with live controls, plus its variants and states. The toolbar switches between light and dark mode and Dynamic Type sizes.
