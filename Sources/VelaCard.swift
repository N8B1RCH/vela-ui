import SwiftUI

// MARK: - VelaCard

/// A flexible surface container with consistent elevation and rounded corners.
///
/// Use `VelaCard` to group related content with visual separation from the background.
///
/// ```swift
/// VelaCard {
///     Text("Hello from Vela")
/// }
///
/// VelaCard(elevation: .lifted, padding: VelaSpacing.lg) {
///     ProfileRow(user: currentUser)
/// }
/// ```
public struct VelaCard<Content: View>: View {

    public enum Elevation {
        /// Flat — no shadow, relies on background color contrast.
        case flat
        /// Default card elevation with a subtle shadow.
        case resting
        /// More prominent elevation for featured content.
        case lifted
    }

    private let elevation: Elevation
    private let padding: CGFloat
    private let radius: CGFloat
    private let content: Content

    public init(
        elevation: Elevation = .resting,
        padding: CGFloat = VelaSpacing.md,
        radius: CGFloat = VelaRadius.lg,
        @ViewBuilder content: () -> Content
    ) {
        self.elevation = elevation
        self.padding = padding
        self.radius = radius
        self.content = content()
    }

    public var body: some View {
        content
            .padding(padding)
            .background(VelaColor.backgroundSecondary)
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .strokeBorder(VelaColor.borderSubtle, lineWidth: 0.5)
            )
            .shadow(
                color: shadowStyle.color,
                radius: shadowStyle.radius,
                x: shadowStyle.x,
                y: shadowStyle.y
            )
    }

    private var shadowStyle: VelaShadow.Style {
        switch elevation {
        case .flat: return VelaShadow.Style(color: .clear, radius: 0, x: 0, y: 0)
        case .resting: return VelaShadow.low
        case .lifted: return VelaShadow.medium
        }
    }
}

// MARK: - VelaInfoCard

/// A compact card for surfacing titled content with an optional icon and subtitle.
///
/// ```swift
/// VelaInfoCard(
///     title: "3 new updates",
///     subtitle: "Tap to review your notifications",
///     icon: "bell.badge"
/// )
/// ```
public struct VelaInfoCard: View {

    private let title: String
    private let subtitle: String?
    private let icon: String?
    private let iconColor: Color

    public init(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        iconColor: Color = VelaColor.accent
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.iconColor = iconColor
    }

    public var body: some View {
        HStack(alignment: .top, spacing: VelaSpacing.sm) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(iconColor)
                    .frame(width: 32, height: 32)
                    .background(iconColor.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: VelaRadius.sm, style: .continuous))
            }

            VStack(alignment: .leading, spacing: VelaSpacing.xxs) {
                Text(title)
                    .font(VelaFont.headline)
                    .foregroundStyle(VelaColor.labelPrimary)

                if let subtitle {
                    Text(subtitle)
                        .font(VelaFont.subheadline)
                        .foregroundStyle(VelaColor.labelSecondary)
                }
            }

            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Previews

#Preview("VelaCard") {
    VStack(spacing: VelaSpacing.md) {
        VelaCard(elevation: .flat) {
            VelaInfoCard(title: "Flat card", subtitle: "No shadow, relies on color", icon: "square")
        }

        VelaCard(elevation: .resting) {
            VelaInfoCard(title: "Resting card", subtitle: "Default elevation", icon: "square.fill", iconColor: .purple)
        }

        VelaCard(elevation: .lifted) {
            VelaInfoCard(title: "Lifted card", subtitle: "Featured content", icon: "sparkles", iconColor: .orange)
        }
    }
    .padding(VelaSpacing.lg)
    .background(VelaColor.backgroundPrimary)
}
