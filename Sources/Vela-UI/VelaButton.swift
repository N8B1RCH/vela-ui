import SwiftUI

// MARK: - Button Type

/// Defines the shape, size, and layout behavior of a `VelaButton`.
public enum VelaButtonType {
    /// Full-width capsule. Use for primary CTAs.
    /// Height: 50pt. Width: infinite. Font: large bold.
    case fill

    /// Content-hugging rounded rectangle. Use for inline or secondary actions.
    /// Height: 32pt. Width: hug content. Font: small bold.
    case compact
}

// MARK: - Button Style

/// Defines the color and background treatment of a `VelaButton`.
/// Applies independently of `VelaButtonType`.
public enum VelaButtonStyle {
    /// Solid filled background. Default appearance.
    case standard
    /// No fill, 2px stroked border. Text and border use the theme color.
    case ghost
    /// Overrides color to destructive/warning red. Works on any type.
    case destructive
}

// MARK: - Icon Placement

/// Defines where an optional icon appears within the button.
public enum VelaButtonIconPlacement {
    /// Icon to the left of the label. Supported by all button types.
    case left
    /// Icon to the right of the label. Supported by all button types.
    case right
    /// Icon pinned to the trailing edge while label remains centered.
    /// Only supported by `.fill` type buttons.
    case trailingOverlay
}

// MARK: - VelaButton

/// A modular, accessible SwiftUI button component.
///
/// Button appearance is controlled by two independent axes:
/// - `type` — governs shape, size, and layout (`.fill` or `.compact`)
/// - `style` — governs color and background treatment (`.standard`, `.ghost`, `.destructive`)
///
/// ```swift
/// // Full-width CTA
/// VelaButton("Get Started", type: .fill) {}
///
/// // Compact destructive ghost button
/// VelaButton("Remove", type: .compact, style: .destructive) {}
///
/// // Fill button with trailing overlay icon
/// VelaButton("Continue", type: .fill, icon: "arrow.right", iconPlacement: .trailingOverlay) {}
/// ```
public struct VelaButton: View {

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.isEnabled) private var isEnabled

    private let label: String
    private let type: VelaButtonType
    private let style: VelaButtonStyle
    private let icon: String?
    private let iconPlacement: VelaButtonIconPlacement
    private let isLoading: Bool
    private let action: () -> Void

    @State private var isPressed = false
    @State private var animateTrailingOverlayIcon = false

    public init(
        _ label: String,
        type: VelaButtonType = .fill,
        style: VelaButtonStyle = .standard,
        icon: String? = nil,
        iconPlacement: VelaButtonIconPlacement = .left,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.type = type
        self.style = style
        self.icon = icon
        self.iconPlacement = iconPlacement
        self.isLoading = isLoading
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button(action: action) {
            buttonContent
                .frame(height: type.height)
                .frame(maxWidth: type == .fill ? .infinity : nil)
                .padding(.horizontal, type.horizontalPadding)
                .foregroundStyle(foregroundColor)
                .background(backgroundShape)
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

    // MARK: - Content

    @ViewBuilder
    private var buttonContent: some View {
        if isLoading {
            ProgressView()
                .tint(foregroundColor)
        } else if type == .fill, let icon, iconPlacement == .trailingOverlay {
            // Centered label with icon pinned to trailing edge
            ZStack {
                Text(label)
                    .font(type.font)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)

                HStack {
                    Spacer()
                    
                    Image(systemName: icon)
                        .font(type.font)
                        .offset(x: animateTrailingOverlayIcon ? -20 : -10)
                        .animation(.easeOut, value: animateTrailingOverlayIcon)
                }
            }
        } else {
            // Standard left/right icon + label
            HStack(spacing: VelaSpacing.xs) {
                if let icon, iconPlacement == .left {
                    Image(systemName: icon)
                        .font(type.font)
                }
                
                Text(label)
                    .font(type.font)
                    .fontWeight(.bold)
                
                if let icon, iconPlacement == .right {
                    Image(systemName: icon)
                        .font(type.font)
                }
            }
        }
    }

    // MARK: - Appearance

    private var themeColor: Color {
        style == .destructive ? VelaColor.error : VelaColor.accent
    }

    private var foregroundColor: Color {
        switch style {
        case .standard:
            return .white
        case .ghost:
            return themeColor
        case .destructive:
            return style == .ghost ? VelaColor.error : .white
        }
    }

    @ViewBuilder
    private var backgroundShape: some View {
        switch style {
        case .standard, .destructive:
            makeShape().fill(themeColor)
        case .ghost:
            makeShape().fill(Color.clear)
        }
    }

    @ViewBuilder
    private var borderOverlay: some View {
        if style == .ghost {
            makeInsettableShape().strokeBorder(themeColor, lineWidth: 2)
                .strokeBorder(themeColor, lineWidth: 2)
        }
    }

    private func makeShape() -> some Shape {
        switch type {
        case .fill:
            AnyShape(Capsule(style: .continuous))
        case .compact:
            AnyShape(RoundedRectangle(cornerRadius: VelaRadius.md, style: .continuous))
        }
    }

    private func makeInsettableShape() -> some InsettableShape {
        switch type {
        case .fill:
            AnyInsettableShape(Capsule(style: .continuous))
        case .compact:
            AnyInsettableShape(RoundedRectangle(cornerRadius: VelaRadius.md, style: .continuous))
        }
    }
}

// MARK: - VelaButtonType Helpers

private extension VelaButtonType {
    var height: CGFloat {
        switch self {
        case .fill: return 50
        case .compact: return 32
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .fill: return VelaSpacing.lg
        case .compact: return VelaSpacing.md
        }
    }

    var font: Font {
        switch self {
        case .fill: return VelaFont.headline
        case .compact: return VelaFont.subheadline
        }
    }
}

// MARK: - Shape Type Erasers

private struct AnyShape: Shape {
    private let _path: (CGRect) -> Path
    init<S: Shape>(_ shape: S) { _path = shape.path(in:) }
    func path(in rect: CGRect) -> Path { _path(rect) }
}

private struct AnyInsettableShape: InsettableShape {
    private let _path: (CGRect) -> Path
    private let _inset: (CGFloat) -> AnyInsettableShape
    init<S: InsettableShape>(_ shape: S) {
        _path = shape.path(in:)
        _inset = { AnyInsettableShape(shape.inset(by: $0)) }
    }
    func path(in rect: CGRect) -> Path { _path(rect) }
    func inset(by amount: CGFloat) -> AnyInsettableShape { _inset(amount) }
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

#Preview("VelaButton — Fill") {
    VStack(spacing: VelaSpacing.md) {
        VelaButton("Get Started", type: .fill) {}
        VelaButton("Get Started", type: .fill, style: .ghost) {}
        VelaButton("Delete Account", type: .fill, style: .destructive) {}
        VelaButton("Continue", type: .fill, icon: "arrow.right", iconPlacement: .trailingOverlay) {}
        VelaButton("Download", type: .fill, icon: "arrow.down.circle", iconPlacement: .left) {}
        VelaButton("Loading", type: .fill, isLoading: true) {}
        VelaButton("Disabled", type: .fill) {}.disabled(true)
    }
    .padding(VelaSpacing.lg)
}

#Preview("VelaButton — Compact") {
    HStack(spacing: VelaSpacing.sm) {
        VelaButton("Cancel", type: .compact, style: .ghost) {}
        VelaButton("Save", type: .compact) {}
        VelaButton("Remove", type: .compact, style: .destructive) {}
        VelaButton("Filter", type: .compact, icon: "line.3.horizontal.decrease", iconPlacement: .left) {}
    }
    .padding(VelaSpacing.lg)
}
