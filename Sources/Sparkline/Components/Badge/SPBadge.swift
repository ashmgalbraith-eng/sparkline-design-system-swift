import SwiftUI

/// A small status marker: a numeric count or a colored dot.
///
/// ```swift
/// SPIcon(.bellOutline)
///     .overlay(alignment: .topTrailing) {
///         SPBadge("3").offset(x: 8, y: -8)
///     }
/// ```
public struct SPBadge: View {
    public enum Variant: String, CaseIterable, Sendable {
        /// A pill showing a short count ("9", "99+").
        case numeric
        /// An 8pt dot.
        case dot
    }

    public enum Status: String, CaseIterable, Sendable {
        case success, error, warning, info, notification

        var color: Color {
            switch self {
            case .success: return .spSurfaceSuccess
            case .error: return .spSurfaceError
            case .warning: return .spSurfaceWarning
            case .info: return .spSurfaceInfo
            case .notification: return .spSurfaceBrand
            }
        }
    }

    let label: String
    let variant: Variant
    let status: Status

    /// - Parameters:
    ///   - label: The count. Only shown for `.numeric`. Keep it short.
    ///   - variant: `.numeric` or `.dot`.
    ///   - status: Sets the color.
    public init(_ label: String = "9", variant: Variant = .numeric, status: Status = .notification) {
        self.label = label
        self.variant = variant
        self.status = status
    }

    /// A dot badge.
    public static func dot(_ status: Status) -> SPBadge {
        SPBadge("", variant: .dot, status: status)
    }

    public var body: some View {
        switch variant {
        case .dot:
            Circle()
                .fill(status.color)
                .frame(width: 8, height: 8)
                .accessibilityHidden(true)
        case .numeric:
            Text(label)
                .spTextStyle(.caption)
                .lineLimit(1)
                .fixedSize()
                .foregroundStyle(.spTextInverse)
                .padding(.horizontal, 6)
                .frame(minWidth: 20, minHeight: 20)
                .background(Capsule().fill(status.color))
                .overlay(Capsule().strokeBorder(Color.spSurfaceDefault, lineWidth: 1.5))
        }
    }
}

struct SPBadge_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: SPSpacing.md) {
            HStack(spacing: SPSpacing.md) {
                ForEach(SPBadge.Status.allCases, id: \.self) { SPBadge("9", status: $0) }
                SPBadge("999+")
            }
            HStack(spacing: SPSpacing.md) {
                ForEach(SPBadge.Status.allCases, id: \.self) { SPBadge.dot($0) }
            }
        }
        .padding()
    }
}
