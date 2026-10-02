import SwiftUI

/// A range control for picking a number between a minimum and maximum.
///
/// ```swift
/// Text(deposit, format: .currency(code: "USD").precision(.fractionLength(0)))
/// SPSlider("Deposit amount", value: $deposit, in: 500...50_000, step: 500)
/// ```
public struct SPSlider: View {
    let label: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let showsValue: Bool

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.isFocused) private var isFocused

    /// - Parameters:
    ///   - label: Accessibility label. Not shown; put a visible label above the slider.
    ///   - value: The current value. Clamped to `range` when dragged.
    ///   - range: Minimum and maximum. Defaults to 0...100.
    ///   - step: Increment. Pass 0 for continuous values.
    ///   - showsValue: Shows the raw number to the right, unformatted.
    public init(
        _ label: String,
        value: Binding<Double>,
        in range: ClosedRange<Double> = 0...100,
        step: Double = 1,
        showsValue: Bool = false
    ) {
        self.label = label
        self._value = value
        self.range = range
        self.step = step
        self.showsValue = showsValue
    }

    private var fraction: CGFloat {
        let span = range.upperBound - range.lowerBound
        guard span > 0 else { return 0 }
        return CGFloat(min(max((value - range.lowerBound) / span, 0), 1))
    }

    public var body: some View {
        HStack(spacing: SPSpacing.sm) {
            GeometryReader { geo in
                let thumb: CGFloat = 20
                let x = fraction * geo.size.width
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.spControlTrack)
                        .frame(height: 4)
                    Capsule()
                        .fill(isEnabled ? Color.spControlTrackActive : Color.spControlThumbDisabled)
                        .frame(width: x, height: 4)
                    Circle()
                        .fill(isEnabled ? Color.spControlTrackActive : Color.spControlThumbDisabled)
                        .frame(width: thumb, height: thumb)
                        .spShadowIf(isEnabled, .button)
                        .spFocusRing(isFocused && isEnabled, cornerRadius: thumb / 2, lineWidth: 2)
                        .offset(x: x - thumb / 2)
                }
                .frame(maxHeight: .infinity)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { drag in update(to: drag.location.x / max(geo.size.width, 1)) }
                )
            }
            .frame(height: 20)

            if showsValue {
                Text(formatted)
                    .spTextStyle(.body2)
                    .monospacedDigit()
                    .foregroundStyle(isEnabled ? Color.spTextPrimary : Color.spTextDisabled)
                    .fixedSize()
            }
        }
        .accessibilityRepresentation {
            if step > 0 {
                Slider(value: $value, in: range, step: step) { Text(label) }
            } else {
                Slider(value: $value, in: range) { Text(label) }
            }
        }
    }

    private var formatted: String {
        value.rounded() == value ? String(Int(value)) : String(value)
    }

    private func update(to fraction: CGFloat) {
        let f = Double(min(max(fraction, 0), 1))
        var newValue = range.lowerBound + f * (range.upperBound - range.lowerBound)
        if step > 0 {
            newValue = range.lowerBound + ((newValue - range.lowerBound) / step).rounded() * step
            newValue = min(newValue, range.upperBound)
        }
        if newValue != value { value = newValue }
    }
}

struct SPSlider_Previews: PreviewProvider {
    struct Demo: View {
        @State var value = 50.0
        @State var deposit = 5_000.0
        var body: some View {
            VStack(spacing: SPSpacing.lg) {
                SPSlider("Value", value: $value, showsValue: true)
                SPSlider("Deposit", value: $deposit, in: 500...50_000, step: 500, showsValue: true)
                SPSlider("Disabled", value: $value).disabled(true)
            }
            .padding()
        }
    }

    static var previews: some View { Demo() }
}
