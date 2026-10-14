import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// Avatar size (`AvatarSize` on the web).
public enum SPAvatarSize: String, CaseIterable, Sendable {
    /// 16pt
    case small
    /// 24pt
    case medium
    /// 32pt
    case large

    var diameter: CGFloat {
        switch self {
        case .small: return 16
        case .medium: return 24
        case .large: return 32
        }
    }

    var iconSize: CGFloat { self == .small ? 12 : 16 }
}

/// What the avatar shows (`AvatarType` on the web).
public enum SPAvatarType {
    /// Initials. Large shows the first two letters, smaller sizes the first one, uppercased.
    case text(String)
    /// A local image.
    case image(Image)
    /// A remote image (`imageSrc` on the web). Shows the account icon while loading or on failure,
    /// and retries when the avatar reappears if a load was cancelled.
    case imageURL(URL?)
    /// The generic account icon.
    case icon
}

/// A small circular representation of a person: initials, a photo or a generic
/// account icon. Can show a status dot or a notification count.
///
/// ```swift
/// SPAvatar(type: .text("AG"), size: .large)
/// SPAvatar(type: .imageURL(review.avatarURL), size: .large, accessibilityLabel: review.name)
/// SPAvatar(type: .icon, statusColor: .success, notificationCount: "3")
/// ```
public struct SPAvatar: View {
    let type: SPAvatarType
    let size: SPAvatarSize
    let statusColor: SPBadgeStatus?
    let notificationCount: String?
    let accessibilityLabel: String?

    /// - Parameters:
    ///   - type: Initials, an image, an image URL or the account icon.
    ///   - size: `.small` (16pt), `.medium` (24pt) or `.large` (32pt).
    ///   - statusColor: Adds a status dot in this color at the bottom right.
    ///   - notificationCount: Adds a count badge at the top right. Truncated to four characters.
    ///   - accessibilityLabel: The person's name. Without it the avatar is decorative.
    public init(
        type: SPAvatarType = .text("A"),
        size: SPAvatarSize = .medium,
        statusColor: SPBadgeStatus? = nil,
        notificationCount: String? = nil,
        accessibilityLabel: String? = nil
    ) {
        self.type = type
        self.size = size
        self.statusColor = statusColor
        self.notificationCount = notificationCount
        self.accessibilityLabel = accessibilityLabel
    }

    public var body: some View {
        let d = size.diameter
        ZStack {
            Circle().fill(isImage ? Color.clear : SPColor.surfaceOverlay)
            face
        }
        .frame(width: d, height: d)
        .foregroundStyle(SPColor.textPrimary)
        .overlay(alignment: .topLeading) { statusDot }
        .overlay(alignment: .topLeading) { notification }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityText)
        .accessibilityHidden(accessibilityLabel == nil && notificationCount == nil && statusColor == nil)
    }

    private var isImage: Bool {
        switch type {
        case .image, .imageURL: return true
        case .text, .icon: return false
        }
    }

    @ViewBuilder
    private var face: some View {
        switch type {
        case .text(let text):
            Text(String(text.prefix(size == .large ? 2 : 1)).uppercased())
                .spType(.caption)
                .lineLimit(1)
                .fixedSize()
        case .image(let image):
            image.resizable().scaledToFill().clipShape(Circle())
        case .imageURL(let url):
            SPRemoteAvatarImage(url: url, iconSize: size.iconSize)
                .clipShape(Circle())
        case .icon:
            SPIcon(.accountOutline, size: size.iconSize)
        }
    }

    // Offsets reproduce the web component's absolute anchors.
    @ViewBuilder
    private var statusDot: some View {
        if let statusColor {
            let offset: CGSize = {
                switch size {
                case .large: return CGSize(width: 25, height: 24)
                case .medium: return CGSize(width: 24 + 3 - 8, height: 24 + 2 - 8)
                case .small: return CGSize(width: 13, height: 12)
                }
            }()
            SPBadge.dot(statusColor)
                .background(Circle().fill(SPColor.borderInverse).padding(-2))
                .offset(offset)
        }
    }

    @ViewBuilder
    private var notification: some View {
        if let notificationCount {
            let offset: CGSize = {
                switch size {
                case .large: return CGSize(width: 24, height: -7)
                case .medium: return CGSize(width: 16, height: -10)
                case .small: return CGSize(width: 8, height: -12)
                }
            }()
            SPBadge(String(notificationCount.prefix(4)))
                .fixedSize()
                .offset(offset)
                .allowsHitTesting(false)
        }
    }

    private var accessibilityText: String {
        var parts: [String] = []
        if let accessibilityLabel { parts.append(accessibilityLabel) }
        if let statusColor { parts.append(statusColor.rawValue) }
        if let notificationCount { parts.append("\(notificationCount) notifications") }
        return parts.joined(separator: ", ")
    }
}

/// Loads a remote avatar photo. Unlike `AsyncImage`, a load that is cancelled (for example
/// while a screen is being pushed) runs again the next time the view appears.
private struct SPRemoteAvatarImage: View {
    let url: URL?
    let iconSize: CGFloat
    @State private var image: Image?

    var body: some View {
        ZStack {
            if let image {
                image.resizable().scaledToFill()
            } else {
                Circle().fill(SPColor.surfaceOverlay)
                SPIcon(.accountOutline, size: iconSize)
            }
        }
        .task(id: url) {
            guard image == nil, let url,
                  let (data, _) = try? await URLSession.shared.data(from: url),
                  let loaded = Self.image(from: data)
            else { return }
            image = loaded
        }
    }

    private static func image(from data: Data) -> Image? {
        #if canImport(UIKit)
        return UIImage(data: data).map(Image.init(uiImage:))
        #elseif canImport(AppKit)
        return NSImage(data: data).map(Image.init(nsImage:))
        #endif
    }
}

struct SPAvatar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: SPSpacing.xl) {
            HStack(spacing: SPSpacing.lg) {
                ForEach(SPAvatarSize.allCases, id: \.self) { size in
                    SPAvatar(type: .text("AG"), size: size)
                    SPAvatar(type: .icon, size: size)
                }
            }
            HStack(spacing: SPSpacing.xl) {
                ForEach(SPAvatarSize.allCases, id: \.self) { size in
                    SPAvatar(type: .text("AG"), size: size, statusColor: .success, notificationCount: "999+")
                }
            }
        }
        .padding(SPSpacing.xl)
    }
}
