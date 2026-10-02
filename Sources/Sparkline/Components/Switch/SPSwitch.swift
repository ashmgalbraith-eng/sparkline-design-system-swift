import SwiftUI

/// An on/off toggle for settings that take effect immediately.
///
/// ```swift
/// SPSwitch("Paperless statements", isOn: $paperless)
/// ```
///
/// To style a plain `Toggle`, use `.toggleStyle(.sparkline)`.
public struct SPSwitch: View {
    let label: String
    let showsLabel: Bool
    @Binding var isOn: Bool

    /// - Parameters:
    ///   - label: Shown leading, with the switch trailing. Always read by VoiceOver.
    ///   - isOn: The switch state.
    ///   - showsLabel: `false` hides the text visually; put your own visible label beside it.
    public init(_ label: String, isOn: Binding<Bool>, showsLabel: Bool = true) {
        self.label = label
        self._isOn = isOn
        self.showsLabel = showsLabel
    }

    public var body: some View {
        Toggle(isOn: $isOn) {
            if showsLabel {
                Text(label)
                    .spTextStyle(.body1)
                    .foregroundStyle(.spTextPrimary)
            }
        }
        .toggleStyle(SPSwitchToggleStyle())
        .accessibilityLabel(label)
    }
}

/// The Sparkline switch look for any `Toggle`.
public struct SPSwitchToggleStyle: ToggleStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        SPSwitchBody(configuration: configuration)
    }
}

public extension ToggleStyle where Self == SPSwitchToggleStyle {
    /// The Sparkline switch.
    static var sparkline: SPSwitchToggleStyle { SPSwitchToggleStyle() }
}

private struct SPSwitchBody: View {
    let configuration: ToggleStyleConfiguration
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.isFocused) private var isFocused

    var body: some View {
        let track: Color = !isEnabled
            ? .spControlTrackDisabled
            : (configuration.isOn ? .spControlTrackActive : .spControlTrack)

        Button {
            configuration.isOn.toggle()
        } label: {
            HStack(spacing: SPSpacing.md) {
                configuration.label
                    .frame(maxWidth: .infinity, alignment: .leading)
                Capsule()
                    .fill(track)
                    .frame(width: 56, height: 32)
                    .overlay(alignment: configuration.isOn ? .trailing : .leading) {
                        Circle()
                            .fill(Color.spControlThumbInverse)
                            .frame(width: 24, height: 24)
                            .spShadow(.button)
                            .padding(4)
                    }
                    .spFocusRing(isFocused && isEnabled, cornerRadius: 16, lineWidth: 2)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
        .accessibilityRepresentation {
            Toggle(isOn: configuration.$isOn) { configuration.label }
        }
    }
}

struct SPSwitch_Previews: PreviewProvider {
    struct Demo: View {
        @State var on = true
        @State var off = false
        var body: some View {
            VStack(spacing: SPSpacing.md) {
                SPSwitch("Paperless statements", isOn: $on)
                SPSwitch("Notifications", isOn: $off)
                SPSwitch("Disabled", isOn: $on).disabled(true)
            }
            .padding()
        }
    }

    static var previews: some View { Demo() }
}
