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

    var height: CGFloat {
        switch self {
        case .small: return 32
        case .medium: return 44
        case .large: return 52
        }
    }
    
    var radius: CGFloat {
        switch self {
        case .small: return VelaRadius.sm
        case .medium: return VelaRadius.lg
        case .large: return VelaRadius.pill
        }
    }
    
    var font: Font {
        switch self {
        case .small: return VelaFont.caption
        case .medium: return VelaFont.subheadline
        case .large: return VelaFont.headline
        }
    }
}

// MARK: - Button Icon Placement

public enum VelaButtonIconPlacement {
    case left
    case right
    case trailingOverlay
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
    private let iconPlacement: VelaButtonIconPlacement?
    private let style: VelaButtonStyle
    private let size: VelaButtonSize
    private let isLoading: Bool
    private let action: () -> Void

    @State private var isPressed = false
    @State private var animateTrailingIcon = false

    public init(
        _ label: String,
        icon: String? = nil,
        iconPlacement: VelaButtonIconPlacement? = nil,
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
                    if let icon, iconPlacement == .left {
                        Image(systemName: icon)
                            .font(size.font)
                    }
                    
                    Text(label)
                        .font(size.font)
                        .fontWeight(.semibold)
                    
                    if let icon, iconPlacement == .right {
                        Image(systemName: icon)
                            .font(size.font)
                    }
                }
            }
            .frame(height: style.height)
            .frame(maxWidth: style == .primary ? .infinity : nil)
            .foregroundStyle(foregroundColor)
            .background(backgroundView)
            .clipShape(RoundedRectangle(cornerRadius: size.radius, style: .continuous))
            .overlay(borderOverlay)
            .overlay(trailingIcon, alignment: .trailing)
            .opacity(isEnabled ? 1 : 0.4)
            .scaleEffect(isPressed && !reduceMotion ? 0.97 : 1.0)
            .animation(reduceMotion ? .none : VelaAnimation.snappy, value: isPressed)
        }
        .buttonStyle(VelaPressButtonStyle(isPressed: $isPressed))
        .accessibilityLabel(label)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint(isLoading ? "Loading, please wait" : "")
        .onAppear {
            guard !reduceMotion else { return }
            animateTrailingIcon = true
        }
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
        switch style
        if style == .secondary {
            RoundedRectangle(cornerRadius: size.radius, style: .continuous)
                .strokeBorder(VelaColor.accent, lineWidth: 1.5)
        }
    }
    
    @ViewBuilder
    private var trailingIcon: some View {
        if let icon, iconPlacement == .trailingOverlay {
            Image(systemName: icon)
                .font(size.font)
                .offset(x: animateTrailingIcon ? -20 : -10)
                .animation(.easeInOut, value: animateTrailingIcon)
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
