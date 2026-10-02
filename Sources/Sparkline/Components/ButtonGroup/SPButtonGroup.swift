import SwiftUI

/// Height of a button group: large is 48pt, small is 36pt.
public enum SPButtonGroupSize: String, CaseIterable, Sendable {
    case large, small
}

/// A segmented control: a row of connected buttons where exactly one is selected.
///
/// ```swift
/// enum Period: Hashable { case monthly, yearly }
/// @State private var period = Period.monthly
///
/// SPButtonGroup(selection: $period, items: [
///     .init(.monthly, label: "Monthly"),
///     .init(.yearly, label: "Yearly"),
/// ])
/// ```
public struct SPButtonGroup<Value: Hashable>: View {
    public typealias Size = SPButtonGroupSize

    /// One segment.
    public struct Item: Identifiable {
        public let value: Value
        public let label: String
        public let leftIcon: SPIconName?
        public let rightIcon: SPIconName?
        public var id: Value { value }

        /// - Parameters:
        ///   - value: The value written to `selection` when this segment is tapped.
        ///   - label: Visible text. Also the accessibility label when labels are hidden.
        ///   - leftIcon: Optional icon before the label.
        ///   - rightIcon: Optional icon after the label.
        public init(_ value: Value, label: String, leftIcon: SPIconName? = nil, rightIcon: SPIconName? = nil) {
            self.value = value
            self.label = label
            self.leftIcon = leftIcon
            self.rightIcon = rightIcon
        }
    }

    @Binding var selection: Value
    let items: [Item]
    let size: Size
    let showsLabels: Bool

    @Environment(\.isEnabled) private var isEnabled

    /// - Parameters:
    ///   - selection: The selected item's value.
    ///   - items: Two to five segments.
    ///   - size: `.large` (48pt) or `.small` (36pt).
    ///   - showsLabels: `false` shows icons only. Labels are still read by VoiceOver.
    public init(selection: Binding<Value>, items: [Item], size: Size = .large, showsLabels: Bool = true) {
        self._selection = selection
        self.items = items
        self.size = size
        self.showsLabels = showsLabels
    }

    public var body: some View {
        let divider = isEnabled ? Color.spBorderDefault : Color.spBorderDisabled
        let shape = RoundedRectangle(cornerRadius: SPRadius.md, style: .continuous)
        HStack(spacing: 1) {
            ForEach(items) { item in
                Button {
                    selection = item.value
                } label: {
                    HStack(spacing: SPSpacing.sm) {
                        if let icon = item.leftIcon { SPIcon(icon, size: 24) }
                        if showsLabels {
                            Text(item.label)
                                .spTextStyle(.button)
                                .lineLimit(1)
                                .fixedSize()
                        }
                        if let icon = item.rightIcon { SPIcon(icon, size: 24) }
                    }
                }
                .buttonStyle(SegmentStyle(isSelected: item.value == selection, size: size))
                .accessibilityLabel(item.label)
                .accessibilityAddTraits(item.value == selection ? .isSelected : [])
            }
        }
        // 1pt gaps show the background through as dividers, as on the web.
        .background(divider)
        .clipShape(shape)
        .overlay(shape.strokeBorder(divider, lineWidth: 2))
        .fixedSize(horizontal: false, vertical: true)
    }
}

private struct SegmentStyle: ButtonStyle {
    let isSelected: Bool
    let size: SPButtonGroupSize

    func makeBody(configuration: Configuration) -> some View {
        SegmentBody(configuration: configuration, isSelected: isSelected, size: size)
    }
}

private struct SegmentBody: View {
    let configuration: ButtonStyleConfiguration
    let isSelected: Bool
    let size: SPButtonGroupSize

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.isFocused) private var isFocused
    @State private var isHovered = false

    var body: some View {
        let active = isHovered || configuration.isPressed || isFocused
        let background: Color = {
            if !isEnabled { return .spSurfaceDisabled }
            if isSelected { return active ? .spActionBrandBorder : .spSurfaceBrand }
            return active ? .spSurfaceHoverBg : .spSurfaceDefault
        }()
        let foreground: Color = !isEnabled ? .spTextDisabled : (isSelected ? .spTextInverse : .spTextBrand)

        configuration.label
            .foregroundStyle(foreground)
            .padding(.horizontal, SPSpacing.md)
            .padding(.vertical, SPSpacing.sm)
            .frame(maxHeight: .infinity)
            .frame(minHeight: size == .large ? 44 : 32) // + 2pt border on each side = 48 / 36
            .background(background)
            .overlay {
                if isFocused && isEnabled {
                    Rectangle().strokeBorder(Color.spFocusRing, lineWidth: 4)
                }
            }
            .contentShape(Rectangle())
            .onHover { isHovered = $0 }
            .animation(.easeOut(duration: 0.15), value: isSelected)
    }
}

struct SPButtonGroup_Previews: PreviewProvider {
    struct Demo: View {
        @State var selection = 0
        var body: some View {
            VStack(alignment: .leading, spacing: SPSpacing.md) {
                SPButtonGroup(selection: $selection, items: (0..<3).map { .init($0, label: "Button") })
                SPButtonGroup(selection: $selection, items: (0..<3).map { .init($0, label: "Button", leftIcon: .arrowLeft) }, size: .small)
                SPButtonGroup(selection: $selection, items: (0..<2).map { .init($0, label: "Button") }).disabled(true)
            }
            .padding()
        }
    }

    static var previews: some View { Demo() }
}
