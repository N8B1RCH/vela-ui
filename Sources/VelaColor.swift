import SwiftUI

/// Vela's semantic color palette.
///
/// All colors are defined semantically and automatically resolve
/// to their appropriate value in light and dark mode.
public enum VelaColor {

    // MARK: - Brand

    /// Primary brand accent. Use for CTAs, active states, and highlights.
    public static let accent = Color("VelaAccent", bundle: .module)

    /// Secondary brand color. Use for supporting UI elements.
    public static let accentSubtle = Color("VelaAccentSubtle", bundle: .module)

    // MARK: - Backgrounds

    /// Primary app background.
    public static let backgroundPrimary = Color("VelaBackgroundPrimary", bundle: .module)

    /// Secondary background for cards and grouped content.
    public static let backgroundSecondary = Color("VelaBackgroundSecondary", bundle: .module)

    /// Elevated background for overlays, sheets, and toasts.
    public static let backgroundElevated = Color("VelaBackgroundElevated", bundle: .module)

    // MARK: - Foreground / Text

    /// Primary text. Use for headlines and body copy.
    public static let labelPrimary = Color("VelaLabelPrimary", bundle: .module)

    /// Secondary text. Use for subtitles, captions, and metadata.
    public static let labelSecondary = Color("VelaLabelSecondary", bundle: .module)

    /// Tertiary text. Use for placeholders and disabled states.
    public static let labelTertiary = Color("VelaLabelTertiary", bundle: .module)

    // MARK: - Borders & Separators

    /// Standard separator line.
    public static let separator = Color("VelaSeparator", bundle: .module)

    /// Subtle border for cards and containers.
    public static let borderSubtle = Color("VelaBorderSubtle", bundle: .module)

    // MARK: - Semantic States

    /// Success / confirmation color.
    public static let success = Color("VelaSuccess", bundle: .module)

    /// Warning / caution color.
    public static let warning = Color("VelaWarning", bundle: .module)

    /// Error / destructive color.
    public static let error = Color("VelaError", bundle: .module)

    /// Informational color.
    public static let info = Color("VelaInfo", bundle: .module)
}
