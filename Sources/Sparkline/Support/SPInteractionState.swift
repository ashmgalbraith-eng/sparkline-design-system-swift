import SwiftUI

/// The interactive states Sparkline controls style themselves for.
///
/// At runtime the state comes from the pointer (iPad hover), touch (pressed) and
/// keyboard focus. For documentation and snapshots you can pin a state with
/// `.spInteractionState(_:)`, the equivalent of the web
/// components' `state="hover"` input.
public enum SPInteractionState: String, CaseIterable, Sendable {
    case `default`
    case hover
    case pressed
    case focus
}

private struct SPForcedInteractionStateKey: EnvironmentKey {
    static let defaultValue: SPInteractionState? = nil
}

extension EnvironmentValues {
    var spForcedInteractionState: SPInteractionState? {
        get { self[SPForcedInteractionStateKey.self] }
        set { self[SPForcedInteractionStateKey.self] = newValue }
    }
}

public extension View {
    /// Pins Sparkline controls inside this view to one interactive state.
    /// Meant for catalogs, previews and snapshot tests, not product screens.
    func spInteractionState(_ state: SPInteractionState?) -> some View {
        environment(\.spForcedInteractionState, state)
    }
}

/// Resolves the effective interactive state, in the same priority order as the
/// web components: forced state, then pressed, focus, hover.
struct SPInteractionResolver {
    var forced: SPInteractionState?
    var isPressed: Bool
    var isFocused: Bool
    var isHovered: Bool

    var state: SPInteractionState {
        if let forced { return forced }
        if isPressed { return .pressed }
        if isFocused { return .focus }
        if isHovered { return .hover }
        return .default
    }
}
