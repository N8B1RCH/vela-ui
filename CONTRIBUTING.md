# Contributing to Vela

Thanks for your interest in contributing. Vela is a design system with strong opinions — please read this guide before opening a PR.

## Component Standards

Every component merged into Vela must meet the following bar:

### Accessibility
- All interactive elements must have an `accessibilityLabel`
- Use `accessibilityHint` for actions that aren't self-explanatory
- Compound elements should use `accessibilityElement(children: .combine)` where appropriate
- Test with VoiceOver before submitting

### Motion
- All animations must be gated on `@Environment(\.accessibilityReduceMotion)`
- Prefer `velaAnimation(_:value:)` modifier over `.animation` directly
- Use named curves from `VelaAnimation` — don't use arbitrary durations

### Dark Mode
- Never use hardcoded `Color` values in components
- All colors must reference semantic tokens from `VelaColor`
- Test in both light and dark mode before submitting

### Tokens
- Don't hardcode spacing, radius, or font values
- Use `VelaSpacing`, `VelaRadius`, `VelaFont`

### Previews
- Every component requires a `#Preview` macro block
- Previews must demonstrate all meaningful visual states
- Include a dark mode preview variant where relevant

## Pull Request Template

When opening a PR, please include:
- What component this adds or changes
- Screenshots or recordings in light + dark mode
- VoiceOver behavior description
- Notes on reduce motion handling

## Code Style

- `public` APIs must have doc comments
- Follow SwiftUI naming conventions
- Mark implementation details `private` or `fileprivate`
- Organize files with `// MARK: -` sections

## Questions

Open a Discussion if you're unsure whether a new component fits the system.
