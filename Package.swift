// swift-tools-version: 6.0
import PackageDescription

// Sparkline ships for iOS and iPadOS. The macOS platform entry exists only so
// `swift build` can type-check the package on a Mac without the iOS SDK; the
// components are designed and tested for iOS.
let package = Package(
    name: "Sparkline",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
    ],
    products: [
        .library(name: "Sparkline", targets: ["Sparkline"]),
    ],
    targets: [
        .target(
            name: "Sparkline",
            // Agent docs live next to each component but are not compiled or bundled.
            exclude: [
                "Components/Avatar/USAGE.md",
                "Components/Badge/USAGE.md",
                "Components/Button/USAGE.md",
                "Components/ButtonGroup/USAGE.md",
                "Components/Card/USAGE.md",
                "Components/Checkbox/USAGE.md",
                "Components/Chip/USAGE.md",
                "Components/Icon/USAGE.md",
                "Components/Input/USAGE.md",
                "Components/Radio/USAGE.md",
                "Components/Select/USAGE.md",
                "Components/Slider/USAGE.md",
                "Components/Stepper/USAGE.md",
                "Components/Switch/USAGE.md",
            ],
            resources: [
                .copy("Resources/Fonts"),
            ]
        ),
        .testTarget(
            name: "SparklineTests",
            dependencies: ["Sparkline"]
        ),
    ]
)
