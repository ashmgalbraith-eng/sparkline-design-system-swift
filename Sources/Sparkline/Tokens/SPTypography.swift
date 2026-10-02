import SwiftUI
import CoreText

/// Sparkline font families.
public enum SPFontFamily: String, CaseIterable, Sendable {
    /// Roboto: every text style (`--type-font-family-base`).
    case primary = "Roboto"
    /// Manrope: the brand's secondary face, for marketing headings.
    case secondary = "Manrope"
}

/// Sparkline text styles. Mirrors the `--type-*` tokens in the CSS.
///
/// Display and headline 1–3 grow on iPad (regular horizontal size class),
/// matching the CSS tablet breakpoint. All styles scale with Dynamic Type.
public enum SPTextStyle: String, CaseIterable, Sendable {
    case display
    case headline1
    case headline2
    case headline3
    case headline4
    case subtitle1
    case label
    case body1
    case body2
    case button
    case caption

    struct Metrics {
        let size: CGFloat
        let weight: Font.Weight
        /// Line height in points. `nil` means 100% (the font size).
        let lineHeight: CGFloat?
        let tracking: CGFloat
    }

    func metrics(regularWidth: Bool) -> Metrics {
        switch (self, regularWidth) {
        case (.display, false): return Metrics(size: 40, weight: .heavy, lineHeight: 46, tracking: 0)
        case (.display, true): return Metrics(size: 48, weight: .heavy, lineHeight: 52.8, tracking: 0)
        case (.headline1, false): return Metrics(size: 32, weight: .bold, lineHeight: 38.4, tracking: -0.5)
        case (.headline1, true): return Metrics(size: 40, weight: .bold, lineHeight: 46, tracking: -1)
        case (.headline2, false): return Metrics(size: 24, weight: .bold, lineHeight: 30, tracking: 0)
        case (.headline2, true): return Metrics(size: 32, weight: .bold, lineHeight: 38.4, tracking: -0.5)
        case (.headline3, false): return Metrics(size: 20, weight: .bold, lineHeight: nil, tracking: 0)
        case (.headline3, true): return Metrics(size: 24, weight: .bold, lineHeight: nil, tracking: 0)
        case (.headline4, _): return Metrics(size: 20, weight: .bold, lineHeight: nil, tracking: 0)
        case (.subtitle1, _): return Metrics(size: 18, weight: .bold, lineHeight: nil, tracking: 0)
        case (.label, _): return Metrics(size: 16, weight: .bold, lineHeight: nil, tracking: 0)
        case (.body1, _): return Metrics(size: 16, weight: .regular, lineHeight: 24, tracking: 0)
        case (.body2, _): return Metrics(size: 14, weight: .regular, lineHeight: 20, tracking: 0)
        case (.button, _): return Metrics(size: 16, weight: .bold, lineHeight: nil, tracking: 0)
        case (.caption, _): return Metrics(size: 12, weight: .regular, lineHeight: nil, tracking: 0)
        }
    }

    /// The Dynamic Type style each Sparkline style scales with.
    var relativeTo: Font.TextStyle {
        switch self {
        case .display: return .largeTitle
        case .headline1: return .title
        case .headline2: return .title2
        case .headline3, .headline4: return .title3
        case .subtitle1: return .headline
        case .label, .button: return .headline
        case .body1: return .body
        case .body2: return .subheadline
        case .caption: return .caption
        }
    }

    /// The style's font at compact width, without line height or tracking.
    public var font: Font { font(regularWidth: false) }

    func font(regularWidth: Bool, family: SPFontFamily = .primary) -> Font {
        let m = metrics(regularWidth: regularWidth)
        return Font.custom(family.rawValue, size: m.size, relativeTo: relativeTo).weight(m.weight)
    }
}

/// Applies a full Sparkline text style: font, weight, line height and tracking.
struct SPTextStyleModifier: ViewModifier {
    let style: SPTextStyle
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
    /// Styles text with a Sparkline text style (`--type-<style>-*` tokens).
    func spTextStyle(_ style: SPTextStyle, family: SPFontFamily = .primary) -> some View {
        modifier(SPTextStyleModifier(style: style, family: family))
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
