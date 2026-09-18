import SwiftUI

// Core loader — dùng nội bộ bởi Typography.swift
// Font được register qua UIAppFonts trong Info.plist của main App.
public extension Font {
    static func lexend(size: CGFloat, weight: Weight = .regular) -> Font {
        .custom(LexendFont.postScriptName(for: weight), size: size)
    }
}

public extension View {
    func lexendFont(size: CGFloat, weight: Font.Weight = .regular) -> some View {
        self.font(.lexend(size: size, weight: weight))
    }
}

// MARK: - PostScript name mapping
private enum LexendFont {
    static func postScriptName(for weight: Font.Weight) -> String {
        switch weight {
        case .ultraLight: return "Lexend-Thin"
        case .thin:       return "Lexend-ExtraLight"
        case .light:      return "Lexend-Light"
        case .regular:    return "Lexend-Regular"
        case .medium:     return "Lexend-Medium"
        case .semibold:   return "Lexend-SemiBold"
        case .bold:       return "Lexend-Bold"
        case .heavy:      return "Lexend-ExtraBold"
        case .black:      return "Lexend-Black"
        default:          return "Lexend-Regular"
        }
    }
}
