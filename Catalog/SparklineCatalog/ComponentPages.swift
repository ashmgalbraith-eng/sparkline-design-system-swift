import SwiftUI
import Sparkline

// MARK: - Actions

struct ButtonPage: View {
    @State private var label = "Button"
    @State private var variant: SPButton.Variant = .filled
    @State private var size: SPButton.Size = .large
    @State private var leftIcon: SPIconName?
    @State private var rightIcon: SPIconName?
    @State private var showsLabel = true
    @State private var isFullWidth = false
    @State private var isDisabled = false
    @State private var taps = 0

    var body: some View {
        ComponentPage(summary: "Triggers an action. Filled is the primary action (one per view), outlined is secondary, text is tertiary or inline.") {
            VStack(spacing: SPSpacing.sm) {
                SPButton(label, variant: variant, size: size, leftIcon: leftIcon, rightIcon: rightIcon,
                         showsLabel: showsLabel, isFullWidth: isFullWidth) { taps += 1 }
                    .disabled(isDisabled)
                Text("Tapped \(taps)×").spTextStyle(.caption).foregroundStyle(.spTextSecondary)
            }
        } controls: {
            LabeledContent("Label") { TextField("Label", text: $label).frame(maxWidth: 240) }
            OptionPicker("Variant", value: $variant, options: SPButton.Variant.allCases)
            OptionPicker("Size", value: $size, options: SPButton.Size.allCases)
            IconPicker(title: "Left icon", icon: $leftIcon)
            IconPicker(title: "Right icon", icon: $rightIcon)
            Toggle("Shows label", isOn: $showsLabel)
            Toggle("Full width", isOn: $isFullWidth)
            Toggle("Disabled", isOn: $isDisabled)
        } sections: {
            CatalogSection("States") {
                ForEach(SPButton.Variant.allCases, id: \.self) { variant in
                    SpecimenRow {
                        ForEach(SPInteractionState.allCases, id: \.self) { state in
                            Specimen(state.rawValue) { SPButton("Button", variant: variant) {}.spInteractionState(state) }
                        }
                        Specimen("disabled") { SPButton("Button", variant: variant) {}.disabled(true) }
                    }
                }
            }
            CatalogSection("Sizes and icons") {
                SpecimenRow {
                    Specimen("large") { SPButton("Button") {} }
                    Specimen("small") { SPButton("Button", size: .small) {} }
                    Specimen("left icon") { SPButton("Back", variant: .outlined, leftIcon: .arrowLeft) {} }
                    Specimen("right icon") { SPButton("Next", rightIcon: .arrowRight) {} }
                    Specimen("icon only") { SPButton("Add", leftIcon: .plusCircleOutline, showsLabel: false) {} }
                }
            }
        }
    }
}

struct ButtonGroupPage: View {
    @State private var selection = 0
    @State private var count = 3
    @State private var size: SPButtonGroupSize = .large
    @State private var showsLabels = true
    @State private var showsLeftIcon = false
    @State private var showsRightIcon = false
    @State private var isDisabled = false

    private func items(_ n: Int) -> [SPButtonGroup<Int>.Item] {
        (0..<n).map {
            .init($0, label: "Option \($0 + 1)",
                  leftIcon: showsLeftIcon ? .arrowLeft : nil,
                  rightIcon: showsRightIcon ? .arrowRight : nil)
        }
    }

    var body: some View {
        ComponentPage(summary: "A segmented control: connected buttons where exactly one is selected. For switching between two to four short views or modes.") {
            SPButtonGroup(selection: $selection, items: items(count), size: size, showsLabels: showsLabels)
                .disabled(isDisabled)
        } controls: {
            Stepper("Buttons: \(count)", value: $count, in: 2...5)
                .onChange(of: count) { selection = min(selection, count - 1) }
            OptionPicker("Size", value: $size, options: SPButtonGroupSize.allCases)
            Toggle("Shows labels", isOn: $showsLabels)
            Toggle("Left icons", isOn: $showsLeftIcon)
            Toggle("Right icons", isOn: $showsRightIcon)
            Toggle("Disabled", isOn: $isDisabled)
        } sections: {
            CatalogSection("Variants") {
                VStack(alignment: .leading, spacing: SPSpacing.md) {
                    Specimen("large") { SPButtonGroup(selection: .constant(0), items: (0..<2).map { .init($0, label: "Button") }) }
                    Specimen("small") { SPButtonGroup(selection: .constant(1), items: (0..<3).map { .init($0, label: "Button") }, size: .small) }
                    Specimen("icons only") {
                        SPButtonGroup(selection: .constant(0), items: [
                            .init(0, label: "List", leftIcon: .menu), .init(1, label: "Map", leftIcon: .mapMarkerOutline),
                        ], showsLabels: false)
                    }
                    Specimen("disabled") { SPButtonGroup(selection: .constant(0), items: (0..<2).map { .init($0, label: "Button") }).disabled(true) }
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
            CatalogSection("States") {
                SpecimenRow {
                    ForEach([SPInteractionState.default, .hover, .pressed, .focus], id: \.self) { state in
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
                    SPButton("Reset", variant: .text, size: .small) {
                        filters = ["Savings", "CDs", "12 months", "No minimum"]
                    }
                }
            }
        }
    }
}

// MARK: - Display

struct AvatarPage: View {
    @State private var kind = "initials"
    @State private var initials = "AG"
    @State private var size: SPAvatar.Size = .large
    @State private var showsStatus = false
    @State private var status: SPBadge.Status = .success
    @State private var showsNotification = false
    @State private var count = "3"

    private var content: SPAvatar.Content {
        kind == "icon" ? .icon : .initials(initials)
    }

    var body: some View {
        ComponentPage(summary: "A small circular representation of a person: initials, a photo or the account icon, with an optional status dot or count.") {
            SPAvatar(content, size: size, status: showsStatus ? status : nil,
                     notificationCount: showsNotification ? count : nil, accessibilityLabel: "Ash Galbraith")
                .padding(SPSpacing.md)
        } controls: {
            LabeledContent("Content") {
                Picker("Content", selection: $kind) {
                    Text("initials").tag("initials")
                    Text("icon").tag("icon")
                }
                .pickerStyle(.segmented).labelsHidden().frame(maxWidth: 240)
            }
            LabeledContent("Initials") { TextField("Initials", text: $initials).frame(maxWidth: 120) }
            OptionPicker("Size", value: $size, options: SPAvatar.Size.allCases)
            Toggle("Status", isOn: $showsStatus)
            OptionPicker("Status color", value: $status, options: SPBadge.Status.allCases)
            Toggle("Notification", isOn: $showsNotification)
            LabeledContent("Count") { TextField("Count", text: $count).frame(maxWidth: 120) }
        } sections: {
            CatalogSection("Sizes") {
                SpecimenRow {
                    ForEach(SPAvatar.Size.allCases, id: \.self) { size in
                        Specimen(size.rawValue) { SPAvatar(.initials("AG"), size: size) }
                        Specimen("\(size.rawValue) icon") { SPAvatar(.icon, size: size) }
                    }
                }
            }
            CatalogSection("Badges") {
                SpecimenRow {
                    ForEach(SPAvatar.Size.allCases, id: \.self) { size in
                        Specimen(size.rawValue) {
                            SPAvatar(.initials("AG"), size: size, status: .success, notificationCount: "999+")
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
    @State private var variant: SPBadge.Variant = .numeric
    @State private var status: SPBadge.Status = .notification

    var body: some View {
        ComponentPage(summary: "A small status marker: a numeric count or a colored dot. Pair a dot with text; color alone carries its meaning.") {
            SPBadge(label, variant: variant, status: status)
        } controls: {
            LabeledContent("Label") { TextField("Label", text: $label).frame(maxWidth: 120) }
            OptionPicker("Variant", value: $variant, options: SPBadge.Variant.allCases)
            OptionPicker("Status", value: $status, options: SPBadge.Status.allCases)
        } sections: {
            CatalogSection("Statuses") {
                SpecimenRow {
                    ForEach(SPBadge.Status.allCases, id: \.self) { status in
                        Specimen(status.rawValue) { SPBadge("9", status: status) }
                    }
                    ForEach(SPBadge.Status.allCases, id: \.self) { status in
                        Specimen(status.rawValue) { SPBadge.dot(status) }
                    }
                }
            }
            CatalogSection("On an icon") {
                SPIcon(.bellOutline)
                    .foregroundStyle(.spTextPrimary)
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
                Text("12-month CD").spTextStyle(.subtitle1).foregroundStyle(.spTextPrimary)
                Text("4.85% APY · $500 minimum").spTextStyle(.body2).foregroundStyle(.spTextSecondary)
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
                                Text(variant.rawValue.capitalized).spTextStyle(.body1).foregroundStyle(.spTextPrimary)
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
                            Text(key).foregroundStyle(.spTextSecondary)
                            Spacer()
                            Text(value).foregroundStyle(.spTextPrimary)
                        }
                        .spTextStyle(.body2)
                        .padding(SPSpacing.md)
                        if key != "Deposit" { Divider().overlay(Color.spBorderSubtle) }
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
        ComponentPage(summary: "Renders an icon from the Sparkline registry. It fills with the current foreground style.") {
            SPIcon(icon ?? .check, size: size).foregroundStyle(.spTextBrand)
        } controls: {
            IconPicker(title: "Name", icon: $icon)
            LabeledContent("Size: \(Int(size))pt") { Slider(value: $size, in: 12...64, step: 4).frame(maxWidth: 240) }
        } sections: {
            CatalogSection("Sizes") {
                SpecimenRow {
                    ForEach([16, 20, 24, 32], id: \.self) { s in
                        Specimen("\(s)pt") { SPIcon(.bellOutline, size: CGFloat(s)).foregroundStyle(.spTextPrimary) }
                    }
                }
            }
            CatalogSection("Colors") {
                SpecimenRow {
                    Specimen("spTextPrimary") { SPIcon(.checkCircleOutline).foregroundStyle(.spTextPrimary) }
                    Specimen("spTextBrand") { SPIcon(.checkCircleOutline).foregroundStyle(.spTextBrand) }
                    Specimen("spTextSuccess") { SPIcon(.checkCircleOutline).foregroundStyle(.spTextSuccess) }
                    Specimen("spTextError") { SPIcon(.alertCircleOutline).foregroundStyle(.spTextError) }
                }
            }
        }
    }
}

struct StepperPage: View {
    @State private var activeStep = 1
    @State private var orientation: SPStepper.Orientation = .horizontal
    @State private var flagError = false
    @State private var showsDescriptions = false

    private var steps: [SPStepper.Step] {
        let labels = ["Choose CD", "Personal info", "Verify identity", "Fund account", "Review"]
        let descriptions = ["12-month CD", "Name and address", "Upload ID", "Link a bank", "Confirm details"]
        return labels.indices.map { i in
            SPStepper.Step(labels[i],
                           description: showsDescriptions ? descriptions[i] : nil,
                           state: flagError && i == 2 ? .error : nil)
        }
    }

    var body: some View {
        ComponentPage(summary: "A progress indicator for multi-step flows. Display only; steps are not tappable.") {
            SPStepper(steps: steps, activeStep: activeStep, orientation: orientation)
        } controls: {
            Stepper("Active step: \(activeStep) (zero-based)", value: $activeStep, in: 0...4)
            OptionPicker("Orientation", value: $orientation, options: SPStepper.Orientation.allCases)
            Toggle("Flag step 3 as error", isOn: $flagError)
            Toggle("Descriptions", isOn: $showsDescriptions)
        } sections: {
            CatalogSection("States") {
                SPStepper(steps: [
                    .init("Completed"), .init("Active"), .init("Error", state: .error), .init("Pending"),
                ], activeStep: 1)
            }
        }
    }
}

// MARK: - Inputs

struct CheckboxPage: View {
    @State private var label = "I agree to the account disclosures"
    @State private var isOn = false
    @State private var isIndeterminate = false
    @State private var isDisabled = false
    @State private var children = [true, false, false]

    var body: some View {
        ComponentPage(summary: "A labeled checkbox for on/off choices and consent, with an indeterminate state for “select all”.") {
            SPCheckbox(label, isOn: $isOn, isIndeterminate: isIndeterminate)
                .disabled(isDisabled)
        } controls: {
            LabeledContent("Label") { TextField("Label", text: $label).frame(maxWidth: 320) }
            Toggle("Checked", isOn: $isOn)
            Toggle("Indeterminate", isOn: $isIndeterminate)
            Toggle("Disabled", isOn: $isDisabled)
        } sections: {
            CatalogSection("States") {
                SpecimenRow {
                    ForEach(SPInteractionState.allCases, id: \.self) { state in
                        SPCheckbox(state.rawValue, isOn: .constant(true)).spInteractionState(state)
                    }
                    SPCheckbox("disabled", isOn: .constant(true)).disabled(true)
                    SPCheckbox("disabled", isOn: .constant(false)).disabled(true)
                }
            }
            CatalogSection("Select all") {
                VStack(alignment: .leading, spacing: 0) {
                    SPCheckbox("All accounts",
                               isOn: Binding(get: { children.allSatisfy { $0 } },
                                             set: { on in children = children.map { _ in on } }),
                               isIndeterminate: children.contains(true) && children.contains(false))
                    ForEach(children.indices, id: \.self) { i in
                        SPCheckbox("Account \(i + 1)", isOn: $children[i]).padding(.leading, SPSpacing.lg)
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
            LabeledContent("Selection") { Text(source).foregroundStyle(.spTextSecondary) }
            Toggle("Disable last option", isOn: $disableLast)
            Toggle("Disable group", isOn: $isDisabled)
        } sections: {
            CatalogSection("States") {
                SpecimenRow {
                    ForEach(SPInteractionState.allCases, id: \.self) { state in
                        SPRadio(state.rawValue, isSelected: true) {}.spInteractionState(state)
                    }
                    SPRadio("disabled", isSelected: true) {}.disabled(true)
                    SPRadio("disabled", isSelected: false) {}.disabled(true)
                }
            }
        }
    }
}

struct SwitchPage: View {
    @State private var label = "Paperless statements"
    @State private var isOn = true
    @State private var showsLabel = true
    @State private var isDisabled = false

    var body: some View {
        ComponentPage(summary: "An on/off toggle for settings that apply immediately. Use a checkbox for choices saved on submit.") {
            SPSwitch(label, isOn: $isOn, showsLabel: showsLabel)
                .disabled(isDisabled)
                .frame(maxWidth: 360)
        } controls: {
            LabeledContent("Label") { TextField("Label", text: $label).frame(maxWidth: 240) }
            Toggle("Shows label", isOn: $showsLabel)
            Toggle("Disabled", isOn: $isDisabled)
        } sections: {
            CatalogSection("States") {
                VStack(spacing: SPSpacing.md) {
                    SPSwitch("On", isOn: .constant(true))
                    SPSwitch("Off", isOn: .constant(false))
                    SPSwitch("Disabled on", isOn: .constant(true)).disabled(true)
                    SPSwitch("Disabled off", isOn: .constant(false)).disabled(true)
                    Toggle("Plain Toggle with .toggleStyle(.sparkline)", isOn: .constant(true)).toggleStyle(.sparkline)
                }
                .frame(maxWidth: 420)
            }
        }
    }
}

struct InputPage: View {
    @State private var text = ""
    @State private var label = "Email"
    @State private var placeholder = "name@example.com"
    @State private var helperText = "We'll send your statements here"
    @State private var errorText = "Enter a valid email address"
    @State private var state: SPInput.State = .default
    @State private var contentType: SPInput.ContentType = .email
    @State private var isOptional = false
    @State private var leftIcon: SPIconName? = .emailOutline
    @State private var rightIcon: SPIconName?
    @State private var isDisabled = false

    var body: some View {
        ComponentPage(summary: "A single-line text field with a label, helper or error text, and optional icons. It fills the width of its container.") {
            SPInput(label, text: $text, placeholder: placeholder, helperText: helperText, errorText: errorText,
                    state: state, isOptional: isOptional, contentType: contentType, leftIcon: leftIcon, rightIcon: rightIcon)
                .disabled(isDisabled)
                .frame(maxWidth: 360)
        } controls: {
            LabeledContent("Label") { TextField("Label", text: $label).frame(maxWidth: 240) }
            LabeledContent("Placeholder") { TextField("Placeholder", text: $placeholder).frame(maxWidth: 240) }
            LabeledContent("Helper text") { TextField("Helper", text: $helperText).frame(maxWidth: 240) }
            LabeledContent("Error text") { TextField("Error", text: $errorText).frame(maxWidth: 240) }
            OptionPicker("State", value: $state, options: SPInput.State.allCases)
            OptionPicker("Content type", value: $contentType, options: SPInput.ContentType.allCases)
            IconPicker(title: "Left icon", icon: $leftIcon)
            IconPicker(title: "Right icon", icon: $rightIcon)
            Toggle("Optional", isOn: $isOptional)
            Toggle("Disabled", isOn: $isDisabled)
        } sections: {
            CatalogSection("States") {
                VStack(spacing: SPSpacing.lg) {
                    SPInput("Default", text: .constant(""), placeholder: "Placeholder", helperText: "Helper text")
                    SPInput("Error", text: .constant("ash@"), errorText: "Enter a valid email address", state: .error)
                    SPInput("Success", text: .constant("ash@example.com"), helperText: "Looks good", state: .success)
                    SPInput("Disabled", text: .constant("Read only")).disabled(true)
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
                    SPSelect("States", selection: $states, options: stateOptions,
                             helperText: "Choose any", errorText: "Choose at least one", state: state)
                } else {
                    SPSelect("Term length", selection: $term, options: terms,
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
                    SPSelect("Empty", selection: .constant(Int?.none), options: terms)
                    SPSelect("Selected", selection: .constant(Int?.some(12)), options: terms)
                    SPSelect("Error", selection: .constant(Int?.none), options: terms, errorText: "Choose a term", state: .error)
                    SPSelect("Disabled", selection: .constant(Int?.some(6)), options: terms).disabled(true)
                }
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
                Text("Deposit amount").spTextStyle(.body2).foregroundStyle(.spTextSecondary)
                Text(value, format: .currency(code: "USD").precision(.fractionLength(0)))
                    .spTextStyle(.headline3)
                    .foregroundStyle(.spTextPrimary)
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
                    SPSlider("Disabled", value: .constant(45)).disabled(true)
                }
                .frame(maxWidth: 420)
            }
        }
    }
}
