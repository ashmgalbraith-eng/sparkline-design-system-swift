import SwiftUI
import CoreText

// Hand-written companions to SPTokens+Generated.swift: how tokens are applied.
// The token values themselves are generated from the web CSS.

/// A text style's size, weight, line height and tracking, in points.
struct SPTypeMetrics: Equatable {
    let size: CGFloat
    let weight: Font.Weight
    /// Line height in points. `nil` means 100% (the font's own line height).
    let lineHeight: CGFloat?
    let tracking: CGFloat
}

/// Sparkline font families.
public enum SPFontFamily: String, CaseIterable, Sendable {
    /// Roboto (`--type-font-family-base`): every text style.
    case base = "Roboto"
    /// Manrope: the brand's secondary face, for marketing headings.
    case secondary = "Manrope"
}

extension SPType {
    /// The Dynamic Type style each Sparkline style scales with.
    var relativeTo: Font.TextStyle {
        switch self {
        case .display: return .largeTitle
        case .headline1: return .title
        case .headline2: return .title2
        case .headline3, .headline4: return .title3
        case .subtitle1, .label, .button: return .headline
        case .body1: return .body
        case .body2: return .subheadline
        case .caption: return .caption
        }
    }

    /// The style's font at compact width, without line height or tracking.
    public var font: Font { font(regularWidth: false, family: .base) }

    func font(regularWidth: Bool, family: SPFontFamily) -> Font {
        let m = metrics(regularWidth: regularWidth)
        return Font.custom(family.rawValue, size: m.size, relativeTo: relativeTo).weight(m.weight)
    }
}

/// Applies a full Sparkline text style: font, weight, line height and tracking.
private struct SPTypeModifier: ViewModifier {
    let style: SPType
    let family: SPFontFamily
    @Environment(\.horizontalSizeClass) private var sizeClass

    func body(content: Content) -> some View {
        let regular = sizeClass == .regular
        let m = style.metrics(regularWidth: regular)
        // Roboto's natural line height is about 1.17× its size.
        let spacing = m.lineHeight.map { max(0, $0 - m.size * 1.17) } ?? 0
        content
            .font(style.font(regularWidth: regular, family: family))
            .tracking(m.tracking)
            .lineSpacing(spacing)
    }
}

public extension View {
    /// Styles text with a Sparkline text style (`--type-<style>-*`).
    func spType(_ style: SPType, family: SPFontFamily = .base) -> some View {
        modifier(SPTypeModifier(style: style, family: family))
    }

    /// Applies a Sparkline elevation shadow (`--shadow-<name>`).
    func spShadow(_ shadow: SPShadow) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }

    /// Draws the focus ring (`--primary-30`) around the view, offset outward.
    func spFocusRing(_ isVisible: Bool, cornerRadius: CGFloat, lineWidth: CGFloat = 4, offset: CGFloat = 2) -> some View {
        overlay {
            if isVisible {
                RoundedRectangle(cornerRadius: cornerRadius + offset)
                    .strokeBorder(SPColor.focusRing, lineWidth: lineWidth)
                    .padding(-(offset + lineWidth))
                    .allowsHitTesting(false)
            }
        }
    }
}

/// Font registration for the bundled Roboto and Manrope files.
public enum SPFonts {
    /// Registers the bundled fonts with Core Text. Call once at launch, e.g. in your `App.init()`.
    ///
    /// Safe to call more than once. If the font files are missing, text falls back
    /// to the system font and this returns the number of files registered (0).
    @discardableResult
    public static func register() -> Int {
        guard let dir = Bundle.module.url(forResource: "Fonts", withExtension: nil),
              let files = try? FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil)
        else { return 0 }
        var count = 0
        for url in files where ["ttf", "otf"].contains(url.pathExtension.lowercased()) {
            var error: Unmanaged<CFError>?
            if CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error) {
                count += 1
            } else if let err = error?.takeRetainedValue(),
                      CFErrorGetCode(err) == CTFontManagerError.alreadyRegistered.rawValue {
                count += 1
            }
        }
        return count
    }
}
