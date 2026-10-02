import SwiftUI
import Sparkline

struct ColorsPage: View {
    private let groups: [(String, String)] = [
        ("Text", "text"), ("Surface", "surface"), ("Border", "border"),
        ("Action", "action"), ("Control", "control"),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SPSpacing.xl) {
                Text("Semantic color tokens, generated from the web design system's CSS. Each resolves to its light or dark value automatically; switch Appearance in the toolbar to compare.")
                    .spTextStyle(.body1)
                    .foregroundStyle(.spTextSecondary)
                ForEach(groups, id: \.1) { title, prefix in
                    CatalogSection(title) {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 200), spacing: SPSpacing.md)], spacing: SPSpacing.md) {
                            ForEach(SPColorToken.allCases.filter { $0.rawValue.hasPrefix("color-\(prefix)") }, id: \.self) { token in
                                swatch(token)
                            }
                        }
                    }
                }
                CatalogSection("Focus ring") {
                    swatch(name: "Color.spFocusRing", token: "--primary-30", color: .spFocusRing)
                }
            }
            .padding(SPSpacing.lg)
        }
        .background(Color.spSurfaceSubtle)
    }

    private func swatch(_ token: SPColorToken) -> some View {
        let name = "sp" + token.rawValue.dropFirst("color-".count)
            .split(separator: "-").map { $0.prefix(1).uppercased() + $0.dropFirst() }.joined()
        return swatch(name: name, token: "--\(token.rawValue)", color: token.color)
    }

    private func swatch(name: String, token: String, color: Color) -> some View {
        HStack(spacing: SPSpacing.sm) {
            RoundedRectangle(cornerRadius: SPRadius.md)
                .fill(color)
                .frame(width: 44, height: 44)
                .overlay(RoundedRectangle(cornerRadius: SPRadius.md).strokeBorder(Color.spBorderSubtle))
            VStack(alignment: .leading, spacing: 2) {
                Text(name).spTextStyle(.body2).foregroundStyle(.spTextPrimary)
                Text(token).spTextStyle(.caption).foregroundStyle(.spTextSecondary)
            }
            Spacer(minLength: 0)
        }
        .padding(SPSpacing.sm)
        .background(Color.spSurfaceDefault, in: RoundedRectangle(cornerRadius: SPRadius.lg))
        .accessibilityElement(children: .combine)
    }
}

struct TypographyPage: View {
    @State private var family: SPFontFamily = .primary

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SPSpacing.lg) {
                Text("Apply with `.spTextStyle(_:)`. Display and headline 1–3 grow on iPad (regular width), and every style scales with Dynamic Type.")
                    .spTextStyle(.body1)
                    .foregroundStyle(.spTextSecondary)
                Picker("Family", selection: $family) {
                    ForEach(SPFontFamily.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                .frame(maxWidth: 300)
                ForEach(SPTextStyle.allCases, id: \.self) { style in
                    VStack(alignment: .leading, spacing: SPSpacing.xs) {
                        Text("The quick brown fox")
                            .spTextStyle(style, family: family)
                            .foregroundStyle(.spTextPrimary)
                        Text(".\(style.rawValue)")
                            .spTextStyle(.caption)
                            .foregroundStyle(.spTextSecondary)
                    }
                    Divider().overlay(Color.spBorderSubtle)
                }
            }
            .padding(SPSpacing.lg)
        }
        .background(Color.spSurfaceDefault)
    }
}

struct SpacingPage: View {
    private let spacing: [(String, CGFloat)] = [
        ("xs", SPSpacing.xs), ("sm", SPSpacing.sm), ("md", SPSpacing.md), ("lg", SPSpacing.lg), ("xl", SPSpacing.xl),
    ]
    private let radii: [(String, CGFloat)] = [
        ("sm", SPRadius.sm), ("md", SPRadius.md), ("lg", SPRadius.lg), ("xl", SPRadius.xl), ("full", SPRadius.full),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SPSpacing.xl) {
                CatalogSection("Spacing") {
                    ForEach(spacing, id: \.0) { name, value in
                        HStack(spacing: SPSpacing.md) {
                            Text("SPSpacing.\(name)").spTextStyle(.body2).frame(width: 140, alignment: .leading)
                            Rectangle().fill(Color.spSurfaceBrand).frame(width: value, height: SPSpacing.md)
                            Text("\(Int(value))pt").spTextStyle(.caption).foregroundStyle(.spTextSecondary)
                        }
                        .foregroundStyle(.spTextPrimary)
                    }
                }
                CatalogSection("Radius") {
                    SpecimenRow {
                        ForEach(radii, id: \.0) { name, value in
                            Specimen("SPRadius.\(name)") {
                                RoundedRectangle(cornerRadius: value)
                                    .fill(Color.spSurfaceBrandSubtle)
                                    .overlay(RoundedRectangle(cornerRadius: value).strokeBorder(Color.spBorderDefault, lineWidth: 2))
                                    .frame(width: 72, height: 72)
                            }
                        }
                    }
                }
            }
            .padding(SPSpacing.lg)
        }
        .background(Color.spSurfaceDefault)
    }
}

struct ShadowsPage: View {
    var body: some View {
        ScrollView {
            SpecimenRow {
                ForEach(SPShadow.allCases, id: \.self) { shadow in
                    Specimen(".spShadow(.\(shadow))") {
                        RoundedRectangle(cornerRadius: SPRadius.lg)
                            .fill(Color.spSurfaceDefault)
                            .frame(width: 140, height: 96)
                            .spShadow(shadow)
                    }
                }
            }
            .padding(SPSpacing.xl)
        }
        .background(Color.spSurfaceSubtle)
    }
}

struct IconGalleryPage: View {
    @State private var query = ""

    private var icons: [SPIconName] {
        query.isEmpty ? SPIconName.allCases : SPIconName.allCases.filter { $0.rawValue.localizedCaseInsensitiveContains(query) }
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: SPSpacing.md)], spacing: SPSpacing.md) {
                ForEach(icons) { icon in
                    VStack(spacing: SPSpacing.sm) {
                        SPIcon(icon, size: 32).foregroundStyle(.spTextPrimary)
                        Text(icon.rawValue)
                            .spTextStyle(.caption)
                            .foregroundStyle(.spTextSecondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, minHeight: 88)
                    .padding(SPSpacing.sm)
                    .background(Color.spSurfaceDefault, in: RoundedRectangle(cornerRadius: SPRadius.lg))
                    .accessibilityElement(children: .combine)
                }
            }
            .padding(SPSpacing.lg)
        }
        .background(Color.spSurfaceSubtle)
        .searchable(text: $query, prompt: "Search \(SPIconName.allCases.count) icons")
    }
}
