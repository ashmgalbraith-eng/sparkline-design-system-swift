# Iconography

The 62-icon Sparkline set, drawn as vector paths.

## Overview

Icons are drawn on a 24×24 grid. ``SPIconName`` has one case per icon, with raw values matching the web registry keys (`help-circle-outline` is `.helpCircleOutline`). Because names are an enum, an unknown icon is a compile error.

```swift
SPIcon(.bellOutline, size: 20)
    .foregroundStyle(.spTextSecondary)
```

## Generated from the web registry

`scripts/generate-icons.mjs` reads `icon-registry.ts` from the web design system, converts each SVG path (including arcs) to Bézier curves, and writes `SPIconName+Generated.swift`. Nothing is parsed at runtime, and icons stay sharp at any size. After the web registry changes, run:

```sh
node scripts/generate-icons.mjs
```

## Guidelines

- Use 16, 20, 24 or 32pt.
- Color icons with semantic text tokens (`spTextPrimary`, `spTextBrand`, `spTextError`).
- Give an icon an accessibility label only when it carries meaning on its own; otherwise it is hidden from VoiceOver.
- Use ``SPIconShape`` when you need an icon as a `Shape` (for example, to stroke it).

The Catalog app's **Icon Gallery** page shows every icon with search.
