import SwiftUI

/// A container surface for grouping related content. It handles only the
/// surface (background, border or shadow, radius, padding); you supply the content.
///
/// ```swift
/// SPCard(variant: .outlined, padding: .none) {
///     ReceiptRow("Term", "12 months")
///     Divider().overlay(Color.spBorderSubtle)
///     ReceiptRow("APY", "4.85%")
/// }
/// ```
public struct SPCard<Content: View>: View {
    public typealias Variant = SPCardVariant
    public typealias Padding = SPCardPadding

    let variant: Variant
    let padding: Padding
    let content: Content

    /// - Parameters:
    ///   - variant: `.elevated`, `.outlined` or `.filled`.
    ///   - padding: Inner padding: 0, 8, 16 or 24pt.
    ///   - content: The card's content, laid out in a leading-aligned `VStack` with no spacing.
    public init(variant: Variant = .elevated, padding: Padding = .md, @ViewBuilder content: () -> Content) {
        self.variant = variant
        self.padding = padding
        self.content = content()
    }

    public var body: some View {
        let shape = RoundedRectangle(cornerRadius: SPRadius.xl, style: .continuous)
        VStack(alignment: .leading, spacing: 0) {
            content
        }
        .padding(padding.value)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(variant == .filled ? Color.spSurfaceSubtle : Color.spSurfaceDefault)
        .clipShape(shape)
        .overlay {
            if variant == .outlined {
                shape.strokeBorder(Color.spBorderSubtle, lineWidth: 1)
            }
        }
        .background {
            if variant == .elevated {
                shape.fill(Color.spSurfaceDefault).spShadow(.md)
            }
        }
    }
}

struct SPCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: SPSpacing.lg) {
            ForEach(SPCardVariant.allCases, id: \.self) { variant in
                SPCard(variant: variant) {
                    Text(variant.rawValue.capitalized).spTextStyle(.body1)
                }
            }
        }
        .padding()
    }
}

/// Card surface treatment.
public enum SPCardVariant: String, CaseIterable, Sendable {
    /// Default surface with a medium shadow.
    case elevated
    /// Default surface with a subtle border.
    case outlined
    /// Subtle background, no border or shadow.
    case filled
}

/// Card inner padding: 0, 8, 16 or 24pt.
public enum SPCardPadding: String, CaseIterable, Sendable {
    case none, sm, md, lg

    var value: CGFloat {
        switch self {
        case .none: return 0
        case .sm: return SPSpacing.sm
        case .md: return SPSpacing.md
        case .lg: return SPSpacing.lg
        }
    }
}
