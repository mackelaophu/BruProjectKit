import SwiftUI

// MARK: - AppTypography
// Map 1-1 với token trong typography guide (Stitch/Figma).
// Dùng: Text("Hello").appStyle(.headlineLg)
public enum AppTypography {

    // Display — Bold 700
    case displayLg   // 32/40
    case displayMd   // 28/36
    case displaySm   // 24/32

    // Headline — SemiBold 600
    case headlineLg  // 22/28
    case headlineMd  // 20/26
    case headlineSm  // 18/24

    // Title — Medium 500
    case titleLg     // 20/28
    case titleMd     // 16/24
    case titleSm     // 14/20

    // Body — Regular 400
    case bodyLg      // 16/24 • tracking 0.5
    case bodyMd      // 14/20 • tracking 0.25
    case bodySm      // 12/16 • tracking 0.4

    // Label — Medium 500
    case labelLg     // 14/20 • tracking 0.1
    case labelMd     // 12/16 • tracking 0.5
    case labelSm     // 11/16 • tracking 0.5

    // MARK: Font
    public var font: Font {
        .lexend(size: size, weight: weight)
    }

    // MARK: Size (pt)
    public var size: CGFloat {
        switch self {
        case .displayLg:  return 32
        case .displayMd:  return 28
        case .displaySm:  return 24
        case .headlineLg: return 22
        case .headlineMd: return 20
        case .headlineSm: return 18
        case .titleLg:    return 20
        case .titleMd:    return 16
        case .titleSm:    return 14
        case .bodyLg:     return 16
        case .bodyMd:     return 14
        case .bodySm:     return 12
        case .labelLg:    return 14
        case .labelMd:    return 12
        case .labelSm:    return 11
        }
    }

    // MARK: Weight
    public var weight: Font.Weight {
        switch self {
        case .displayLg, .displayMd, .displaySm:
            return .bold
        case .headlineLg, .headlineMd, .headlineSm:
            return .semibold
        case .titleLg, .titleMd, .titleSm,
             .labelLg, .labelMd, .labelSm:
            return .medium
        case .bodyLg, .bodyMd, .bodySm:
            return .regular
        }
    }

    // MARK: Line spacing
    // SwiftUI lineSpacing = lineHeight - fontSize (additional gap between lines)
    public var lineSpacing: CGFloat {
        switch self {
        case .displayLg:  return 40 - 32  // = 8
        case .displayMd:  return 36 - 28  // = 8
        case .displaySm:  return 32 - 24  // = 8
        case .headlineLg: return 28 - 22  // = 6
        case .headlineMd: return 26 - 20  // = 6
        case .headlineSm: return 24 - 18  // = 6
        case .titleLg:    return 28 - 20  // = 8
        case .titleMd:    return 24 - 16  // = 8
        case .titleSm:    return 20 - 14  // = 6
        case .bodyLg:     return 24 - 16  // = 8
        case .bodyMd:     return 20 - 14  // = 6
        case .bodySm:     return 16 - 12  // = 4
        case .labelLg:    return 20 - 14  // = 6
        case .labelMd:    return 16 - 12  // = 4
        case .labelSm:    return 16 - 11  // = 5
        }
    }

    // MARK: Letter spacing (tracking)
    public var tracking: CGFloat {
        switch self {
        case .bodyLg:             return 0.5
        case .bodyMd:             return 0.25
        case .bodySm:             return 0.4
        case .labelLg:            return 0.1
        case .labelMd, .labelSm:  return 0.5
        default:                  return 0
        }
    }
}

// MARK: - ViewModifier
private struct AppTypographyModifier: ViewModifier {
    let style: AppTypography

    func body(content: Content) -> some View {
        content
            .font(style.font)
            .fontWeight(style.weight)
            .tracking(style.tracking)
            .lineSpacing(style.lineSpacing)
    }
}

// MARK: - View extension
public extension View {
    /// Apply typography token từ design system.
    /// Ví dụ: Text("Hello").appStyle(.headlineLg)
    func appStyle(_ style: AppTypography) -> some View {
        modifier(AppTypographyModifier(style: style))
    }
}

// MARK: - Font shorthand (dùng khi chỉ cần font, không cần tracking/lineSpacing)
public extension Font {
    static var displayLg:  Font { AppTypography.displayLg.font }
    static var displayMd:  Font { AppTypography.displayMd.font }
    static var displaySm:  Font { AppTypography.displaySm.font }
    static var headlineLg: Font { AppTypography.headlineLg.font }
    static var headlineMd: Font { AppTypography.headlineMd.font }
    static var headlineSm: Font { AppTypography.headlineSm.font }
    static var titleLg:    Font { AppTypography.titleLg.font }
    static var titleMd:    Font { AppTypography.titleMd.font }
    static var titleSm:    Font { AppTypography.titleSm.font }
    static var bodyLg:     Font { AppTypography.bodyLg.font }
    static var bodyMd:     Font { AppTypography.bodyMd.font }
    static var bodySm:     Font { AppTypography.bodySm.font }
    static var labelLg:    Font { AppTypography.labelLg.font }
    static var labelMd:    Font { AppTypography.labelMd.font }
    static var labelSm:    Font { AppTypography.labelSm.font }
}
