# Typography

Text styles built on Roboto that scale with Dynamic Type and step up on iPad.

## Overview

Sparkline's type scale has eleven named styles. Apply one with `.spTextStyle(_:)`, which sets the font, weight, line height and letter spacing together:

```swift
Text("Open a CD")
    .spTextStyle(.headline4)
    .foregroundStyle(.spTextPrimary)
```

## The scale

| Style | Compact (iPhone) | Regular (iPad) | Weight |
|---|---|---|---|
| `.display` | 40 / 46 | 48 / 52.8 | Extra Bold |
| `.headline1` | 32 / 38.4, −0.5 tracking | 40 / 46, −1 tracking | Bold |
| `.headline2` | 24 / 30 | 32 / 38.4, −0.5 tracking | Bold |
| `.headline3` | 20 | 24 | Bold |
| `.headline4` | 20 | 20 | Bold |
| `.subtitle1` | 18 | 18 | Bold |
| `.label` | 16 | 16 | Bold |
| `.body1` | 16 / 24 | 16 / 24 | Regular |
| `.body2` | 14 / 20 | 14 / 20 | Regular |
| `.button` | 16 | 16 | Bold |
| `.caption` | 12 | 12 | Regular |

Sizes are size / line height in points. The compact column matches the web's mobile values and the regular column its tablet (`md`) breakpoint, chosen from the horizontal size class.

## Dynamic Type

Every style is built with `Font.custom(_:size:relativeTo:)`, so it grows and shrinks with the user's text size setting. Design layouts that let text wrap and controls grow taller.

## Families

``SPFontFamily/primary`` (Roboto) is used by every style. ``SPFontFamily/secondary`` (Manrope) is available for marketing headings:

```swift
Text("Grow your savings")
    .spTextStyle(.display, family: .secondary)
```

Call ``SPFonts/register()`` once at launch so the bundled fonts are available.
