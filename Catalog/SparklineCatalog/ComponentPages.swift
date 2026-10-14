import SwiftUI
import Sparkline

// Every page mirrors its Storybook stories: the playground is the Playground
// story, and each section is named after one story (Types, Sizes, States, …).

/// The photo the web Storybook uses for its Avatar stories.
private let sampleAvatarURL = URL(string: "https://i.pravatar.cc/96")

// MARK: - Actions

struct ButtonPage: View {
    @State private var label = "Button"
    @State private var type: SPButtonType = .filled
    @State private var size: SPButtonSize = .large
    @State private var leftIcon: SPIconName?
    @State private var rightIcon: SPIconName?
    @State private var showsText = true
    @State private var isFullWidth = false
    @State private var isDisabled = false
    @State private var taps = 0

    var body: some View {
        ComponentPage(summary: "Triggers an action. Filled is the primary action (one per view), outlined is secondary, text is tertiary or inline.") {
            VStack(spacing: SPSpacing.sm) {
                SPButton(label, type: type, size: size, leftIcon: leftIcon, rightIcon: rightIcon,
                         showsText: showsText, isFullWidth: isFullWidth) { taps += 1 }
                    .disabled(isDisabled)
                Text("Tapped \(taps)×").spType(.caption).foregroundStyle(SPColor.textSecondary)
            }
        } controls: {
            LabeledContent("Label") { TextField("Label", text: $label).frame(maxWidth: 240) }
            OptionPicker("Type", value: $type, options: SPButtonType.allCases)
            OptionPicker("Size", value: $size, options: SPButtonSize.allCases)
            IconPicker(title: "Left icon", icon: $leftIcon)
            IconPicker(title: "Right icon", icon: $rightIcon)
            Toggle("Shows text", isOn: $showsText)
            Toggle("Full width", isOn: $isFullWidth)
            Toggle("Disabled", isOn: $isDisabled)
        } sections: {
            CatalogSection("Types") {
                SpecimenRow {
                    ForEach(SPButtonType.allCases, id: \.self) { type in
                        Specimen(type.rawValue) { SPButton("Button", type: type) {} }
                    }
                }
            }
            CatalogSection("Sizes") {
                SpecimenRow {
                    ForEach(SPButtonSize.allCases, id: \.self) { size in
                        Specimen(size.rawValue) { SPButton("Button", size: size) {} }
                    }
                }
            }
            CatalogSection("States") {
                ForEach(SPButtonType.allCases, id: \.self) { type in
                    SpecimenRow {
                        ForEach(SPInteractionState.allCases, id: \.self) { state in
                            Specimen(state.rawValue) { SPButton("Button", type: type) {}.spInteractionState(state) }
                        }
                        Specimen("disabled") { SPButton("Button", type: type) {}.disabled(true) }
                    }
                }
            }
            CatalogSection("With icons") {
                SpecimenRow {
                    Specimen("left icon") { SPButton("Back", type: .outlined, leftIcon: .arrowLeft) {} }
                    Specimen("right icon") { SPButton("Next", rightIcon: .arrowRight) {} }
                    Specimen("icon only") { SPButton("Add", leftIcon: .plusCircleOutline, showsText: false) {} }
                }
            }
        }
    }
}

struct ButtonGroupPage: View {
    @State private var selection = 0
    @State private var count = 3
    @State private var size: SPButtonGroupSize = .large
    @State private var showsLabel = true
    @State private var showsLeftIcon = false
    @State private var showsRightIcon = false
    @State private var isDisabled = false

    private func items(_ n: Int, leftIcon: Bool = false, rightIcon: Bool = false) -> [SPButtonGroup<Int>.Item] {
        (0..<n).map {
            .init($0, label: "Option \($0 + 1)",
                  leftIcon: leftIcon ? .arrowLeft : nil,
                  rightIcon: rightIcon ? .arrowRight : nil)
        }
    }

    var body: some View {
        ComponentPage(summary: "A segmented control: connected buttons where exactly one is selected. For switching between two to four short views or modes.") {
            SPButtonGroup(selection: $selection, items: items(count, leftIcon: showsLeftIcon, rightIcon: showsRightIcon),
                          size: size, showsLabel: showsLabel)
                .disabled(isDisabled)
        } controls: {
            Stepper("Buttons: \(count)", value: $count, in: 2...5)
                .onChange(of: count) { selection = min(selection, count - 1) }
            OptionPicker("Size", value: $size, options: SPButtonGroupSize.allCases)
            Toggle("Shows label", isOn: $showsLabel)
            Toggle("Left icons", isOn: $showsLeftIcon)
            Toggle("Right icons", isOn: $showsRightIcon)
            Toggle("Disabled", isOn: $isDisabled)
        } sections: {
            CatalogSection("Sizes") {
                VStack(alignment: .leading, spacing: SPSpacing.md) {
                    ForEach(SPButtonGroupSize.allCases, id: \.self) { size in
                        Specimen(size.rawValue) { SPButtonGroup(selection: .constant(0), items: items(3), size: size) }
                    }
                }
            }
            CatalogSection("Icon variants") {
                VStack(alignment: .leading, spacing: SPSpacing.md) {
                    Specimen("left icons") { SPButtonGroup(selection: .constant(0), items: items(2, leftIcon: true)) }
                    Specimen("right icons") { SPButtonGroup(selection: .constant(0), items: items(2, rightIcon: true)) }
                    Specimen("icons only") {
                        SPButtonGroup(selection: .constant(0), items: [
                            .init(0, label: "List", leftIcon: .menu), .init(1, label: "Map", leftIcon: .mapMarkerOutline),
                        ], showsLabel: false)
                    }
                }
            }
            CatalogSection("Disabled") {
                SPButtonGroup(selection: .constant(0), items: items(3)).disabled(true)
            }
            CatalogSection("Button counts") {
                VStack(alignment: .leading, spacing: SPSpacing.md) {
                    ForEach(2...5, id: \.self) { n in
                        Specimen("\(n) buttons") {
                            SPButtonGroup(selection: .constant(0), items: (0..<n).map { .init($0, label: "Button") }, size: .small)
                        }
                    }
                }
            }
        }
    }
}

struct ChipPage: View {
    @State private var label = "Chip"
    @State private var clearable = false
    @State private var leftIcon: SPIconName?
    @State private var rightIcon: SPIconName?
    @State private var isDisabled = false
    @State private var filters = ["Savings", "CDs", "12 months", "No minimum"]

    var body: some View {
        ComponentPage(summary: "A compact pill for a tag, filter or selection. Pass onRemove to make it clearable.") {
            if clearable {
                SPChip(label, leftIcon: leftIcon, onRemove: {}).disabled(isDisabled)
            } else {
                SPChip(label, leftIcon: leftIcon, rightIcon: rightIcon).disabled(isDisabled)
            }
        } controls: {
            LabeledContent("Label") { TextField("Label", text: $label).frame(maxWidth: 240) }
            Toggle("Clearable", isOn: $clearable)
            IconPicker(title: "Left icon", icon: $leftIcon)
            IconPicker(title: "Right icon", icon: $rightIcon)
            Toggle("Disabled", isOn: $isDisabled)
        } sections: {
            CatalogSection("Types") {
                SpecimenRow {
                    Specimen("plain") { SPChip("Chip") }
                    Specimen("plain, icons") { SPChip("Chip", leftIcon: .checkCircleOutline, rightIcon: .menuDownOutline) }
                    Specimen("clearable") { SPChip("Chip", onRemove: {}) }
                }
            }
            CatalogSection("States") {
                SpecimenRow {
                    ForEach(SPInteractionState.allCases, id: \.self) { state in
                        Specimen(state.rawValue) { SPChip("Chip").spInteractionState(state) }
                    }
                    Specimen("disabled") { SPChip("Chip", onRemove: {}).disabled(true) }
                }
            }
            CatalogSection("Removable filters") {
                SpecimenRow {
                    ForEach(filters, id: \.self) { filter in
                        SPChip(filter) { filters.removeAll { $0 == filter } }
                    }
                    SPButton("Reset", type: .text, size: .small) {
                        filters = ["Savings", "CDs", "12 months", "No minimum"]
                    }
                }
            }
        }
    }
}

// MARK: - Display

struct AvatarPage: View {
    private enum Kind: String, CaseIterable { case text, image, icon }

    @State private var kind = Kind.text
    @State private var initials = "AG"
    @State private var size: SPAvatarSize = .large
    @State private var showsStatus = false
    @State private var statusColor: SPBadgeStatus = .success
    @State private var showsNotification = false
    @State private var count = "3"

    private var type: SPAvatarType {
        switch kind {
        case .text: return .text(initials)
        case .image: return .imageURL(sampleAvatarURL)
        case .icon: return .icon
        }
    }

    var body: some View {
        ComponentPage(summary: "A small circular representation of a person: initials, a photo or the account icon, with an optional status dot or count.") {
            SPAvatar(type: type, size: size, statusColor: showsStatus ? statusColor : nil,
                     notificationCount: showsNotification ? count : nil, accessibilityLabel: "Ash Galbraith")
                .padding(SPSpacing.md)
        } controls: {
            OptionPicker("Type", value: $kind, options: Kind.allCases)
            LabeledContent("Initials") { TextField("Initials", text: $initials).frame(maxWidth: 120) }
            OptionPicker("Size", value: $size, options: SPAvatarSize.allCases)
            Toggle("Status", isOn: $showsStatus)
            OptionPicker("Status color", value: $statusColor, options: SPBadgeStatus.allCases)
            Toggle("Notification", isOn: $showsNotification)
            LabeledContent("Count") { TextField("Count", text: $count).frame(maxWidth: 120) }
        } sections: {
            CatalogSection("Sizes") {
                SpecimenRow {
                    ForEach(SPAvatarSize.allCases, id: \.self) { size in
                        Specimen(size.rawValue) { SPAvatar(type: .text("AG"), size: size) }
                    }
                }
            }
            CatalogSection("Types") {
                SpecimenRow {
                    Specimen("text") { SPAvatar(type: .text("AG"), size: .large) }
                    Specimen("image") { SPAvatar(type: .imageURL(sampleAvatarURL), size: .large) }
                    Specimen("icon") { SPAvatar(type: .icon, size: .large) }
                }
            }
            CatalogSection("With badge") {
                SpecimenRow {
                    ForEach(SPAvatarSize.allCases, id: \.self) { size in
                        Specimen(size.rawValue) {
                            SPAvatar(type: .imageURL(sampleAvatarURL), size: size, statusColor: .success, notificationCount: "999+")
                                .padding(.top, SPSpacing.md)
                                .padding(.trailing, SPSpacing.xl)
                        }
                    }
                }
            }
        }
    }
}

struct BadgePage: View {
    @State private var label = "9"
    @State private var type: SPBadgeType = .numeric
    @State private var status: SPBadgeStatus = .notification

    var body: some View {
        ComponentPage(summary: "A small status marker: a numeric count or a colored dot. Pair a dot with text; color alone carries its meaning.") {
            SPBadge(label, type: type, status: status)
        } controls: {
            LabeledContent("Label") { TextField("Label", text: $label).frame(maxWidth: 120) }
            OptionPicker("Type", value: $type, options: SPBadgeType.allCases)
            OptionPicker("Status", value: $status, options: SPBadgeStatus.allCases)
        } sections: {
            CatalogSection("Types") {
                SpecimenRow {
                    Specimen("numeric") { SPBadge("9") }
                    Specimen("numeric, long") { SPBadge("999+") }
                    Specimen("dot") { SPBadge.dot(.notification) }
                }
            }
            CatalogSection("Status colors") {
                SpecimenRow {
                    ForEach(SPBadgeStatus.allCases, id: \.self) { status in
                        Specimen(status.rawValue) { SPBadge("9", status: status) }
                    }
                    ForEach(SPBadgeStatus.allCases, id: \.self) { status in
                        Specimen(status.rawValue) { SPBadge.dot(status) }
                    }
                }
            }
            CatalogSection("On an icon") {
                SPIcon(.bellOutline)
                    .foregroundStyle(SPColor.textPrimary)
                    .overlay(alignment: .topTrailing) { SPBadge("3").offset(x: 10, y: -8) }
                    .padding(SPSpacing.md)
            }
        }
    }
}

struct CardPage: View {
    @State private var variant: SPCardVariant = .elevated
    @State private var padding: SPCardPadding = .md

    var body: some View {
        ComponentPage(summary: "A container surface for grouping related content. It draws only the surface; you supply the content.") {
            SPCard(variant: variant, padding: padding) {
                Text("12-month CD").spType(.subtitle1).foregroundStyle(SPColor.textPrimary)
                Text("4.85% APY · $500 minimum").spType(.body2).foregroundStyle(SPColor.textSecondary)
            }
            .frame(maxWidth: 360)
        } controls: {
            OptionPicker("Variant", value: $variant, options: SPCardVariant.allCases)
            OptionPicker("Padding", value: $padding, options: SPCardPadding.allCases)
        } sections: {
            CatalogSection("Variants") {
                SpecimenRow {
                    ForEach(SPCardVariant.allCases, id: \.self) { variant in
                        Specimen(variant.rawValue) {
                            SPCard(variant: variant) {
                                Text(variant.rawValue.capitalized).spType(.body1).foregroundStyle(SPColor.textPrimary)
                            }
                            .frame(width: 200)
                        }
                    }
                }
            }
            CatalogSection("Receipt (padding: none)") {
                SPCard(variant: .outlined, padding: .none) {
                    ForEach([("Term", "12 months"), ("APY", "4.85%"), ("Deposit", "$5,000")], id: \.0) { key, value in
                        HStack {
                            Text(key).foregroundStyle(SPColor.textSecondary)
                            Spacer()
                            Text(value).foregroundStyle(SPColor.textPrimary)
                        }
                        .spType(.body2)
                        .padding(SPSpacing.md)
                        if key != "Deposit" { Divider().overlay(SPColor.borderSubtle) }
                    }
                }
                .frame(maxWidth: 360)
            }
        }
    }
}

struct IconPage: View {
    @State private var icon: SPIconName? = .heartOutline
    @State private var size: Double = 24

    var body: some View {
        ComponentPage(summary: "Renders an icon from the Sparkline registry. It fills with the current foreground style. Every icon is in Foundations › Icon Gallery.") {
            SPIcon(icon ?? .check, size: size).foregroundStyle(SPColor.textBrand)
        } controls: {
            IconPicker(title: "Name", icon: $icon)
            LabeledContent("Size: \(Int(size))pt") { Slider(value: $size, in: 12...64, step: 4).frame(maxWidth: 240) }
        } sections: {
            CatalogSection("Sizes") {
                SpecimenRow {
                    ForEach([16, 20, 24, 32], id: \.self) { s in
                        Specimen("\(s)pt") { SPIcon(.bellOutline, size: CGFloat(s)).foregroundStyle(SPColor.textPrimary) }
                    }
                }
            }
            CatalogSection("Colors") {
                SpecimenRow {
                    Specimen("textPrimary") { SPIcon(.checkCircleOutline).foregroundStyle(SPColor.textPrimary) }
                    Specimen("textBrand") { SPIcon(.checkCircleOutline).foregroundStyle(SPColor.textBrand) }
                    Specimen("textSuccess") { SPIcon(.checkCircleOutline).foregroundStyle(SPColor.textSuccess) }
                    Specimen("textError") { SPIcon(.alertCircleOutline).foregroundStyle(SPColor.textError) }
                }
            }
        }
    }
}

struct StepperPage: View {
    @State private var activeStep = 1
    @State private var orientation: SPStepperOrientation = .horizontal
    @State private var flagError = false
    @State private var showsDescriptions = false

    private static let labels = ["Choose CD", "Personal info", "Verify identity", "Fund account", "Review"]
    private static let descriptions = ["12-month CD", "Name and address", "Upload ID", "Link a bank", "Confirm details"]

    private var steps: [SPStepperStep] {
        Self.labels.indices.map { i in
            SPStepperStep(Self.labels[i],
                          description: showsDescriptions ? Self.descriptions[i] : nil,
                          state: flagError && i == 2 ? .error : nil)
        }
    }

    var body: some View {
        ComponentPage(summary: "A progress indicator for multi-step flows. Display only; steps are not tappable.") {
            SPStepper(steps: steps, activeStep: activeStep, orientation: orientation)
        } controls: {
            Stepper("Active step: \(activeStep) (zero-based)", value: $activeStep, in: 0...4)
            OptionPicker("Orientation", value: $orientation, options: SPStepperOrientation.allCases)
            Toggle("Flag step 3 as error", isOn: $flagError)
            Toggle("Descriptions", isOn: $showsDescriptions)
        } sections: {
            CatalogSection("States") {
                SPStepper(steps: [
                    .init("Completed"), .init("Active"), .init("Error", state: .error), .init("Pending"),
                ], activeStep: 1)
            }
            CatalogSection("Vertical") {
                SPStepper(steps: Self.labels.indices.map { .init(Self.labels[$0], description: Self.descriptions[$0]) },
                          activeStep: 2, orientation: .vertical)
            }
            CatalogSection("With error") {
                SPStepper(steps: Self.labels.indices.map { .init(Self.labels[$0], state: $0 == 2 ? .error : nil) },
                          activeStep: 2)
            }
            CatalogSection("All completed") {
                SPStepper(steps: Self.labels.map { .init($0) }, activeStep: Self.labels.count)
            }
        }
    }
}

// MARK: - Inputs

struct CheckboxPage: View {
    @State private var label = "I agree to the account disclosures"
    @State private var isChecked = false
    @State private var isIndeterminate = false
    @State private var isDisabled = false
    @State private var children = [true, false, false]

    var body: some View {
        ComponentPage(summary: "A labeled checkbox for on/off choices and consent, with an indeterminate state for “select all”.") {
            SPCheckbox(label, isChecked: $isChecked, isIndeterminate: isIndeterminate)
                .disabled(isDisabled)
        } controls: {
            LabeledContent("Label") { TextField("Label", text: $label).frame(maxWidth: 320) }
            Toggle("Checked", isOn: $isChecked)
            Toggle("Indeterminate", isOn: $isIndeterminate)
            Toggle("Disabled", isOn: $isDisabled)
        } sections: {
            CatalogSection("All states") {
                SpecimenRow {
                    SPCheckbox("unchecked", isChecked: .constant(false))
                    SPCheckbox("checked", isChecked: .constant(true))
                    SPCheckbox("indeterminate", isChecked: .constant(false), isIndeterminate: true)
                    ForEach(SPInteractionState.allCases.filter { $0 != .default }, id: \.self) { state in
                        SPCheckbox(state.rawValue, isChecked: .constant(true)).spInteractionState(state)
                    }
                    SPCheckbox("disabled", isChecked: .constant(true)).disabled(true)
                    SPCheckbox("disabled", isChecked: .constant(false)).disabled(true)
                }
            }
            CatalogSection("Select all") {
                VStack(alignment: .leading, spacing: 0) {
                    SPCheckbox("All accounts",
                               isChecked: Binding(get: { children.allSatisfy { $0 } },
                                                  set: { on in children = children.map { _ in on } }),
                               isIndeterminate: children.contains(true) && children.contains(false))
                    ForEach(children.indices, id: \.self) { i in
                        SPCheckbox("Account \(i + 1)", isChecked: $children[i]).padding(.leading, SPSpacing.lg)
                    }
                }
            }
        }
    }
}

struct RadioPage: View {
    @State private var source = "bank"
    @State private var isDisabled = false
    @State private var disableLast = true

    var body: some View {
        ComponentPage(summary: "Radio buttons for choosing exactly one of two to five visible options. Use SPRadioGroup; it manages the selection.") {
            SPRadioGroup("Funding source", selection: $source, options: [
                .init("bank", label: "Transfer from another bank"),
                .init("check", label: "Mail a check"),
                .init("wire", label: "Wire transfer", isDisabled: disableLast),
            ])
            .disabled(isDisabled)
        } controls: {
            LabeledContent("Selection") { Text(source).foregroundStyle(SPColor.textSecondary) }
            Toggle("Disable last option", isOn: $disableLast)
            Toggle("Disable group", isOn: $isDisabled)
        } sections: {
            CatalogSection("States") {
                SpecimenRow {
                    SPRadio("unchecked", isChecked: false) {}
                    ForEach(SPInteractionState.allCases, id: \.self) { state in
                        SPRadio(state.rawValue, isChecked: true) {}.spInteractionState(state)
                    }
                    SPRadio("disabled", isChecked: true) {}.disabled(true)
                    SPRadio("disabled", isChecked: false) {}.disabled(true)
                }
            }
        }
    }
}

struct SwitchPage: View {
    @State private var label = "Paperless statements"
    @State private var isChecked = true
    @State private var showsLabel = true
    @State private var isDisabled = false

    var body: some View {
        ComponentPage(summary: "An on/off toggle for settings that apply immediately. Use a checkbox for choices saved on submit.") {
            SPSwitch(label, isChecked: $isChecked, showsLabel: showsLabel)
                .disabled(isDisabled)
                .frame(maxWidth: 360)
        } controls: {
            LabeledContent("Label") { TextField("Label", text: $label).frame(maxWidth: 240) }
            Toggle("Shows label", isOn: $showsLabel)
            Toggle("Disabled", isOn: $isDisabled)
        } sections: {
            CatalogSection("States") {
                VStack(spacing: SPSpacing.md) {
                    SPSwitch("On", isChecked: .constant(true))
                    SPSwitch("Off", isChecked: .constant(false))
                    SPSwitch("Disabled on", isChecked: .constant(true)).disabled(true)
                    SPSwitch("Disabled off", isChecked: .constant(false)).disabled(true)
                    Toggle("Plain Toggle with .toggleStyle(.sparkline)", isOn: .constant(true)).toggleStyle(.sparkline)
                }
                .frame(maxWidth: 420)
            }
        }
    }
}

struct InputPage: View {
    @State private var value = ""
    @State private var label = "Email"
    @State private var placeholder = "name@example.com"
    @State private var helperText = "We'll send your statements here"
    @State private var errorText = "Enter a valid email address"
    @State private var state: SPInputState = .default
    @State private var type: SPInputType = .email
    @State private var showsOptional = false
    @State private var leftIcon: SPIconName? = .emailOutline
    @State private var rightIcon: SPIconName?
    @State private var isDisabled = false

    var body: some View {
        ComponentPage(summary: "A single-line text field with a label, helper or error text, and optional icons. It fills the width of its container.") {
            SPInput(label, value: $value, placeholder: placeholder, helperText: helperText, errorText: errorText,
                    state: state, showsOptional: showsOptional, type: type, leftIcon: leftIcon, rightIcon: rightIcon)
                .disabled(isDisabled)
                .frame(maxWidth: 360)
        } controls: {
            LabeledContent("Label") { TextField("Label", text: $label).frame(maxWidth: 240) }
            LabeledContent("Placeholder") { TextField("Placeholder", text: $placeholder).frame(maxWidth: 240) }
            LabeledContent("Helper text") { TextField("Helper", text: $helperText).frame(maxWidth: 240) }
            LabeledContent("Error text") { TextField("Error", text: $errorText).frame(maxWidth: 240) }
            OptionPicker("State", value: $state, options: SPInputState.allCases)
            OptionPicker("Type", value: $type, options: SPInputType.allCases)
            IconPicker(title: "Left icon", icon: $leftIcon)
            IconPicker(title: "Right icon", icon: $rightIcon)
            Toggle("Shows optional", isOn: $showsOptional)
            Toggle("Disabled", isOn: $isDisabled)
        } sections: {
            CatalogSection("States") {
                VStack(spacing: SPSpacing.lg) {
                    SPInput("Default", value: .constant(""), placeholder: "Placeholder", helperText: "Helper text")
                    SPInput("Error", value: .constant("ash@"), errorText: "Enter a valid email address", state: .error)
                    SPInput("Success", value: .constant("ash@example.com"), helperText: "Looks good", state: .success)
                    SPInput("Middle name", value: .constant(""), showsOptional: true)
                    SPInput("Disabled", value: .constant("Read only")).disabled(true)
                }
                .frame(maxWidth: 360)
            }
            CatalogSection("With icons") {
                VStack(spacing: SPSpacing.lg) {
                    SPInput("Email", value: .constant(""), placeholder: "name@example.com", type: .email, leftIcon: .emailOutline)
                    SPInput("Search", value: .constant(""), placeholder: "Search accounts", rightIcon: .searchOutline)
                    SPInput("Password", value: .constant("secret"), type: .password, leftIcon: .lockOutline, rightIcon: .eyeOutline)
                }
                .frame(maxWidth: 360)
            }
        }
    }
}

struct SelectPage: View {
    @State private var term: Int? = 12
    @State private var states: Set<String> = ["CA"]
    @State private var multiple = false
    @State private var state: SPSelectState = .default
    @State private var isDisabled = false

    private let terms: [SPSelectOption<Int>] = [
        .init(6, label: "6 months"), .init(12, label: "12 months"),
        .init(24, label: "24 months"), .init(60, label: "60 months", isDisabled: true),
    ]
    private let stateOptions: [SPSelectOption<String>] = [
        .init("CA", label: "California"), .init("NY", label: "New York"),
        .init("TX", label: "Texas"), .init("WA", label: "Washington"),
    ]

    var body: some View {
        ComponentPage(summary: "A dropdown for choosing one option, or several. The trigger is Sparkline; the list is the native menu.") {
            Group {
                if multiple {
                    SPSelect("States", value: $states, options: stateOptions,
                             helperText: "Choose any", errorText: "Choose at least one", state: state)
                } else {
                    SPSelect("Term length", value: $term, options: terms,
                             placeholder: "Select term length", helperText: "You can change this later",
                             errorText: "Choose a term", state: state)
                }
            }
            .disabled(isDisabled)
            .frame(maxWidth: 360)
        } controls: {
            Toggle("Multiple", isOn: $multiple)
            OptionPicker("State", value: $state, options: SPSelectState.allCases)
            Toggle("Disabled", isOn: $isDisabled)
            Button("Clear selection") { term = nil; states = [] }
        } sections: {
            CatalogSection("States") {
                VStack(spacing: SPSpacing.lg) {
                    SPSelect("Empty", value: .constant(Int?.none), options: terms)
                    SPSelect("Selected", value: .constant(Int?.some(12)), options: terms)
                    SPSelect("Disabled", value: .constant(Int?.some(6)), options: terms).disabled(true)
                }
                .frame(maxWidth: 360)
            }
            CatalogSection("Multi-select") {
                SPSelect("States", value: .constant(Set(["CA", "TX"])), options: stateOptions, helperText: "Choose any")
                    .frame(maxWidth: 360)
            }
            CatalogSection("With validation") {
                SPSelect("Term length", value: .constant(Int?.none), options: terms, errorText: "Choose a term", state: .error)
                    .frame(maxWidth: 360)
            }
        }
    }
}

struct SliderPage: View {
    @State private var value = 5_000.0
    @State private var step = 500.0
    @State private var showsValue = false
    @State private var isDisabled = false

    var body: some View {
        ComponentPage(summary: "A range control for approximate values. Show the formatted value yourself; showsValue prints the raw number.") {
            VStack(alignment: .leading, spacing: SPSpacing.sm) {
                Text("Deposit amount").spType(.body2).foregroundStyle(SPColor.textSecondary)
                Text(value, format: .currency(code: "USD").precision(.fractionLength(0)))
                    .spType(.headline3)
                    .foregroundStyle(SPColor.textPrimary)
                SPSlider("Deposit amount", value: $value, in: 500...50_000, step: step, showsValue: showsValue)
                    .disabled(isDisabled)
            }
            .frame(maxWidth: 420)
        } controls: {
            LabeledContent("Step") {
                Picker("Step", selection: $step) {
                    Text("Continuous").tag(0.0)
                    Text("100").tag(100.0)
                    Text("500").tag(500.0)
                    Text("1,000").tag(1_000.0)
                }
                .labelsHidden()
            }
            Toggle("Shows value", isOn: $showsValue)
            Toggle("Disabled", isOn: $isDisabled)
        } sections: {
            CatalogSection("States") {
                VStack(spacing: SPSpacing.lg) {
                    SPSlider("Default", value: .constant(30))
                    SPSlider("With value", value: .constant(60), showsValue: true)
                }
                .frame(maxWidth: 420)
            }
            CatalogSection("Stepped") {
                SPSlider("Stepped", value: .constant(40), step: 10, showsValue: true)
                    .frame(maxWidth: 420)
            }
            CatalogSection("Disabled") {
                SPSlider("Disabled", value: .constant(45)).disabled(true)
                    .frame(maxWidth: 420)
            }
        }
    }
}
