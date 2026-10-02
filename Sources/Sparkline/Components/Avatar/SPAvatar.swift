import SwiftUI

/// A small circular representation of a person: initials, a photo or a generic
/// account icon. Can show a status dot or a notification count.
///
/// ```swift
/// SPAvatar(.initials("AG"), size: .large)
/// SPAvatar(.url(review.avatarURL), size: .large, accessibilityLabel: review.name)
/// SPAvatar(.icon, status: .success, notificationCount: "3")
/// ```
public struct SPAvatar: View {
    public enum Size: String, CaseIterable, Sendable {
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

    public enum Content {
        /// Letters to show. Large shows the first two, smaller sizes the first one, uppercased.
        case initials(String)
        /// A local image.
        case image(Image)
        /// A remote image, loaded with `AsyncImage`. Shows the account icon while loading or on failure.
        case url(URL?)
        /// The generic account icon.
        case icon
    }

    let content: Content
    let size: Size
    let status: SPBadge.Status?
    let notificationCount: String?
    let accessibilityLabel: String?

    /// - Parameters:
    ///   - content: Initials, an image, a URL or the account icon.
    ///   - size: `.small` (16pt), `.medium` (24pt) or `.large` (32pt).
    ///   - status: Adds a colored dot at the bottom right.
    ///   - notificationCount: Adds a count badge at the top right. Truncated to four characters.
    ///   - accessibilityLabel: The person's name. Without it the avatar is decorative.
    public init(
        _ content: Content = .initials("A"),
        size: Size = .medium,
        status: SPBadge.Status? = nil,
        notificationCount: String? = nil,
        accessibilityLabel: String? = nil
    ) {
        self.content = content
        self.size = size
        self.status = status
        self.notificationCount = notificationCount
        self.accessibilityLabel = accessibilityLabel
    }

    public var body: some View {
        let d = size.diameter
        ZStack {
            Circle().fill(isImage ? Color.clear : Color.spSurfaceOverlay)
            face
        }
        .frame(width: d, height: d)
        .foregroundStyle(.spTextPrimary)
        .overlay(alignment: .topLeading) { statusDot }
        .overlay(alignment: .topLeading) { notification }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityText)
        .accessibilityHidden(accessibilityLabel == nil && notificationCount == nil && status == nil)
    }

    private var isImage: Bool {
        switch content {
        case .image, .url: return true
        case .initials, .icon: return false
        }
    }

    @ViewBuilder
    private var face: some View {
        switch content {
        case .initials(let text):
            Text(String(text.prefix(size == .large ? 2 : 1)).uppercased())
                .spTextStyle(.caption)
                .lineLimit(1)
                .fixedSize()
        case .image(let image):
            image.resizable().scaledToFill().clipShape(Circle())
        case .url(let url):
            AsyncImage(url: url) { phase in
                if let image = phase.image {
                    image.resizable().scaledToFill()
                } else {
                    ZStack {
                        Circle().fill(Color.spSurfaceOverlay)
                        SPIcon(.accountOutline, size: size.iconSize)
                    }
                }
            }
            .clipShape(Circle())
        case .icon:
            SPIcon(.accountOutline, size: size.iconSize)
        }
    }

    // Offsets reproduce the web component's absolute anchors.
    @ViewBuilder
    private var statusDot: some View {
        if let status {
            let offset: CGSize = {
                switch size {
                case .large: return CGSize(width: 25, height: 24)
                case .medium: return CGSize(width: 24 + 3 - 8, height: 24 + 2 - 8)
                case .small: return CGSize(width: 13, height: 12)
                }
            }()
            SPBadge.dot(status)
                .background(Circle().fill(Color.spBorderInverse).padding(-2))
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
        if let status { parts.append(status.rawValue) }
        if let notificationCount { parts.append("\(notificationCount) notifications") }
        return parts.joined(separator: ", ")
    }
}

struct SPAvatar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: SPSpacing.xl) {
            HStack(spacing: SPSpacing.lg) {
                ForEach(SPAvatar.Size.allCases, id: \.self) { size in
                    SPAvatar(.initials("AG"), size: size)
                    SPAvatar(.icon, size: size)
                }
            }
            HStack(spacing: SPSpacing.xl) {
                ForEach(SPAvatar.Size.allCases, id: \.self) { size in
                    SPAvatar(.initials("AG"), size: size, status: .success, notificationCount: "999+")
                }
            }
        }
        .padding(SPSpacing.xl)
    }
}
