import SwiftUI
import Sparkline

/// Every page in the catalog, grouped like the Storybook sidebar.
enum CatalogPage: String, CaseIterable, Identifiable, Hashable {
    case colors = "Colors"
    case typography = "Typography"
    case spacing = "Spacing & Radius"
    case shadows = "Shadows"
    case icons = "Icon Gallery"

    case avatar = "Avatar"
    case badge = "Badge"
    case button = "Button"
    case buttonGroup = "ButtonGroup"
    case card = "Card"
    case checkbox = "Checkbox"
    case chip = "Chip"
    case icon = "Icon"
    case input = "Input"
    case radio = "Radio"
    case select = "Select"
    case slider = "Slider"
    case stepper = "Stepper"
    case `switch` = "Switch"

    var id: String { rawValue }

    static let foundations: [CatalogPage] = [.colors, .typography, .spacing, .shadows, .icons]
    static let components: [CatalogPage] = allCases.filter { !foundations.contains($0) }

    var icon: SPIconName {
        switch self {
        case .colors: return .cogOutline
        case .typography: return .fileDocumentOutline
        case .spacing: return .dotsGrid
        case .shadows: return .contentCopy
        case .icons: return .star
        case .avatar: return .accountOutline
        case .badge: return .bellOutline
        case .button, .buttonGroup: return .menuSwapOutline
        case .card: return .cardAccountDetailsOutline
        case .checkbox: return .checkCircleOutline
        case .chip: return .filterOutline
        case .icon: return .heartOutline
        case .input: return .pencilOutline
        case .radio: return .menuRightOutline
        case .select: return .menuDownOutline
        case .slider: return .chartLine
        case .stepper: return .clockOutline
        case .switch: return .refresh
        }
    }

    @MainActor @ViewBuilder
    var view: some View {
        switch self {
        case .colors: ColorsPage()
        case .typography: TypographyPage()
        case .spacing: SpacingPage()
        case .shadows: ShadowsPage()
        case .icons: IconGalleryPage()
        case .avatar: AvatarPage()
        case .badge: BadgePage()
        case .button: ButtonPage()
        case .buttonGroup: ButtonGroupPage()
        case .card: CardPage()
        case .checkbox: CheckboxPage()
        case .chip: ChipPage()
        case .icon: IconPage()
        case .input: InputPage()
        case .radio: RadioPage()
        case .select: SelectPage()
        case .slider: SliderPage()
        case .stepper: StepperPage()
        case .switch: SwitchPage()
        }
    }
}

enum Appearance: String, CaseIterable, Identifiable {
    case system = "System", light = "Light", dark = "Dark"
    var id: String { rawValue }
    var scheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

struct CatalogRoot: View {
    @State private var selection: CatalogPage? = .button
    @State private var appearance: Appearance = .system
    @State private var typeSize: DynamicTypeSize = .large

    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                Section("Foundations") {
                    ForEach(CatalogPage.foundations) { row($0) }
                }
                Section("Components") {
                    ForEach(CatalogPage.components) { row($0) }
                }
            }
            .navigationTitle("Sparkline")
        } detail: {
            NavigationStack {
                if let selection {
                    selection.view
                        .navigationTitle(selection.rawValue)
                } else {
                    Text("Choose a page").foregroundStyle(SPColor.textSecondary)
                }
            }
            .toolbar {
                ToolbarItem {
                    Menu {
                        Picker("Appearance", selection: $appearance) {
                            ForEach(Appearance.allCases) { Text($0.rawValue).tag($0) }
                        }
                        Picker("Text size", selection: $typeSize) {
                            Text("Small").tag(DynamicTypeSize.small)
                            Text("Default").tag(DynamicTypeSize.large)
                            Text("Extra large").tag(DynamicTypeSize.xxLarge)
                            Text("Accessibility").tag(DynamicTypeSize.accessibility2)
                        }
                    } label: {
                        SPIcon(.cogOutline, accessibilityLabel: "Display settings")
                    }
                }
            }
        }
        .tint(SPColor.surfaceBrand)
        .preferredColorScheme(appearance.scheme)
        .dynamicTypeSize(typeSize)
    }

    private func row(_ page: CatalogPage) -> some View {
        NavigationLink(value: page) {
            Label {
                Text(page.rawValue)
            } icon: {
                SPIcon(page.icon, size: 20).foregroundStyle(SPColor.textBrand)
            }
        }
    }
}
