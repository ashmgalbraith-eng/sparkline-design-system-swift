import Testing
@testable import Sparkline

@Test func everyIconHasAPath() {
    let rect = CGRect(x: 0, y: 0, width: 24, height: 24)
    for icon in SPIconName.allCases {
        #expect(!icon.path(in: rect).isEmpty, "\(icon.rawValue) has no path")
    }
}

@Test func iconCountMatchesWebRegistry() {
    #expect(SPIconName.allCases.count == 62)
}

@Test func semanticColorCount() {
    #expect(SPColorToken.allCases.count == 46)
}
