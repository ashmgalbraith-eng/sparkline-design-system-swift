import SwiftUI

/// Badge shape (`BadgeType` on the web).
public enum SPBadgeType: String, CaseIterable, Sendable {
    /// A pill showing a short count ("9", "99+").
    case numeric
    /// An 8pt dot.
    case dot
}

/// Badge color (`BadgeStatus` on the web).
public enum SPBadgeStatus: String, CaseIterable, Sendable {
    case success, error, warning, info, notification

    var color: Color {
        switch self {
        case .success: return SPColor.surfaceSuccess
        case .error: return SPColor.surfaceError
        case .warning: return SPColor.surfaceWarning
        case .info: return SPColor.surfaceInfo
        case .notification: return SPColor.surfaceBrand
        }
    }
}

/// A small status marker: a numeric count or a colored dot.
///
/// ```swift
/// SPIcon(.bellOutline)
///     .overlay(alignment: .topTrailing) {
///         SPBadge("3").offset(x: 8, y: -8)
///     }
/// ```
public struct SPBadge: View {
    let label: String
    let type: SPBadgeType
    let status: SPBadgeStatus

    /// - Parameters:
    ///   - label: The count. Only shown for `.numeric`. Keep it short.
    ///   - type: `.numeric` or `.dot`.
    ///   - status: Sets the color.
    public init(_ label: String = "9", type: SPBadgeType = .numeric, status: SPBadgeStatus = .notification) {
        self.label = label
        self.type = type
        self.status = status
    }

    /// A dot badge.
    public static func dot(_ status: SPBadgeStatus) -> SPBadge {
        SPBadge("", type: .dot, status: status)
    }

    public var body: some View {
        switch type {
        case .dot:
            Circle()
                .fill(status.color)
                .frame(width: 8, height: 8)
                .accessibilityHidden(true)
        case .numeric:
            Text(label)
                .spType(.caption)
                .lineLimit(1)
                .fixedSize()
                .foregroundStyle(SPColor.textInverse)
                .padding(.horizontal, 6)
                .frame(minWidth: 20, minHeight: 20)
                .background(Capsule().fill(status.color))
                .overlay(Capsule().strokeBorder(SPColor.surfaceDefault, lineWidth: 1.5))
        }
    }
}

struct SPBadge_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: SPSpacing.md) {
            HStack(spacing: SPSpacing.md) {
                ForEach(SPBadgeStatus.allCases, id: \.self) { SPBadge("9", status: $0) }
                SPBadge("999+")
            }
            HStack(spacing: SPSpacing.md) {
                ForEach(SPBadgeStatus.allCases, id: \.self) { SPBadge.dot($0) }
            }
        }
        .padding()
    }
}
