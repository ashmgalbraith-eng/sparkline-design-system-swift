import SwiftUI

/// A Sparkline icon as a `Shape`, for custom fills or strokes.
public struct SPIconShape: Shape {
    public let name: SPIconName

    public init(_ name: SPIconName) {
        self.name = name
    }

    public func path(in rect: CGRect) -> Path {
        name.path(in: rect)
    }
}

/// Renders an icon from the Sparkline registry on a 24×24 grid.
///
/// The icon fills with the current foreground style, so color it with
/// `.foregroundStyle(.spTextBrand)` or let it inherit from its container.
///
/// ```swift
/// SPIcon(.helpCircleOutline, size: 20)
///     .foregroundStyle(.spTextSecondary)
/// ```
public struct SPIcon: View {
    let name: SPIconName
    let size: CGFloat
    let accessibilityLabel: String?

    /// - Parameters:
    ///   - name: The icon to draw.
    ///   - size: Width and height in points. Common sizes: 16, 20, 24, 32.
    ///   - accessibilityLabel: Pass a label when the icon carries meaning on its own.
    ///     Without one the icon is hidden from VoiceOver as decoration.
    public init(_ name: SPIconName, size: CGFloat = 24, accessibilityLabel: String? = nil) {
        self.name = name
        self.size = size
        self.accessibilityLabel = accessibilityLabel
    }

    public var body: some View {
        let shape = SPIconShape(name)
            .frame(width: size, height: size)
        if let accessibilityLabel {
            shape
                .accessibilityElement()
                .accessibilityLabel(accessibilityLabel)
                .accessibilityAddTraits(.isImage)
        } else {
            shape.accessibilityHidden(true)
        }
    }
}

struct SPIcon_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: SPSpacing.md) {
            SPIcon(.check, size: 16)
            SPIcon(.bellOutline, size: 20)
            SPIcon(.heartOutline)
                .foregroundStyle(.spTextBrand)
            SPIcon(.checkCircleOutline, size: 32)
                .foregroundStyle(.spTextSuccess)
        }
        .padding()
    }
}
