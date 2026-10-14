import SwiftUI

/// Visual emphasis (`ButtonType` on the web).
public enum SPButtonType: String, CaseIterable, Sendable {
    case filled, outlined, text
}

/// Height (`ButtonSize` on the web): large is 48pt, small is 36pt.
public enum SPButtonSize: String, CaseIterable, Sendable {
    case large, small
}

/// Triggers an action. Three emphasis levels: `filled` (primary), `outlined`
/// (secondary) and `text` (tertiary or inline).
///
/// ```swift
/// SPButton("Continue") { goNext() }
/// SPButton("Back", type: .text, leftIcon: .arrowLeft) { goBack() }
/// SPButton("Create login", isFullWidth: true) { submit() }
///     .disabled(!canSubmit)
/// ```
public struct SPButton: View {
    let label: String
    let type: SPButtonType
    let size: SPButtonSize
    let leftIcon: SPIconName?
    let rightIcon: SPIconName?
    let showsText: Bool
    let isFullWidth: Bool
    let action: () -> Void

    /// - Parameters:
    ///   - label: Visible text. Also the accessibility label when `showsText` is `false`.
    ///   - type: `.filled`, `.outlined` or `.text`.
    ///   - size: `.large` (48pt) or `.small` (36pt).
    ///   - leftIcon: Optional icon before the label.
    ///   - rightIcon: Optional icon after the label.
    ///   - showsText: `false` makes an icon-only button. Keep `label` set for VoiceOver.
    ///   - isFullWidth: Stretch to the width of the container.
    ///   - action: Called on tap. Not called while disabled.
    public init(
        _ label: String,
        type: SPButtonType = .filled,
        size: SPButtonSize = .large,
        leftIcon: SPIconName? = nil,
        rightIcon: SPIconName? = nil,
        showsText: Bool = true,
        isFullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.type = type
        self.size = size
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
        self.showsText = showsText
        self.isFullWidth = isFullWidth
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: SPSpacing.sm) {
                if let leftIcon { SPIcon(leftIcon, size: 24) }
                if showsText {
                    Text(label)
                        .spType(.button)
                        .lineLimit(1)
                        .fixedSize()
                }
                if let rightIcon { SPIcon(rightIcon, size: 24) }
            }
        }
        .buttonStyle(SPButtonStyle(type: type, size: size, isFullWidth: isFullWidth))
        .accessibilityLabel(label)
    }
}

/// The Sparkline button look as a `ButtonStyle`, for custom button content.
///
/// ```swift
/// Button { … } label: { Label("Share", systemImage: "square.and.arrow.up") }
///     .buttonStyle(SPButtonStyle(type: .outlined))
/// ```
public struct SPButtonStyle: ButtonStyle {
    let type: SPButtonType
    let size: SPButtonSize
    let isFullWidth: Bool

    public init(type: SPButtonType = .filled, size: SPButtonSize = .large, isFullWidth: Bool = false) {
        self.type = type
        self.size = size
        self.isFullWidth = isFullWidth
    }

    public func makeBody(configuration: Configuration) -> some View {
        SPButtonBody(configuration: configuration, type: type, size: size, isFullWidth: isFullWidth)
    }
}

private struct SPButtonBody: View {
    let configuration: ButtonStyleConfiguration
    let type: SPButtonType
    let size: SPButtonSize
    let isFullWidth: Bool

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.isFocused) private var isFocused
    @Environment(\.spForcedInteractionState) private var forced
    @State private var isHovered = false

    private var state: SPInteractionState {
        SPInteractionResolver(forced: forced, isPressed: configuration.isPressed, isFocused: isFocused, isHovered: isHovered).state
    }

    var body: some View {
        let colors = SPButtonColors(type: type, state: state, isEnabled: isEnabled)
        let radius = isEnabled && state == .pressed ? SPRadius.full : SPRadius.md
        let shape = RoundedRectangle(cornerRadius: radius, style: .continuous)

        configuration.label
            .foregroundStyle(colors.foreground)
            .padding(.horizontal, SPSpacing.md)
            .padding(.vertical, SPSpacing.sm)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .frame(minHeight: size == .large ? 48 : 36)
            .background(shape.fill(colors.background))
            .overlay(shape.strokeBorder(colors.border, lineWidth: 1))
            .compositingGroup()
            .spShadowIf(colors.hasShadow, .button)
            .spFocusRing(isEnabled && state == .focus, cornerRadius: radius)
            .contentShape(shape)
            .onHover { isHovered = $0 }
            .animation(.easeOut(duration: 0.15), value: state)
            .animation(.easeOut(duration: 0.15), value: isEnabled)
    }
}

struct SPButtonColors {
    var background: Color = .clear
    var foreground: Color
    var border: Color = .clear
    var hasShadow = false

    init(type: SPButtonType, state: SPInteractionState, isEnabled: Bool) {
        switch type {
        case .filled:
            guard isEnabled else {
                background = SPColor.surfaceDisabled
                foreground = SPColor.textOnDisabled
                return
            }
            foreground = SPColor.textInverse
            background = state == .default ? SPColor.surfaceBrand : SPColor.actionBrandBorder
            hasShadow = true

        case .outlined:
            guard isEnabled else {
                foreground = SPColor.textDisabled
                border = SPColor.borderDisabled
                return
            }
            switch state {
            case .default:
                foreground = SPColor.textBrand
                border = SPColor.borderDefault
            case .hover, .pressed:
                foreground = SPColor.actionBrandText
                border = SPColor.actionBrandBorder
                background = SPColor.surfaceHoverBg
            case .focus:
                foreground = SPColor.actionBrandText
                border = SPColor.actionBrandBorder
            }

        case .text:
            guard isEnabled else {
                foreground = SPColor.textDisabled
                return
            }
            switch state {
            case .default:
                foreground = SPColor.textBrand
            case .hover:
                foreground = SPColor.actionBrandText
                background = SPColor.surfaceHoverBg
            case .pressed:
                foreground = SPColor.actionBrandText
                background = SPColor.surfaceHoverBg
                border = SPColor.actionBrandBorder
            case .focus:
                foreground = SPColor.actionBrandText
            }
        }
    }
}

extension View {
    @ViewBuilder
    func spShadowIf(_ condition: Bool, _ shadow: SPShadow) -> some View {
        if condition { spShadow(shadow) } else { self }
    }
}

struct SPButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: SPSpacing.md) {
            ForEach(SPButtonType.allCases, id: \.self) { type in
                HStack(spacing: SPSpacing.md) {
                    SPButton("Button", type: type) {}
                    SPButton("Button", type: type, size: .small, leftIcon: .arrowLeft) {}
                    SPButton("Button", type: type) {}.disabled(true)
                }
            }
            HStack(spacing: SPSpacing.md) {
                ForEach(SPInteractionState.allCases, id: \.self) { state in
                    SPButton(state.rawValue.capitalized) {}.spInteractionState(state)
                }
            }
            SPButton("Full width", isFullWidth: true) {}
        }
        .padding()
    }
}
