import SwiftUI

/// Validation state (`InputState` on the web). Focus and disabled are handled
/// automatically (`@FocusState` and `.disabled(_:)`).
public enum SPInputState: String, CaseIterable, Sendable {
    case `default`, error, success
}

/// The kind of value (`type` on the web): sets the keyboard, autocorrection and secure entry.
public enum SPInputType: String, CaseIterable, Sendable {
    case text, email, phone, number, decimal, password, url
}

/// A single-line text field with a label, helper or error text, and optional icons.
///
/// ```swift
/// SPInput("Email", value: $email,
///         errorText: "Enter a valid email address",
///         state: emailInvalid ? .error : .default,
///         type: .email)
/// ```
public struct SPInput: View {
    let label: String
    @Binding var value: String
    let placeholder: String
    let helperText: String
    let errorText: String
    let state: SPInputState
    let showsOptional: Bool
    let type: SPInputType
    let leftIcon: SPIconName?
    let rightIcon: SPIconName?

    @FocusState private var isFocused: Bool
    @Environment(\.isEnabled) private var isEnabled

    /// - Parameters:
    ///   - label: Shown above the field. Always set one.
    ///   - value: The field's text.
    ///   - placeholder: Shown while the field is empty.
    ///   - helperText: Shown below the field. Hidden in the error state; green in the success state.
    ///   - errorText: Shown only in the error state.
    ///   - state: `.default`, `.error` or `.success`.
    ///   - showsOptional: Appends "(optional)" to the label.
    ///   - type: Keyboard and secure-entry behavior.
    ///   - leftIcon: Decorative icon before the text.
    ///   - rightIcon: Decorative icon after the text.
    public init(
        _ label: String,
        value: Binding<String>,
        placeholder: String = "",
        helperText: String = "",
        errorText: String = "",
        state: SPInputState = .default,
        showsOptional: Bool = false,
        type: SPInputType = .text,
        leftIcon: SPIconName? = nil,
        rightIcon: SPIconName? = nil
    ) {
        self.label = label
        self._value = value
        self.placeholder = placeholder
        self.helperText = helperText
        self.errorText = errorText
        self.state = state
        self.showsOptional = showsOptional
        self.type = type
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
    }

    private enum FieldState { case `default`, focus, error, success, disabled }

    private var fieldState: FieldState {
        if !isEnabled { return .disabled }
        if state == .error { return .error }
        if state == .success { return .success }
        if isFocused { return .focus }
        return .default
    }

    public var body: some View {
        let fs = fieldState
        VStack(alignment: .leading, spacing: SPSpacing.sm) {
            if !label.isEmpty {
                HStack(spacing: SPSpacing.xs) {
                    Text(label).foregroundStyle(SPColor.textPrimary)
                    if showsOptional {
                        Text("(optional)").italic().foregroundStyle(SPColor.textSecondary)
                    }
                }
                .spType(.body1)
                .accessibilityHidden(true)
            }

            HStack(spacing: SPSpacing.sm) {
                if let leftIcon { SPIcon(leftIcon, size: 20) }
                field
                    .spType(.body1)
                    .foregroundStyle(isEnabled ? SPColor.textPrimary : SPColor.textDisabled)
                    .focused($isFocused)
                    .accessibilityLabel(label)
                    .accessibilityHint(fs == .error ? errorText : helperText)
                if let rightIcon {
                    SPIcon(rightIcon, size: 20)
                } else if fs == .error {
                    SPIcon(.alertCircleOutline, size: 20)
                }
            }
            .foregroundStyle(iconColor(fs))
            .padding(.horizontal, SPSpacing.sm)
            .frame(minHeight: 48)
            .background(
                RoundedRectangle(cornerRadius: SPRadius.md)
                    .fill(fs == .disabled ? SPColor.surfaceSubtleDisabled : SPColor.surfaceDefault)
            )
            .overlay(RoundedRectangle(cornerRadius: SPRadius.md).strokeBorder(borderColor(fs), lineWidth: 1))
            .contentShape(Rectangle())
            .onTapGesture { isFocused = true }
            .animation(.easeOut(duration: 0.15), value: isFocused)

            if fs == .error, !errorText.isEmpty {
                helper(errorText, color: SPColor.textError)
            } else if fs != .error, !helperText.isEmpty {
                helper(helperText, color: fs == .success ? SPColor.textSuccess : SPColor.textSecondary)
            }
        }
    }

    @ViewBuilder
    private var field: some View {
        let prompt = Text(placeholder).foregroundStyle(isEnabled ? SPColor.textSecondary : SPColor.textDisabled)
        Group {
            if type == .password {
                SecureField(label, text: $value, prompt: prompt)
            } else {
                TextField(label, text: $value, prompt: prompt)
            }
        }
        .textFieldStyle(.plain)
        .autocorrectionDisabled(type != .text)
        #if os(iOS)
        .keyboardType(keyboard)
        .textInputAutocapitalization(type == .text ? .sentences : .never)
        .textContentType(textContentType)
        #endif
    }

    #if os(iOS)
    private var keyboard: UIKeyboardType {
        switch type {
        case .text, .password: return .default
        case .email: return .emailAddress
        case .phone: return .phonePad
        case .number: return .numberPad
        case .decimal: return .decimalPad
        case .url: return .URL
        }
    }

    private var textContentType: UITextContentType? {
        switch type {
        case .email: return .emailAddress
        case .phone: return .telephoneNumber
        case .password: return .password
        case .url: return .URL
        case .text, .number, .decimal: return nil
        }
    }
    #endif

    private func helper(_ text: String, color: Color) -> some View {
        Text(text)
            .spType(.caption)
            .foregroundStyle(color)
            .accessibilityHidden(true)
    }

    private func borderColor(_ fs: FieldState) -> Color {
        switch fs {
        case .default: return SPColor.borderStrong
        case .focus: return SPColor.actionBrandBorder
        case .error: return SPColor.borderError
        case .success: return SPColor.borderSuccess
        case .disabled: return SPColor.borderDisabled
        }
    }

    private func iconColor(_ fs: FieldState) -> Color {
        switch fs {
        case .default: return SPColor.textSecondary
        case .focus: return SPColor.actionBrandBorder
        case .error: return SPColor.textError
        case .success: return SPColor.textSuccess
        case .disabled: return SPColor.textDisabled
        }
    }
}

struct SPInput_Previews: PreviewProvider {
    struct Demo: View {
        @State var text = ""
        @State var filled = "ash@example.com"
        var body: some View {
            VStack(spacing: SPSpacing.lg) {
                SPInput("First name", value: $text, placeholder: "Placeholder", helperText: "Helper text")
                SPInput("Email", value: $filled, errorText: "Enter a valid email address", state: .error, type: .email)
                SPInput("Code", value: $filled, helperText: "Verified", state: .success, rightIcon: .checkCircleOutline)
                SPInput("Middle name", value: $text, showsOptional: true, leftIcon: .accountOutline)
                SPInput("Disabled", value: $filled).disabled(true)
            }
            .padding()
        }
    }

    static var previews: some View { Demo() }
}
