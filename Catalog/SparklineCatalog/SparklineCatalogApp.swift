import SwiftUI
import Sparkline

@main
struct SparklineCatalogApp: App {
    init() {
        SPFonts.register()
    }

    var body: some Scene {
        WindowGroup {
            CatalogRoot()
        }
    }
}
