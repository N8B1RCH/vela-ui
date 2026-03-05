import SwiftUI

// MARK: - Button Style

/// The visual style of a `VelaButton`.
public enum VelaButtonStyle {
    /// Filled with the accent color. Use for primary CTAs.
    case primary
    /// Outlined with accent color border. Use for secondary actions.
    case secondary
    /// No background or border. Use for tertiary or inline actions.
    case ghost
    /// Filled with the error color. Use for destructive actions.
    case destructive
}

// MARK: - Button Size

/// The size of a `VelaButton`.
public enum VelaButtonSize {
    case small
    case medium
    case large

    var horizontalPadding: CGFloat {
        switch self {
        case .small: return VelaSpacing.sm
        case .medium: return VelaSpacing.md
        case .large: return VelaSpacing.xl
        }
    }

    var verticalPadding: CGFloat {
        switch self {
        case .small: return VelaSpacing.xs
        case .medium: return VelaSpacing.sm
        case .large: return VelaSpacing.md
        }
    }

    var font: Font {
        switch self {
        case .small: return VelaFont.caption
        case .medium: return VelaFont.subheadline
        case .large: return VelaFont.headline
        }
    }

    var radius: CGFloat {
        switch self {
        case .small: return VelaRadius.sm
        case .medium: return VelaRadius.md
        case .large: return VelaRadius.lg
        }
    }
}

// MARK: - VelaButton

/// A fully accessible, animated button component with multiple style variants.
///
/// ```swift
/// VelaButton("Continue", style: .primary) {
///     navigateToNext()
/// }
///
/// VelaButton("Delete", style: .destructive, size: .small) {
///     confirmDelete()
/// }
/// ```
public struct VelaButton: View {

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.isEnabled) private var isEnabled

    private let label: String
    private let icon: String?
    private let style: VelaButtonStyle
    private let size: VelaButtonSize
    private let isLoading: Bool
    private let action: () -> Void

    @State private var isPressed = false

    public init(
        _ label: String,
        icon: String? = nil,
        style: VelaButtonStyle = .primary,
        size: VelaButtonSize = .medium,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.icon = icon
        self.style = style
        self.size = size
        self.isLoading = isLoading
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: VelaSpacing.xs) {
                if isLoading {
                    ProgressView()
                        .tint(foregroundColor)
                        .scaleEffect(0.85)
                } else {
                    if let icon {
                        Image(systemName: icon)
                            .font(size.font)
                    }
                    Text(label)
                        .font(size.font)
                        .fontWeight(.semibold)
                }
            }
            .padding(.horizontal, size.horizontalPadding)
            .padding(.vertical, size.verticalPadding)
            .frame(maxWidth: style == .primary ? .infinity : nil)
            .foregroundStyle(foregroundColor)
            .background(backgroundView)
            .clipShape(RoundedRectangle(cornerRadius: size.radius, style: .continuous))
            .overlay(borderOverlay)
            .opacity(isEnabled ? 1 : 0.4)
            .scaleEffect(isPressed && !reduceMotion ? 0.97 : 1.0)
            .animation(reduceMotion ? .none : VelaAnimation.snappy, value: isPressed)
        }
        .buttonStyle(VelaPressButtonStyle(isPressed: $isPressed))
        .accessibilityLabel(label)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint(isLoading ? "Loading, please wait" : "")
    }

    // MARK: - Private

    private var foregroundColor: Color {
        switch style {
        case .primary: return .white
        case .secondary: return VelaColor.accent
        case .ghost: return VelaColor.accent
        case .destructive: return .white
        }
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .primary:
            RoundedRectangle(cornerRadius: size.radius, style: .continuous)
                .fill(VelaColor.accent)
        case .secondary:
            RoundedRectangle(cornerRadius: size.radius, style: .continuous)
                .fill(VelaColor.accentSubtle)
        case .ghost:
            Color.clear
        case .destructive:
            RoundedRectangle(cornerRadius: size.radius, style: .continuous)
                .fill(VelaColor.error)
        }
    }

    @ViewBuilder
    private var borderOverlay: some View {
        if style == .secondary {
            RoundedRectangle(cornerRadius: size.radius, style: .continuous)
                .strokeBorder(VelaColor.accent, lineWidth: 1.5)
        }
    }
}

// MARK: - Press Style

private struct VelaPressButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { _, newValue in
                isPressed = newValue
            }
    }
}

// MARK: - Previews

#Preview("VelaButton") {
    VStack(spacing: VelaSpacing.md) {
        VelaButton("Get Started", style: .primary) {}
        VelaButton("Learn More", style: .secondary) {}
        VelaButton("Skip", style: .ghost) {}
        VelaButton("Delete Account", style: .destructive) {}
        VelaButton("Loading", style: .primary, isLoading: true) {}
        VelaButton("With Icon", icon: "arrow.right", style: .primary) {}
            .disabled(true)
    }
    .padding(VelaSpacing.lg)
}
