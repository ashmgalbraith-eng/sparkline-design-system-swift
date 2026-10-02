import SwiftUI

/// A labeled checkbox for on/off choices and consent, with an optional
/// indeterminate (mixed) state.
///
/// ```swift
/// SPCheckbox("I have read and agree to the account disclosures", isOn: $agreed)
/// SPButton("Open account") { submit() }.disabled(!agreed)
/// ```
public struct SPCheckbox: View {
    let label: String
    @Binding var isOn: Bool
    let isIndeterminate: Bool

    /// - Parameters:
    ///   - label: Visible text.
    ///   - isOn: The checked state.
    ///   - isIndeterminate: Shows a dash instead of a check. Tapping an indeterminate
    ///     checkbox sets `isOn` to `true`; clearing `isIndeterminate` is up to you
    ///     (it is usually derived from child checkboxes).
    public init(_ label: String, isOn: Binding<Bool>, isIndeterminate: Bool = false) {
        self.label = label
        self._isOn = isOn
        self.isIndeterminate = isIndeterminate
    }

    public var body: some View {
        Button {
            isOn = isIndeterminate ? true : !isOn
        } label: {
            Text(label).spTextStyle(.body1)
        }
        .buttonStyle(CheckboxStyle(isOn: isOn, isIndeterminate: isIndeterminate))
        .accessibilityAddTraits(.isToggle)
        .accessibilityValue(isIndeterminate ? "Mixed" : (isOn ? "Checked" : "Unchecked"))
    }
}

private struct CheckboxStyle: ButtonStyle {
    let isOn: Bool
    let isIndeterminate: Bool

    func makeBody(configuration: Configuration) -> some View {
        CheckboxBody(configuration: configuration, isOn: isOn, isIndeterminate: isIndeterminate)
    }
}

private struct CheckboxBody: View {
    let configuration: ButtonStyleConfiguration
    let isOn: Bool
    let isIndeterminate: Bool

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.isFocused) private var isFocused
    @Environment(\.spForcedInteractionState) private var forced
    @State private var isHovered = false

    var body: some View {
        let state = SPInteractionResolver(forced: forced, isPressed: configuration.isPressed, isFocused: isFocused, isHovered: isHovered).state
        let filled = isOn || isIndeterminate
        let box: Color = !isEnabled ? .spBorderDisabled : (filled ? .spSurfaceBrand : .spBorderSubtle)
        let fill: Color = !filled ? .clear : (isEnabled ? .spSurfaceBrand : .spSurfaceDisabled)

        HStack(spacing: SPSpacing.xs) {
            ZStack {
                RoundedRectangle(cornerRadius: SPRadius.md)
                    .fill(SPControlHalo.color(for: state, isEnabled: isEnabled))
                RoundedRectangle(cornerRadius: SPRadius.sm)
                    .fill(fill)
                    .overlay(RoundedRectangle(cornerRadius: SPRadius.sm).strokeBorder(box, lineWidth: 2))
                    .frame(width: 20, height: 20)
                    .overlay {
                        if isIndeterminate {
                            DashShape().stroke(Color.spTextInverse, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                                .frame(width: 10, height: 2)
                        } else if isOn {
                            CheckShape().stroke(Color.spTextInverse, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                                .frame(width: 12, height: 10)
                        }
                    }
                    .spFocusRing(isEnabled && state == .focus, cornerRadius: SPRadius.sm, lineWidth: 2)
            }
            .frame(width: 40, height: 40)

            configuration.label
                .foregroundStyle(isEnabled ? Color.spTextPrimary : Color.spTextDisabled)
                .multilineTextAlignment(.leading)
        }
        .contentShape(Rectangle())
        .onHover { isHovered = $0 }
        .animation(.easeOut(duration: 0.15), value: state)
        .animation(.easeOut(duration: 0.1), value: filled)
    }
}

/// The 40pt touch-target halo shared by Checkbox and Radio.
enum SPControlHalo {
    static func color(for state: SPInteractionState, isEnabled: Bool) -> Color {
        guard isEnabled else { return .clear }
        switch state {
        case .default: return .clear
        case .hover: return .spSurfaceHoverBg
        case .pressed, .focus: return .spSurfaceBrandSubtle
        }
    }
}

/// The check mark from the web component's 12×10 SVG.
private struct CheckShape: Shape {
    func path(in rect: CGRect) -> Path {
        let sx = rect.width / 12, sy = rect.height / 10
        var p = Path()
        p.move(to: CGPoint(x: 1 * sx, y: 5 * sy))
        p.addLine(to: CGPoint(x: 4.5 * sx, y: 8.5 * sy))
        p.addLine(to: CGPoint(x: 11 * sx, y: 1.5 * sy))
        return p
    }
}

private struct DashShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX + 1, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.maxX - 1, y: rect.midY))
        return p
    }
}

struct SPCheckbox_Previews: PreviewProvider {
    struct Demo: View {
        @State var a = true
        @State var b = false
        var body: some View {
            VStack(alignment: .leading) {
                SPCheckbox("Checked", isOn: $a)
                SPCheckbox("Unchecked", isOn: $b)
                SPCheckbox("Indeterminate", isOn: $b, isIndeterminate: true)
                SPCheckbox("Disabled", isOn: $a).disabled(true)
                SPCheckbox("Hover", isOn: $b).spInteractionState(.hover)
                SPCheckbox("Focus", isOn: $a).spInteractionState(.focus)
            }
            .padding()
        }
    }

    static var previews: some View { Demo() }
}
