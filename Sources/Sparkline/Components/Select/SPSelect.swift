import SwiftUI

/// One choice in an ``SPSelect``.
public struct SPSelectOption<Value: Hashable>: Identifiable {
    public let value: Value
    public let label: String
    public let isDisabled: Bool
    public var id: Value { value }

    public init(_ value: Value, label: String, isDisabled: Bool = false) {
        self.value = value
        self.label = label
        self.isDisabled = isDisabled
    }
}

/// Validation state for ``SPSelect``. Disable it with `.disabled(_:)`.
public enum SPSelectState: String, CaseIterable, Sendable {
    case `default`, error
}

/// A dropdown for choosing one option, or several. The trigger is styled by
/// Sparkline; the option list is the system menu, so it gets native keyboard,
/// pointer and VoiceOver support.
///
/// ```swift
/// @State private var term: Int? = 12
///
/// SPSelect("Term length", selection: $term, options: [
///     .init(6, label: "6 months"),
///     .init(12, label: "12 months"),
///     .init(24, label: "24 months"),
/// ], placeholder: "Select term length")
/// ```
public struct SPSelect<Value: Hashable>: View {
    private enum Selection {
        case single(Binding<Value?>)
        case multiple(Binding<Set<Value>>)
    }

    let label: String
    private let selection: Selection
    let options: [SPSelectOption<Value>]
    let placeholder: String
    let helperText: String
    let errorText: String
    let state: SPSelectState

    @Environment(\.isEnabled) private var isEnabled

    /// Single selection.
    /// - Parameters:
    ///   - label: Shown above the trigger. Also the accessibility label.
    ///   - selection: The selected value, or `nil` for none.
    ///   - options: The choices, in display order.
    ///   - placeholder: Shown when nothing is selected.
    ///   - helperText: Shown below. Hidden in the error state.
    ///   - errorText: Shown only in the error state.
    ///   - state: `.default` or `.error`.
    public init(
        _ label: String,
        selection: Binding<Value?>,
        options: [SPSelectOption<Value>],
        placeholder: String = "Select an option",
        helperText: String = "",
        errorText: String = "",
        state: SPSelectState = .default
    ) {
        self.label = label
        self.selection = .single(selection)
        self.options = options
        self.placeholder = placeholder
        self.helperText = helperText
        self.errorText = errorText
        self.state = state
    }

    /// Multiple selection. Selected options show as removable chips in the trigger,
    /// in option order, and the menu stays open while you pick.
    public init(
        _ label: String,
        selection: Binding<Set<Value>>,
        options: [SPSelectOption<Value>],
        placeholder: String = "Select an option",
        helperText: String = "",
        errorText: String = "",
        state: SPSelectState = .default
    ) {
        self.label = label
        self.selection = .multiple(selection)
        self.options = options
        self.placeholder = placeholder
        self.helperText = helperText
        self.errorText = errorText
        self.state = state
    }

    private var isError: Bool { isEnabled && state == .error }

    private var selectedOptions: [SPSelectOption<Value>] {
        switch selection {
        case .single(let binding):
            return options.filter { $0.value == binding.wrappedValue }
        case .multiple(let binding):
            return options.filter { binding.wrappedValue.contains($0.value) }
        }
    }

    private var isMultiple: Bool {
        if case .multiple = selection { return true }
        return false
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: SPSpacing.xs) {
            if !label.isEmpty {
                Text(label)
                    .spTextStyle(.body2)
                    .fontWeight(.medium)
                    .foregroundStyle(.spTextPrimary)
                    .accessibilityHidden(true)
            }

            trigger

            if isError, !errorText.isEmpty {
                Text(errorText).spTextStyle(.caption).foregroundStyle(.spTextError)
            } else if !isError, !helperText.isEmpty {
                Text(helperText).spTextStyle(.caption).foregroundStyle(.spTextSecondary)
            }
        }
    }

    private var trigger: some View {
        let shape = RoundedRectangle(cornerRadius: SPRadius.md)
        let border: Color = !isEnabled ? .spBorderDisabled : (isError ? .spBorderError : .spBorderSubtle)
        let selected = selectedOptions

        return HStack(spacing: SPSpacing.xs) {
            if isMultiple, !selected.isEmpty {
                SPFlowLayout(spacing: SPSpacing.xs) {
                    ForEach(selected) { option in chip(option) }
                }
            } else {
                Text(selected.first?.label ?? placeholder)
                    .spTextStyle(.body1)
                    .foregroundStyle(selected.isEmpty || !isEnabled ? Color.spTextSecondary : Color.spTextPrimary)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .allowsHitTesting(false)
            }
            SPIcon(.chevronDown, size: 20)
                .foregroundStyle(.spTextSecondary)
                .allowsHitTesting(false)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, SPSpacing.sm)
        .frame(minHeight: 44)
        .background { menu.background(shape.fill(isEnabled ? Color.spSurfaceDefault : Color.spSurfaceSubtle)) }
        .overlay(shape.strokeBorder(border, lineWidth: 1.5).allowsHitTesting(false))
        .overlay {
            if isError {
                RoundedRectangle(cornerRadius: SPRadius.md + 3)
                    .strokeBorder(Color.spBorderError.opacity(0.12), lineWidth: 3)
                    .padding(-3)
                    .allowsHitTesting(false)
            }
        }
    }

    private var menu: some View {
        Menu {
            switch selection {
            case .single(let binding):
                Picker(label, selection: binding) {
                    ForEach(options) { option in
                        Text(option.label)
                            .tag(Optional(option.value))
                            .disabled(option.isDisabled)
                    }
                }
                .pickerStyle(.inline)
                .labelsHidden()
            case .multiple(let binding):
                ForEach(options) { option in
                    Toggle(option.label, isOn: Binding(
                        get: { binding.wrappedValue.contains(option.value) },
                        set: { isOn in
                            if isOn { binding.wrappedValue.insert(option.value) }
                            else { binding.wrappedValue.remove(option.value) }
                        }
                    ))
                    .disabled(option.isDisabled)
                }
            }
        } label: {
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
        }
        .menuStyle(.button)
        .buttonStyle(.plain)
        .modifier(KeepMenuOpen(isEnabled: isMultiple))
        .accessibilityLabel(label)
        .accessibilityValue(selectedOptions.isEmpty ? placeholder : selectedOptions.map(\.label).joined(separator: ", "))
        .accessibilityHint(isError ? errorText : helperText)
    }

    private func chip(_ option: SPSelectOption<Value>) -> some View {
        HStack(spacing: SPSpacing.xs) {
            Text(option.label)
                .spTextStyle(.caption)
                .fontWeight(.medium)
                .lineLimit(1)
                .fixedSize()
                .allowsHitTesting(false)
            Button {
                if case .multiple(let binding) = selection {
                    binding.wrappedValue.remove(option.value)
                }
            } label: {
                SPIcon(.closeCircleFill, size: 14)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Remove \(option.label)")
        }
        .foregroundStyle(.spTextBrand)
        .padding(.leading, SPSpacing.sm)
        .padding(.trailing, 6)
        .frame(height: 24)
        .background(Capsule().fill(Color.spSurfaceBrandSubtle))
    }
}

/// Keeps the menu open between picks for multi-select (iOS only).
private struct KeepMenuOpen: ViewModifier {
    let isEnabled: Bool

    func body(content: Content) -> some View {
        #if os(iOS)
        content.menuActionDismissBehavior(isEnabled ? .disabled : .automatic)
        #else
        content
        #endif
    }
}

struct SPSelect_Previews: PreviewProvider {
    struct Demo: View {
        @State var term: Int? = 12
        @State var empty: Int?
        @State var states: Set<String> = ["CA", "NY"]
        let terms: [SPSelectOption<Int>] = [.init(6, label: "6 months"), .init(12, label: "12 months"), .init(24, label: "24 months")]
        var body: some View {
            VStack(spacing: SPSpacing.lg) {
                SPSelect("Term length", selection: $term, options: terms)
                SPSelect("Term length", selection: $empty, options: terms, helperText: "You can change this later")
                SPSelect("Term length", selection: $empty, options: terms, errorText: "Choose a term", state: .error)
                SPSelect("States", selection: $states, options: [.init("CA", label: "California"), .init("NY", label: "New York"), .init("TX", label: "Texas")])
                SPSelect("Disabled", selection: $term, options: terms).disabled(true)
            }
            .padding()
        }
    }

    static var previews: some View { Demo() }
}
