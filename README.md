# Vela ✦

> Vela is Latin for "sails" — a name chosen to evoke interfaces that feel lightweight, fluid, and effortless, like wind catching canvas on open water.
> This SwiftUI design system is built for clarity, motion, and accessibility.

![Swift](https://img.shields.io/badge/Swift-5.9+-F05138?style=flat&logo=swift&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0+-0071e3?style=flat&logo=apple&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-17.0+-000000?style=flat&logo=apple&logoColor=white)
![macOS](https://img.shields.io/badge/macOS-14.0+-000000?style=flat&logo=apple&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-brightgreen?style=flat)

Vela is a production-grade SwiftUI component library and design system — crafted at the intersection of design craft and engineering precision. Every component is built with three principles at its core: **accessibility by default**, **motion with purpose**, and **native platform fidelity**.

---

## ✦ Philosophy

Most design systems treat accessibility and animation as afterthoughts. Vela treats them as foundations.

- **Accessibility first** — Every component supports VoiceOver, Dynamic Type, and high-contrast out of the box. Accessibility is not a feature; it's the baseline.
- **Motion with intent** — Animations respect `reduceMotion`, use spring physics that feel native, and never animate for decoration alone.
- **Dark & light native** — Components are designed in both modes simultaneously using semantic color tokens, never retrofitted.
- **Design tokens as source of truth** — Spacing, radius, color, and typography are defined once and flow everywhere.

---

## ✦ Components

| Category | Components |
|---|---|
| **Buttons** | `VelaButton`, `VelaIconButton`, `VelaFloatingAction` |
| **Cards** | `VelaCard`, `VelaInfoCard`, `VelaMediaCard` |
| **Forms** | `VelaTextField`, `VelaToggle`, `VelaSlider`, `VelaPickerRow` |
| **Navigation** | `VelaTabBar`, `VelaNavigationHeader`, `VelaSidePanel` |
| **Feedback** | `VelaToast`, `VelaLoadingIndicator`, `VelaEmptyState` |

---

## ✦ Design Tokens

Vela's tokens are defined in `Sources/Vela/Tokens/` and cover:

- **Color** — semantic palette with automatic dark mode
- **Typography** — a curated type scale using SF Pro with custom tracking
- **Spacing** — 4pt grid system (`VelaSpacing`)
- **Radius** — consistent corner radii (`VelaRadius`)
- **Motion** — named spring curves and duration values (`VelaAnimation`)

---

## ✦ Requirements

| Platform | Minimum Version |
|---|---|
| iOS | 17.0+ |
| macOS | 14.0+ |
| visionOS | 1.0+ |
| Swift | 5.9+ |
| Xcode | 15.0+ |

---

## ✦ Installation

### Swift Package Manager

Add Vela to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/vela-ui.git", from: "1.0.0")
]
```

Or in Xcode: **File → Add Package Dependencies** → paste the repo URL.

---

## ✦ Quick Start

```swift
import Vela

struct ContentView: View {
    var body: some View {
        VStack(spacing: VelaSpacing.md) {
            VelaButton("Get Started", style: .primary) {
                // action
            }

            VelaCard {
                VelaInfoCard(
                    title: "Welcome to Vela",
                    subtitle: "Crafted with intent.",
                    icon: "sparkles"
                )
            }
        }
        .padding(VelaSpacing.lg)
    }
}
```

---

## ✦ Preview App

The `Preview/VelaPreview` target is a standalone SwiftUI app that showcases every component in both light and dark mode, with controls to simulate accessibility settings like Dynamic Type and Reduce Motion.

To run it: open `VelaPreview.xcodeproj` and run the `VelaPreview` scheme.

---

## ✦ Contributing

Contributions are welcome. Please read [CONTRIBUTING.md](./CONTRIBUTING.md) before opening a PR.

Every new component must include:
- [ ] Light & dark mode support via semantic tokens
- [ ] VoiceOver label and hint
- [ ] `reduceMotion` handling for any animations
- [ ] Previews for all meaningful states
- [ ] Entry in the Preview app

---

## ✦ Roadmap

- [x] Design token system
- [x] Core button components
- [ ] Form components
- [ ] Navigation components
- [ ] Feedback & overlay components
- [ ] visionOS ornament support
- [ ] Figma token sync via Style Dictionary
- [ ] DocC documentation site

---

## ✦ License

MIT © [Your Name](https://github.com/yourusername)
