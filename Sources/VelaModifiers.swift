import SwiftUI

// MARK: - Reduce Motion Aware Animation

public extension View {
    /// Applies an animation only if the user has not requested reduced motion.
    ///
    /// Falls back to `.instant` (no animation) if `accessibilityReduceMotion` is `true`.
    ///
    /// ```swift
    /// Circle()
    ///     .scaleEffect(isExpanded ? 1.2 : 1.0)
    ///     .velaAnimation(VelaAnimation.bouncy, value: isExpanded)
    /// ```
    func velaAnimation<V: Equatable>(_ animation: Animation, value: V) -> some View {
        modifier(ReduceMotionAnimationModifier(animation: animation, value: value))
    }
}

private struct ReduceMotionAnimationModifier<V: Equatable>: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let animation: Animation
    let value: V

    func body(content: Content) -> some View {
        content.animation(reduceMotion ? .none : animation, value: value)
    }
}

// MARK: - Shadow Modifier

public extension View {
    /// Applies a Vela shadow preset to the view.
    func velaShadow(_ style: VelaShadow.Style) -> some View {
        shadow(color: style.color, radius: style.radius, x: style.x, y: style.y)
    }
}

// MARK: - Card Modifier

public extension View {
    /// Wraps the view in a `VelaCard` surface.
    func velaCard(
        elevation: VelaCard<AnyView>.Elevation = .resting,
        padding: CGFloat = VelaSpacing.md,
        radius: CGFloat = VelaRadius.lg
    ) -> some View {
        VelaCard(elevation: elevation, padding: padding, radius: radius) {
            AnyView(self)
        }
    }
}
