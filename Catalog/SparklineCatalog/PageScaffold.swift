import SwiftUI
import Sparkline

/// The layout every catalog page uses: a summary, a live playground with
/// controls (Storybook's Controls panel), then static variant sections.
struct ComponentPage<Preview: View, Controls: View, Sections: View>: View {
    let summary: String
    @ViewBuilder var preview: Preview
    @ViewBuilder var controls: Controls
    @ViewBuilder var sections: Sections

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SPSpacing.xl) {
                Text(summary)
                    .spType(.body1)
                    .foregroundStyle(SPColor.textSecondary)

                CatalogSection("Playground") {
                    VStack(alignment: .leading, spacing: SPSpacing.lg) {
                        preview
                            .frame(maxWidth: .infinity, minHeight: 96)
                            .padding(SPSpacing.lg)
                            .background(SPColor.surfaceDefault)
                            .clipShape(RoundedRectangle(cornerRadius: SPRadius.lg))
                            .overlay(RoundedRectangle(cornerRadius: SPRadius.lg).strokeBorder(SPColor.borderSubtle))
                        VStack(alignment: .leading, spacing: SPSpacing.sm) {
                            controls
                        }
                        .controlSize(.small)
                    }
                }

                sections
            }
            .padding(SPSpacing.lg)
            .frame(maxWidth: 960, alignment: .leading)
            .frame(maxWidth: .infinity)
        }
        .background(SPColor.surfaceSubtle)
    }
}

/// A titled block on a catalog page.
struct CatalogSection<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: SPSpacing.md) {
            Text(title)
                .spType(.headline4)
                .foregroundStyle(SPColor.textPrimary)
                .accessibilityAddTraits(.isHeader)
            content
        }
    }
}

/// A labelled specimen inside a section.
struct Specimen<Content: View>: View {
    let label: String
    @ViewBuilder var content: Content

    init(_ label: String, @ViewBuilder content: () -> Content) {
        self.label = label
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: SPSpacing.sm) {
            content
            Text(label)
                .spType(.caption)
                .foregroundStyle(SPColor.textSecondary)
        }
    }
}

/// Picker control row for enum options.
struct OptionPicker<Value: Hashable & RawRepresentable>: View where Value.RawValue == String {
    let title: String
    @Binding var value: Value
    let options: [Value]

    init(_ title: String, value: Binding<Value>, options: [Value]) {
        self.title = title
        self._value = value
        self.options = options
    }

    var body: some View {
        LabeledContent(title) {
            Picker(title, selection: $value) {
                ForEach(options, id: \.self) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .frame(maxWidth: 420)
        }
    }
}

/// Picker for an optional icon.
struct IconPicker: View {
    let title: String
    @Binding var icon: SPIconName?

    var body: some View {
        LabeledContent(title) {
            Picker(title, selection: $icon) {
                Text("None").tag(SPIconName?.none)
                ForEach(SPIconName.allCases) { Text($0.rawValue).tag(Optional($0)) }
            }
            .labelsHidden()
        }
    }
}

/// Lays specimens out in a wrapping row.
struct SpecimenRow<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        SPFlowLayout(spacing: SPSpacing.lg) {
            content
        }
    }
}
