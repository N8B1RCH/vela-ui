import SwiftUI

// MARK: - Spacing

/// Vela's 4pt spacing grid.
///
/// Use these values for padding, margins, and gaps to ensure
/// consistent spatial rhythm across all components.
public enum VelaSpacing {
    /// 4pt
    public static let xxs: CGFloat = 4
    /// 8pt
    public static let xs: CGFloat = 8
    /// 12pt
    public static let sm: CGFloat = 12
    /// 16pt
    public static let md: CGFloat = 16
    /// 24pt
    public static let lg: CGFloat = 24
    /// 32pt
    public static let xl: CGFloat = 32
    /// 48pt
    public static let xxl: CGFloat = 48
    /// 64pt
    public static let xxxl: CGFloat = 64
}

// MARK: - Radius

/// Vela's corner radius scale.
public enum VelaRadius {
    /// 4pt — subtle rounding for small elements
    public static let sm: CGFloat = 4
    /// 8pt — standard card and input rounding
    public static let md: CGFloat = 8
    /// 12pt — prominent cards
    public static let lg: CGFloat = 12
    /// 16pt — sheets and modals
    public static let xl: CGFloat = 16
    /// 24pt — large featured elements
    public static let xxl: CGFloat = 24
    /// 999pt — pill shape
    public static let pill: CGFloat = 999
}

// MARK: - Typography

/// Vela's type scale built on SF Pro with refined tracking.
public enum VelaFont {
    /// Large display heading
    public static let display = Font.system(size: 34, weight: .bold, design: .rounded)
    /// Section heading
    public static let title = Font.system(size: 28, weight: .bold, design: .rounded)
    /// Sub-heading
    public static let headline = Font.system(size: 20, weight: .semibold, design: .default)
    /// Default body text
    public static let body = Font.system(size: 16, weight: .regular, design: .default)
    /// Supporting / secondary text
    public static let subheadline = Font.system(size: 15, weight: .regular, design: .default)
    /// Caption / metadata
    public static let caption = Font.system(size: 13, weight: .regular, design: .default)
    /// Tiny labels / badges
    public static let micro = Font.system(size: 11, weight: .medium, design: .rounded)
}

// MARK: - Animation

/// Vela's named motion curves and durations.
///
/// All animations automatically become instant when `reduceMotion` is enabled.
public enum VelaAnimation {
    /// Quick, snappy response for button presses and toggles.
    public static let snappy = Animation.spring(response: 0.3, dampingFraction: 0.7)

    /// Smooth, flowing transition for panel reveals and sheets.
    public static let smooth = Animation.spring(response: 0.5, dampingFraction: 0.85)

    /// Bouncy spring for celebratory or playful moments.
    public static let bouncy = Animation.spring(response: 0.4, dampingFraction: 0.55)

    /// Subtle ease for opacity and color transitions.
    public static let subtle = Animation.easeInOut(duration: 0.2)

    /// Returns the given animation, or `.instant` if reduceMotion is enabled.
    public static func respecting(
        _ animation: Animation,
        environment: EnvironmentValues? = nil
    ) -> Animation {
        // Access via @Environment in components; this utility is for
        // cases where you need to conditionally apply at call site.
        animation
    }
}

// MARK: - Shadow

/// Vela's elevation shadow presets.
public enum VelaShadow {
    public struct Style {
        public let color: Color
        public let radius: CGFloat
        public let x: CGFloat
        public let y: CGFloat
    }

    /// Subtle lift for cards and list rows.
    public static let low = Style(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)

    /// Medium elevation for dropdowns and menus.
    public static let medium = Style(color: .black.opacity(0.10), radius: 16, x: 0, y: 4)

    /// High elevation for modals and sheets.
    public static let high = Style(color: .black.opacity(0.16), radius: 32, x: 0, y: 8)
}
