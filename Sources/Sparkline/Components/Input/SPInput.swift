import SwiftUI

/// A single-line text field with a label, helper or error text, and optional icons.
///
/// ```swift
/// SPInput("Email", text: $email,
///         errorText: "Enter a valid email address",
///         state: emailInvalid ? .error : .default,
///         contentType: .email)
/// ```
public struct SPInput: View {
    /// Validation state. Focus and disabled are handled automatically
    /// (`@FocusState` and `.disabled(_:)`).
    public enum State: String, CaseIterable, Sendable {
        case `default`, error, success
    }

    /// Sets the keyboard, autocorrection and secure entry.
    public enum ContentType: String, CaseIterable, Sendable {
        case text, email, phone, number, decimal, password, url
    }

    let label: String
    @Binding var text: String
    let placeholder: String
    let helperText: String
    let errorText: String
    let state: State
    let isOptional: Bool
    let contentType: ContentType
    let leftIcon: SPIconName?
    let rightIcon: SPIconName?

    @FocusState private var isFocused: Bool
    @Environment(\.isEnabled) private var isEnabled

    /// - Parameters:
    ///   - label: Shown above the field. Always set one.
    ///   - text: The field's text.
    ///   - placeholder: Shown while the field is empty.
    ///   - helperText: Shown below the field. Hidden in the error state; green in the success state.
    ///   - errorText: Shown only in the error state.
    ///   - state: `.default`, `.error` or `.success`.
    ///   - isOptional: Appends "(optional)" to the label.
    ///   - contentType: Keyboard and secure-entry behavior.
    ///   - leftIcon: Decorative icon before the text.
    ///   - rightIcon: Decorative icon after the text.
    public init(
        _ label: String,
        text: Binding<String>,
        placeholder: String = "",
        helperText: String = "",
        errorText: String = "",
        state: State = .default,
        isOptional: Bool = false,
        contentType: ContentType = .text,
        leftIcon: SPIconName? = nil,
        rightIcon: SPIconName? = nil
    ) {
        self.label = label
        self._text = text
        self.placeholder = placeholder
        self.helperText = helperText
        self.errorText = errorText
        self.state = state
        self.isOptional = isOptional
        self.contentType = contentType
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
                    Text(label).foregroundStyle(.spTextPrimary)
                    if isOptional {
                        Text("(optional)").italic().foregroundStyle(.spTextSecondary)
                    }
                }
                .spTextStyle(.body1)
                .accessibilityHidden(true)
            }

            HStack(spacing: SPSpacing.sm) {
                if let leftIcon { SPIcon(leftIcon, size: 20) }
                field
                    .spTextStyle(.body1)
                    .foregroundStyle(isEnabled ? Color.spTextPrimary : Color.spTextDisabled)
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
                    .fill(fs == .disabled ? Color.spSurfaceSubtleDisabled : Color.spSurfaceDefault)
            )
            .overlay(RoundedRectangle(cornerRadius: SPRadius.md).strokeBorder(borderColor(fs), lineWidth: 1))
            .contentShape(Rectangle())
            .onTapGesture { isFocused = true }
            .animation(.easeOut(duration: 0.15), value: isFocused)

            if fs == .error, !errorText.isEmpty {
                helper(errorText, color: .spTextError)
            } else if fs != .error, !helperText.isEmpty {
                helper(helperText, color: fs == .success ? .spTextSuccess : .spTextSecondary)
            }
        }
    }

    @ViewBuilder
    private var field: some View {
        let prompt = Text(placeholder).foregroundStyle(isEnabled ? Color.spTextSecondary : Color.spTextDisabled)
        Group {
            if contentType == .password {
                SecureField(label, text: $text, prompt: prompt)
            } else {
                TextField(label, text: $text, prompt: prompt)
            }
        }
        .textFieldStyle(.plain)
        .autocorrectionDisabled(contentType != .text)
        #if os(iOS)
        .keyboardType(keyboard)
        .textInputAutocapitalization(contentType == .text ? .sentences : .never)
        .textContentType(textContentType)
        #endif
    }

    #if os(iOS)
    private var keyboard: UIKeyboardType {
        switch contentType {
        case .text, .password: return .default
        case .email: return .emailAddress
        case .phone: return .phonePad
        case .number: return .numberPad
        case .decimal: return .decimalPad
        case .url: return .URL
        }
    }

    private var textContentType: UITextContentType? {
        switch contentType {
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
            .spTextStyle(.caption)
            .foregroundStyle(color)
            .accessibilityHidden(true)
    }

    private func borderColor(_ fs: FieldState) -> Color {
        switch fs {
        case .default: return .spBorderStrong
        case .focus: return .spActionBrandBorder
        case .error: return .spBorderError
        case .success: return .spBorderSuccess
        case .disabled: return .spBorderDisabled
        }
    }

    private func iconColor(_ fs: FieldState) -> Color {
        switch fs {
        case .default: return .spTextSecondary
        case .focus: return .spActionBrandBorder
        case .error: return .spTextError
        case .success: return .spTextSuccess
        case .disabled: return .spTextDisabled
        }
    }
}

struct SPInput_Previews: PreviewProvider {
    struct Demo: View {
        @State var text = ""
        @State var filled = "ash@example.com"
        var body: some View {
            VStack(spacing: SPSpacing.lg) {
                SPInput("First name", text: $text, placeholder: "Placeholder", helperText: "Helper text")
                SPInput("Email", text: $filled, errorText: "Enter a valid email address", state: .error, contentType: .email)
                SPInput("Code", text: $filled, helperText: "Verified", state: .success, rightIcon: .checkCircleOutline)
                SPInput("Middle name", text: $text, isOptional: true, leftIcon: .accountOutline)
                SPInput("Disabled", text: $filled).disabled(true)
            }
            .padding()
        }
    }

    static var previews: some View { Demo() }
}
