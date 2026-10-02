import SwiftUI

/// Spacing scale. Mirrors `--spacing-*` in the CSS tokens.
public enum SPSpacing {
    /// 4pt
    public static let xs: CGFloat = 4
    /// 8pt
    public static let sm: CGFloat = 8
    /// 16pt
    public static let md: CGFloat = 16
    /// 24pt
    public static let lg: CGFloat = 24
    /// 32pt
    public static let xl: CGFloat = 32
}

/// Corner radius scale. Mirrors `--radius-*` in the CSS tokens.
public enum SPRadius {
    /// 2pt
    public static let sm: CGFloat = 2
    /// 4pt
    public static let md: CGFloat = 4
    /// 8pt
    public static let lg: CGFloat = 8
    /// 12pt
    public static let xl: CGFloat = 12
    /// 999pt: pills and circles.
    public static let full: CGFloat = 999
}

/// Elevation shadows. Mirrors `--shadow-*` in the CSS tokens.
public enum SPShadow: CaseIterable, Sendable {
    /// `0 1px 2px rgba(0,0,0,0.5)`. Reserved for buttons and control thumbs.
    case button
    /// `0 1px 2px rgba(0,0,0,0.05)`
    case sm
    /// `0 4px 6px -1px rgba(0,0,0,0.1)`
    case md
    /// `0 10px 15px -3px rgba(0,0,0,0.1)`
    case lg

    // CSS blur is roughly twice SwiftUI's shadow radius. Negative spread has no
    // SwiftUI equivalent, so it is folded into a slightly smaller radius.
    var color: Color {
        switch self {
        case .button: return Color(hex: 0x000000, opacity: 0.5)
        case .sm: return Color(hex: 0x000000, opacity: 0.05)
        case .md, .lg: return Color(hex: 0x000000, opacity: 0.1)
        }
    }

    var radius: CGFloat {
        switch self {
        case .button: return 1
        case .sm: return 1
        case .md: return 2.5
        case .lg: return 6
        }
    }

    var y: CGFloat {
        switch self {
        case .button, .sm: return 1
        case .md: return 4
        case .lg: return 10
        }
    }
}

public extension View {
    /// Applies a Sparkline elevation shadow.
    func spShadow(_ shadow: SPShadow) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: 0, y: shadow.y)
    }

    /// Draws the Sparkline focus ring (`--primary-30`) around the view, offset outward.
    func spFocusRing(_ isVisible: Bool, cornerRadius: CGFloat, lineWidth: CGFloat = 4, offset: CGFloat = 2) -> some View {
        overlay {
            if isVisible {
                RoundedRectangle(cornerRadius: cornerRadius + offset)
                    .strokeBorder(Color.spFocusRing, lineWidth: lineWidth)
                    .padding(-(offset + lineWidth))
                    .allowsHitTesting(false)
            }
        }
    }
}
