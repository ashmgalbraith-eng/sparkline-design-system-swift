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
                Text("Semantic color tokens, generated from the web design system's CSS under the same names: --color-surface-brand is SPColor.surfaceBrand. Each resolves to its light or dark value automatically; switch Appearance in the toolbar to compare.")
                    .spType(.body1)
                    .foregroundStyle(SPColor.textSecondary)
                ForEach(groups, id: \.1) { title, prefix in
                    CatalogSection(title) {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 200), spacing: SPSpacing.md)], spacing: SPSpacing.md) {
                            ForEach(SPColorToken.allCases.filter { $0.rawValue.hasPrefix("--color-\(prefix)") }, id: \.self) { token in
                                swatch(token)
                            }
                        }
                    }
                }
                CatalogSection("Focus ring") {
                    swatch(name: "SPColor.focusRing", token: "--primary-30", color: SPColor.focusRing)
                }
            }
            .padding(SPSpacing.lg)
        }
        .background(SPColor.surfaceSubtle)
    }

    private func swatch(_ token: SPColorToken) -> some View {
        swatch(name: "SPColor.\(token)", token: token.rawValue, color: token.color)
    }

    private func swatch(name: String, token: String, color: Color) -> some View {
        HStack(spacing: SPSpacing.sm) {
            RoundedRectangle(cornerRadius: SPRadius.md)
                .fill(color)
                .frame(width: 44, height: 44)
                .overlay(RoundedRectangle(cornerRadius: SPRadius.md).strokeBorder(SPColor.borderSubtle))
            VStack(alignment: .leading, spacing: 2) {
                Text(name).spType(.body2).foregroundStyle(SPColor.textPrimary)
                Text(token).spType(.caption).foregroundStyle(SPColor.textSecondary)
            }
            Spacer(minLength: 0)
        }
        .padding(SPSpacing.sm)
        .background(SPColor.surfaceDefault, in: RoundedRectangle(cornerRadius: SPRadius.lg))
        .accessibilityElement(children: .combine)
    }
}

struct TypographyPage: View {
    @State private var family: SPFontFamily = .base

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SPSpacing.lg) {
                Text("Apply with `.spType(_:)`. Display and headline 1–3 grow on iPad (regular width), and every style scales with Dynamic Type.")
                    .spType(.body1)
                    .foregroundStyle(SPColor.textSecondary)
                Picker("Family", selection: $family) {
                    ForEach(SPFontFamily.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                .frame(maxWidth: 300)
                ForEach(SPType.allCases, id: \.self) { style in
                    VStack(alignment: .leading, spacing: SPSpacing.xs) {
                        Text("The quick brown fox")
                            .spType(style, family: family)
                            .foregroundStyle(SPColor.textPrimary)
                        Text("SPType.\(style)  ·  \(style.rawValue)-*")
                            .spType(.caption)
                            .foregroundStyle(SPColor.textSecondary)
                    }
                    Divider().overlay(SPColor.borderSubtle)
                }
            }
            .padding(SPSpacing.lg)
        }
        .background(SPColor.surfaceDefault)
    }
}

struct SpacingPage: View {
    // Swift name and CSS name side by side: the token set is shared.
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
                            VStack(alignment: .leading, spacing: 2) {
                                Text("SPSpacing.\(name)").spType(.body2)
                                Text("--spacing-\(name)").spType(.caption).foregroundStyle(SPColor.textSecondary)
                            }
                            .frame(width: 140, alignment: .leading)
                            Rectangle().fill(SPColor.surfaceBrand).frame(width: value, height: SPSpacing.md)
                            Text("\(Int(value))pt").spType(.caption).foregroundStyle(SPColor.textSecondary)
                        }
                        .foregroundStyle(SPColor.textPrimary)
                    }
                }
                CatalogSection("Radius") {
                    SpecimenRow {
                        ForEach(radii, id: \.0) { name, value in
                            Specimen("SPRadius.\(name) · --radius-\(name)") {
                                RoundedRectangle(cornerRadius: value)
                                    .fill(SPColor.surfaceBrandSubtle)
                                    .overlay(RoundedRectangle(cornerRadius: value).strokeBorder(SPColor.borderDefault, lineWidth: 2))
                                    .frame(width: 72, height: 72)
                            }
                        }
                    }
                }
            }
            .padding(SPSpacing.lg)
        }
        .background(SPColor.surfaceDefault)
    }
}

struct ShadowsPage: View {
    var body: some View {
        ScrollView {
            SpecimenRow {
                ForEach(SPShadow.allCases, id: \.self) { shadow in
                    Specimen("SPShadow.\(shadow) · \(shadow.rawValue)") {
                        RoundedRectangle(cornerRadius: SPRadius.lg)
                            .fill(SPColor.surfaceDefault)
                            .frame(width: 140, height: 96)
                            .spShadow(shadow)
                    }
                }
            }
            .padding(SPSpacing.xl)
        }
        .background(SPColor.surfaceSubtle)
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
                        SPIcon(icon, size: 32).foregroundStyle(SPColor.textPrimary)
                        Text(icon.rawValue)
                            .spType(.caption)
                            .foregroundStyle(SPColor.textSecondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, minHeight: 88)
                    .padding(SPSpacing.sm)
                    .background(SPColor.surfaceDefault, in: RoundedRectangle(cornerRadius: SPRadius.lg))
                    .accessibilityElement(children: .combine)
                }
            }
            .padding(SPSpacing.lg)
        }
        .background(SPColor.surfaceSubtle)
        .searchable(text: $query, prompt: "Search \(SPIconName.allCases.count) icons")
    }
}
