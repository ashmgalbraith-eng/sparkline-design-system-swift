import Testing
import SwiftUI
import CoreText
@testable import Sparkline

@Test func everyIconHasAPath() {
    let rect = CGRect(x: 0, y: 0, width: 24, height: 24)
    for icon in SPIconName.allCases {
        let bounds = icon.path(in: rect).boundingRect
        #expect(!bounds.isEmpty, "\(icon.rawValue) has no path")
        #expect(rect.insetBy(dx: -0.5, dy: -0.5).contains(bounds), "\(icon.rawValue) draws outside its 24×24 grid")
    }
}

@Test func iconCountMatchesWebRegistry() {
    #expect(SPIconName.allCases.count == 62)
}

@Test func semanticColorCount() {
    #expect(SPColorToken.allCases.count == 46)
}

@Test func bundledFontsRegister() {
    #expect(SPFonts.register() == 9)
    for name in ["Roboto-Regular", "Roboto-Medium", "Roboto-Bold", "Roboto-Black", "Manrope-Regular", "Manrope-ExtraBold"] {
        let font = CTFontCreateWithName(name as CFString, 12, nil)
        #expect(CTFontCopyPostScriptName(font) as String == name, "\(name) is not available")
    }
}

/// Swift names follow the shared rule: --{group}-{name} is SP{Group}.{camelName}.
@Test func tokenNamesMatchCSS() {
    func camel(_ css: String, dropping prefix: String) -> String {
        let parts = css.dropFirst(prefix.count).split(separator: "-")
        return parts.enumerated().map { $0.offset == 0 ? String($0.element) : $0.element.capitalized }.joined()
    }
    for token in SPColorToken.allCases {
        #expect("\(token)" == camel(token.rawValue, dropping: "--color-"))
    }
    for style in SPType.allCases {
        #expect("\(style)" == camel(style.rawValue, dropping: "--type-"))
    }
    for shadow in SPShadow.allCases {
        #expect("\(shadow)" == camel(shadow.rawValue, dropping: "--shadow-"))
    }
}

@Test func generatedValuesMatchCSS() {
    #expect(SPSpacing.md == 16)
    #expect(SPRadius.full == 999)
    #expect(SPType.body1.metrics(regularWidth: false) == SPTypeMetrics(size: 16, weight: .regular, lineHeight: 24, tracking: 0))
    // --type-headline-1 at the 768px breakpoint: 40px, 115%, -1px.
    #expect(SPType.headline1.metrics(regularWidth: true) == SPTypeMetrics(size: 40, weight: .bold, lineHeight: 46, tracking: -1))
    // --shadow-md: 0 4px 6px -1px → radius (6 - 1) / 2.
    #expect(SPShadow.md.radius == 2.5 && SPShadow.md.y == 4)
}
