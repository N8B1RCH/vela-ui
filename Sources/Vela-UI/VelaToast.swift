import SwiftUI

// MARK: - Toast Type

public enum VelaToastType {
    case success
    case warning
    case error
    case info

    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        case .info: return "info.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .success: return VelaColor.success
        case .warning: return VelaColor.warning
        case .error: return VelaColor.error
        case .info: return VelaColor.info
        }
    }
}

// MARK: - VelaToast

/// An animated, accessible toast notification that appears from the top of the screen.
///
/// ```swift
/// // Present from a view modifier
/// .velaToast(isPresented: $showToast, message: "Changes saved", type: .success)
/// ```
public struct VelaToast: View {

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let message: String
    private let type: VelaToastType

    public init(_ message: String, type: VelaToastType = .info) {
        self.message = message
        self.type = type
    }

    public var body: some View {
        HStack(spacing: VelaSpacing.sm) {
            Image(systemName: type.icon)
                .foregroundStyle(type.color)
                .font(.system(size: 18, weight: .semibold))
                .accessibilityHidden(true)

            Text(message)
                .font(VelaFont.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(VelaColor.labelPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, VelaSpacing.md)
        .padding(.vertical, VelaSpacing.sm)
        .background(VelaColor.backgroundElevated)
        .clipShape(RoundedRectangle(cornerRadius: VelaRadius.pill, style: .continuous))
        .shadow(color: VelaShadow.medium.color, radius: VelaShadow.medium.radius, x: 0, y: 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(type) notification: \(message)")
    }
}

// MARK: - Toast View Modifier

/// State object used to control toast presentation.
@Observable
public final class VelaToastState {
    public var isPresented = false
    public var message = ""
    public var type: VelaToastType = .info
    private var dismissTask: Task<Void, Never>?

    public init() {}

    public func show(_ message: String, type: VelaToastType = .info, duration: TimeInterval = 3) {
        dismissTask?.cancel()
        self.message = message
        self.type = type
        withAnimation {
            self.isPresented = true
        }
        dismissTask = Task {
            try? await Task.sleep(for: .seconds(duration))
            guard !Task.isCancelled else { return }
            await MainActor.run {
                withAnimation {
                    self.isPresented = false
                }
            }
        }
    }
}

public struct VelaToastModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @Bindable var state: VelaToastState

    public func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if state.isPresented {
                    VelaToast(state.message, type: state.type)
                        .padding(.horizontal, VelaSpacing.lg)
                        .padding(.top, VelaSpacing.sm)
                        .transition(
                            reduceMotion
                            ? .opacity
                            : .move(edge: .top).combined(with: .opacity)
                        )
                        .zIndex(999)
                }
            }
            .animation(reduceMotion ? .none : VelaAnimation.smooth, value: state.isPresented)
    }
}

public extension View {
    /// Attaches a Vela toast overlay driven by a `VelaToastState` object.
    func velaToast(_ state: VelaToastState) -> some View {
        modifier(VelaToastModifier(state: state))
    }
}

// MARK: - Previews

#Preview("VelaToast") {
    VStack(spacing: VelaSpacing.md) {
        VelaToast("Your changes were saved.", type: .success)
        VelaToast("Low storage space remaining.", type: .warning)
        VelaToast("Unable to connect. Try again.", type: .error)
        VelaToast("Sync is running in the background.", type: .info)
    }
    .padding(VelaSpacing.lg)
    .background(VelaColor.backgroundPrimary)
}
