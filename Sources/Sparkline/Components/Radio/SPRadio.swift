import SwiftUI

/// A set of radio buttons where exactly one option is selected.
///
/// ```swift
/// SPRadioGroup("Funding source", selection: $source, options: [
///     .init("bank", label: "Transfer from another bank"),
///     .init("check", label: "Mail a check"),
/// ])
/// ```
public struct SPRadioGroup<Value: Hashable>: View {
    /// One option.
    public struct Option: Identifiable {
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

    let title: String
    @Binding var selection: Value
    let options: [Option]

    /// - Parameters:
    ///   - title: The group's accessibility label. Not shown; put a visible heading above the group.
    ///   - selection: The selected option's value.
    ///   - options: Two to five options.
    public init(_ title: String, selection: Binding<Value>, options: [Option]) {
        self.title = title
        self._selection = selection
        self.options = options
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(options) { option in
                SPRadio(option.label, isSelected: option.value == selection) {
                    selection = option.value
                }
                .disabled(option.isDisabled)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(title)
    }
}

/// A single labeled radio button. Prefer ``SPRadioGroup``; use this when you
/// lay radios out yourself.
///
/// Tapping a selected radio keeps it selected (`action` is still called).
public struct SPRadio: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    public init(_ label: String, isSelected: Bool, action: @escaping () -> Void) {
        self.label = label
        self.isSelected = isSelected
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(label).spTextStyle(.body1)
        }
        .buttonStyle(RadioStyle(isSelected: isSelected))
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }
}

private struct RadioStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        RadioBody(configuration: configuration, isSelected: isSelected)
    }
}

private struct RadioBody: View {
    let configuration: ButtonStyleConfiguration
    let isSelected: Bool

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.isFocused) private var isFocused
    @Environment(\.spForcedInteractionState) private var forced
    @State private var isHovered = false

    var body: some View {
        let state = SPInteractionResolver(forced: forced, isPressed: configuration.isPressed, isFocused: isFocused, isHovered: isHovered).state
        let ring: Color = !isEnabled ? .spBorderDisabled : (isSelected ? .spBorderDefault : .spBorderSubtle)

        HStack(spacing: SPSpacing.xs) {
            ZStack {
                Circle().fill(SPControlHalo.color(for: state, isEnabled: isEnabled))
                Circle()
                    .strokeBorder(ring, lineWidth: 2)
                    .frame(width: 24, height: 24)
                    .spFocusRing(isEnabled && state == .focus, cornerRadius: 12, lineWidth: 2)
                Circle()
                    .fill(isEnabled ? Color.spSurfaceBrand : Color.spSurfaceDisabled)
                    .frame(width: 8, height: 8)
                    .scaleEffect(isSelected ? 1 : 0)
            }
            .frame(width: 40, height: 40)

            configuration.label
                .foregroundStyle(isEnabled ? Color.spTextPrimary : Color.spTextDisabled)
                .multilineTextAlignment(.leading)
        }
        .contentShape(Rectangle())
        .onHover { isHovered = $0 }
        .animation(.easeOut(duration: 0.15), value: state)
        .animation(.easeOut(duration: 0.15), value: isSelected)
    }
}

struct SPRadio_Previews: PreviewProvider {
    struct Demo: View {
        @State var source = "bank"
        var body: some View {
            VStack(alignment: .leading, spacing: SPSpacing.lg) {
                SPRadioGroup("Funding source", selection: $source, options: [
                    .init("bank", label: "Transfer from another bank"),
                    .init("check", label: "Mail a check"),
                    .init("wire", label: "Wire transfer", isDisabled: true),
                ])
                SPRadio("Focus", isSelected: true) {}.spInteractionState(.focus)
            }
            .padding()
        }
    }

    static var previews: some View { Demo() }
}
