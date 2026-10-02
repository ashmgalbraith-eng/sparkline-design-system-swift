import SwiftUI

/// Triggers an action. Three emphasis levels: `filled` (primary), `outlined`
/// (secondary) and `text` (tertiary or inline).
///
/// ```swift
/// SPButton("Continue") { goNext() }
/// SPButton("Back", variant: .text, leftIcon: .arrowLeft) { goBack() }
/// SPButton("Create login", isFullWidth: true) { submit() }
///     .disabled(!canSubmit)
/// ```
public struct SPButton: View {
    /// Visual emphasis.
    public enum Variant: String, CaseIterable, Sendable {
        case filled, outlined, text
    }

    /// Height: large is 48pt, small is 36pt.
    public enum Size: String, CaseIterable, Sendable {
        case large, small
    }

    let label: String
    let variant: Variant
    let size: Size
    let leftIcon: SPIconName?
    let rightIcon: SPIconName?
    let showsLabel: Bool
    let isFullWidth: Bool
    let action: () -> Void

    /// - Parameters:
    ///   - label: Visible text. Also the accessibility label when `showsLabel` is `false`.
    ///   - variant: `.filled`, `.outlined` or `.text`.
    ///   - size: `.large` (48pt) or `.small` (36pt).
    ///   - leftIcon: Optional icon before the label.
    ///   - rightIcon: Optional icon after the label.
    ///   - showsLabel: `false` makes an icon-only button. Keep `label` set for VoiceOver.
    ///   - isFullWidth: Stretch to the width of the container.
    ///   - action: Called on tap. Not called while disabled.
    public init(
        _ label: String,
        variant: Variant = .filled,
        size: Size = .large,
        leftIcon: SPIconName? = nil,
        rightIcon: SPIconName? = nil,
        showsLabel: Bool = true,
        isFullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.variant = variant
        self.size = size
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
        self.showsLabel = showsLabel
        self.isFullWidth = isFullWidth
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: SPSpacing.sm) {
                if let leftIcon { SPIcon(leftIcon, size: 24) }
                if showsLabel {
                    Text(label)
                        .spTextStyle(.button)
                        .lineLimit(1)
                        .fixedSize()
                }
                if let rightIcon { SPIcon(rightIcon, size: 24) }
            }
        }
        .buttonStyle(SPButtonStyle(variant: variant, size: size, isFullWidth: isFullWidth))
        .accessibilityLabel(label)
    }
}

/// The Sparkline button look as a `ButtonStyle`, for custom button content.
///
/// ```swift
/// Button { … } label: { Label("Share", systemImage: "square.and.arrow.up") }
///     .buttonStyle(SPButtonStyle(variant: .outlined))
/// ```
public struct SPButtonStyle: ButtonStyle {
    let variant: SPButton.Variant
    let size: SPButton.Size
    let isFullWidth: Bool

    public init(variant: SPButton.Variant = .filled, size: SPButton.Size = .large, isFullWidth: Bool = false) {
        self.variant = variant
        self.size = size
        self.isFullWidth = isFullWidth
    }

    public func makeBody(configuration: Configuration) -> some View {
        SPButtonBody(configuration: configuration, variant: variant, size: size, isFullWidth: isFullWidth)
    }
}

private struct SPButtonBody: View {
    let configuration: ButtonStyleConfiguration
    let variant: SPButton.Variant
    let size: SPButton.Size
    let isFullWidth: Bool

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.isFocused) private var isFocused
    @Environment(\.spForcedInteractionState) private var forced
    @State private var isHovered = false

    private var state: SPInteractionState {
        SPInteractionResolver(forced: forced, isPressed: configuration.isPressed, isFocused: isFocused, isHovered: isHovered).state
    }

    var body: some View {
        let colors = SPButtonColors(variant: variant, state: state, isEnabled: isEnabled)
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

    init(variant: SPButton.Variant, state: SPInteractionState, isEnabled: Bool) {
        switch variant {
        case .filled:
            guard isEnabled else {
                background = .spSurfaceDisabled
                foreground = .spTextOnDisabled
                return
            }
            foreground = .spTextInverse
            background = state == .default ? .spSurfaceBrand : .spActionBrandBorder
            hasShadow = true

        case .outlined:
            guard isEnabled else {
                foreground = .spTextDisabled
                border = .spBorderDisabled
                return
            }
            switch state {
            case .default:
                foreground = .spTextBrand
                border = .spBorderDefault
            case .hover, .pressed:
                foreground = .spActionBrandText
                border = .spActionBrandBorder
                background = .spSurfaceHoverBg
            case .focus:
                foreground = .spActionBrandText
                border = .spActionBrandBorder
            }

        case .text:
            guard isEnabled else {
                foreground = .spTextDisabled
                return
            }
            switch state {
            case .default:
                foreground = .spTextBrand
            case .hover:
                foreground = .spActionBrandText
                background = .spSurfaceHoverBg
            case .pressed:
                foreground = .spActionBrandText
                background = .spSurfaceHoverBg
                border = .spActionBrandBorder
            case .focus:
                foreground = .spActionBrandText
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
            ForEach(SPButton.Variant.allCases, id: \.self) { variant in
                HStack(spacing: SPSpacing.md) {
                    SPButton("Button", variant: variant) {}
                    SPButton("Button", variant: variant, size: .small, leftIcon: .arrowLeft) {}
                    SPButton("Button", variant: variant) {}.disabled(true)
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
