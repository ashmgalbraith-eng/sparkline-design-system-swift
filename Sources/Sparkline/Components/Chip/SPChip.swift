import SwiftUI

/// A compact pill for a tag, filter or selection. Pass `onRemove` to make it
/// clearable: a remove button appears on the right.
///
/// ```swift
/// ForEach(filters, id: \.self) { filter in
///     SPChip(filter) { filters.removeAll { $0 == filter } }
/// }
/// ```
public struct SPChip: View {
    let label: String
    let leftIcon: SPIconName?
    let rightIcon: SPIconName?
    let onRemove: (() -> Void)?

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.spForcedInteractionState) private var forced
    @State private var isHovered = false

    /// - Parameters:
    ///   - label: Visible text.
    ///   - leftIcon: Optional icon before the label.
    ///   - rightIcon: Optional icon after the label. Ignored when the chip is clearable.
    ///   - onRemove: When set, the chip is clearable and shows a remove button that calls this.
    ///     The chip does not remove itself; drop it from your data here.
    public init(
        _ label: String,
        leftIcon: SPIconName? = nil,
        rightIcon: SPIconName? = nil,
        onRemove: (() -> Void)? = nil
    ) {
        self.label = label
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
        self.onRemove = onRemove
    }

    private var state: SPInteractionState {
        SPInteractionResolver(forced: forced, isPressed: false, isFocused: false, isHovered: isHovered).state
    }

    public var body: some View {
        let style = ChipStyle(state: state, isEnabled: isEnabled)
        let shape = RoundedRectangle(cornerRadius: style.radius, style: .continuous)

        HStack(spacing: SPSpacing.sm) {
            if let leftIcon { SPIcon(leftIcon, size: 24) }
            Text(label)
                .spType(.body2)
                .lineLimit(1)
                .fixedSize()
            if let onRemove {
                Button(action: onRemove) {
                    SPIcon(.closeCircleOutline, size: 24)
                        .foregroundStyle(isEnabled ? SPColor.textSecondary : SPColor.textDisabled)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Remove \(label)")
            } else if let rightIcon {
                SPIcon(rightIcon, size: 24)
            }
        }
        .foregroundStyle(style.foreground)
        .padding(SPSpacing.sm)
        .frame(minHeight: 32)
        .background(shape.fill(style.background))
        .overlay(shape.strokeBorder(style.border, lineWidth: style.borderWidth))
        .onHover { isHovered = $0 }
        .animation(.easeOut(duration: 0.15), value: state)
        .accessibilityElement(children: .combine)
    }
}

private struct ChipStyle {
    var background: Color = SPColor.surfaceSubtle
    var foreground: Color = SPColor.textPrimary
    var border: Color = .clear
    var borderWidth: CGFloat = 1
    var radius: CGFloat = SPRadius.full

    init(state: SPInteractionState, isEnabled: Bool) {
        guard isEnabled else {
            background = SPColor.surfaceSubtleDisabled
            foreground = SPColor.textDisabled
            border = SPColor.borderDisabled
            borderWidth = 2
            return
        }
        switch state {
        case .default:
            break
        case .hover:
            border = SPColor.actionStrongBorder
        case .pressed:
            border = SPColor.actionStrongBorder
            borderWidth = 2
        case .focus:
            border = SPColor.actionStrongBorder
            borderWidth = 2
            radius = SPRadius.lg
        }
    }
}

struct SPChip_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: SPSpacing.md) {
            HStack {
                SPChip("Plain")
                SPChip("Icons", leftIcon: .checkCircleOutline, rightIcon: .menuDownOutline)
                SPChip("Clearable") {}
            }
            HStack {
                ForEach(SPInteractionState.allCases, id: \.self) { state in
                    SPChip(state.rawValue.capitalized).spInteractionState(state)
                }
                SPChip("Disabled") {}.disabled(true)
            }
        }
        .padding()
    }
}
