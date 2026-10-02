# Release Notes

Changes to the Sparkline Swift package, the web repository and the Figma libraries.

See <doc:VersioningAndReleases> for what Patch, Minor and Major mean.

## Swift package

### v1.0.0: Major (iOS)

- Initial SwiftUI release for iOS and iPadOS, ported from web v4.2.0.
- 14 components: Avatar, Badge, Button, ButtonGroup, Card, Checkbox, Chip, Icon, Input, Radio, Select, Slider, Stepper, Switch.
- 46 semantic color tokens and 62 icons, generated from the web design system's CSS and icon registry.
- Catalog app replaces Storybook; DocC replaces the MDX documentation; `USAGE.md` and `llms.txt` docs for AI agents.

## Web repository

| Version | Date | Type | Changes |
|---|---|---|---|
| v4.2.0 | Jun 4, 2026 | Minor | Added Switch, Select, Radio, Stepper, Slider and Card with MDX docs; upgraded to Storybook 10 and Angular 21; rebuilt the Storybook config. |
| v3.1.0 | Feb 23, 2026 | Minor | Centralized icon system with 62 icons, a shared Icon component and gallery; added Switch. |
| v3.0.1 | Feb 12, 2026 | Patch | Removed a duplicate legacy components directory that caused conflicting stories. |
| v3.0.0 | Feb 12, 2026 | Major | Added Chip and Input; renamed exported token constants to the semantic naming convention. |
| v2.0.0 | Feb 6, 2026 | Major | Rewrote the design system from React to Angular on Storybook 8; re-published Button. |
| v1.1.0 | Feb 11, 2026 | Minor | Added Avatar and Badge, ported from Figma. |
| v1.0.0 | Feb 3, 2026 | Major | Initial scaffold: Angular 19 + Storybook 8 with Button. |

## Figma libraries

| Version | Date | Type | Changes |
|---|---|---|---|
| v4.2.0 | Jun 4, 2026 | Minor | Published Switch, Select, Radio, Stepper and Slider with full variant properties; added Card; synced frames with the docs. |
| v3.1.0 | Feb 23, 2026 | Minor | Published the 62-icon library at 24×24; added Switch variants. |
| v3.0.1 | Feb 12, 2026 | Patch | Corrected the Input error border color; fixed Chip corner radius. |
| v3.0.0 | Feb 12, 2026 | Major | Published Chip and Input; renamed primitive color tokens to the semantic structure. |
| v2.0.0 | Feb 11, 2026 | Major | Published Avatar and Badge; restructured into Foundations, Components and Resources. |
| v1.0.0 | Feb 3, 2026 | Major | Initial publish with Button and primitive/semantic color tokens. |
