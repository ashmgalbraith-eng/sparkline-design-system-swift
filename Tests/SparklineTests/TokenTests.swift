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
