# ``Sparkline``

SwiftUI components and design tokens for building Sparkline products on iOS and iPadOS.

## Overview

Sparkline for SwiftUI is the native counterpart of the Sparkline web design system. Colors and icons are generated from the same source files as the web library, so both platforms stay in sync. Components are built on native SwiftUI controls, so they support VoiceOver, Dynamic Type, Full Keyboard Access, pointer hover and dark mode.

```swift
import SwiftUI
import Sparkline

struct ConsentView: View {
    @State private var agreed = false

    var body: some View {
        VStack(alignment: .leading, spacing: SPSpacing.md) {
            Text("Review and agree")
                .spTextStyle(.headline4)
                .foregroundStyle(.spTextPrimary)
            SPCheckbox("I have read the account disclosures", isOn: $agreed)
            SPButton("Open account", isFullWidth: true) { }
                .disabled(!agreed)
        }
        .padding(SPSpacing.lg)
    }
}
```

## Topics

### Essentials

- <doc:GettingStarted>

### Foundations

- <doc:Colors>
- <doc:Typography>
- <doc:SpacingShapeAndElevation>
- <doc:Iconography>

### Components

- <doc:AvatarArticle>
- <doc:BadgeArticle>
- <doc:ButtonArticle>
- <doc:ButtonGroupArticle>
- <doc:CardArticle>
- <doc:CheckboxArticle>
- <doc:ChipArticle>
- <doc:IconArticle>
- <doc:InputArticle>
- <doc:RadioArticle>
- <doc:SelectArticle>
- <doc:SliderArticle>
- <doc:StepperArticle>
- <doc:SwitchArticle>

### Design System Governance

- <doc:WorkingWithTheDesignSystem>
- <doc:CommunicationAndEnforcement>
- <doc:VersioningAndReleases>

### Resources

- <doc:PlanningAndRequests>
- <doc:ReleaseNotes>

### Actions

- ``SPButton``
- ``SPButtonStyle``
- ``SPButtonGroup``
- ``SPButtonGroupSize``
- ``SPChip``

### Selection and input

- ``SPCheckbox``
- ``SPRadioGroup``
- ``SPRadio``
- ``SPSwitch``
- ``SPSwitchToggleStyle``
- ``SPInput``
- ``SPSelect``
- ``SPSelectOption``
- ``SPSelectState``
- ``SPSlider``

### Display

- ``SPAvatar``
- ``SPBadge``
- ``SPCard``
- ``SPCardVariant``
- ``SPCardPadding``
- ``SPIcon``
- ``SPIconShape``
- ``SPIconName``
- ``SPStepper``

### Tokens

- ``SPColorToken``
- ``SPSpacing``
- ``SPRadius``
- ``SPShadow``
- ``SPTextStyle``
- ``SPFontFamily``
- ``SPFonts``

### Layout and states

- ``SPFlowLayout``
- ``SPInteractionState``
