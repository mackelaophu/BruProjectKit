//
//  Color + Extensions.swift
//  AdapfitV2
//
//  Created by PhamHai Dang on 29/5/26.
//  Copyright © 2026 Bru. All rights reserved.
//



import UIKit
import SwiftUI
extension Color {
    public init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255,
                            (int >> 8) * 17,
                            (int >> 4 & 0xF) * 17,
                            (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255,
                            int >> 16,
                            int >> 8 & 0xFF,
                            int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24,
                            int >> 16 & 0xFF,
                            int >> 8 & 0xFF,
                            int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension Color {
    @MainActor
    public func toUIColor() -> UIColor {
        if #available(iOS 14.0, *) {
            return UIColor(self)
        } else {
            // iOS 13 thì lấy từ UIColor với CGColor
            let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
            var hexNumber: UInt64 = 0
            if scanner.scanHexInt64(&hexNumber) {
                let r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                let g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                let b = CGFloat(hexNumber & 0x0000ff) / 255
                return UIColor(red: r, green: g, blue: b, alpha: 1.0)
            }
            return UIColor.black // fallback
        }
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        // Remove leading "#" if present
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }

        // Must be exactly 6 characters
        guard hexString.count == 6 else {
            self.init(white: 0.5, alpha: alpha) // fallback gray
            return
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}


// MARK: - SwiftUI Color tokens (Material 3 - Light scheme)
@MainActor
extension Color {

    // MARK: Neutrals (Material scheme)
    public static var n900: Color { AppTheme.currentTheme.colors.n900Color } // "#171C1F" => "onBackground"
    public static var n800: Color { AppTheme.currentTheme.colors.n800Color } // "#40484B" => "onSurfaceVariant"
    public static var n700: Color { AppTheme.currentTheme.colors.n700Color } // derived neutral
    public static var n600: Color { AppTheme.currentTheme.colors.n600Color } // "#70787C" => "outline"
    public static var n500: Color { AppTheme.currentTheme.colors.n500Color } // derived neutral
    public static var n400: Color { AppTheme.currentTheme.colors.n400Color } // "#BFC8CC" => "outlineVariant"
    public static var n300: Color { AppTheme.currentTheme.colors.n300Color } // "#DBE4E8" => "surfaceVariant"
    public static var n200: Color { AppTheme.currentTheme.colors.n200Color } // "#EAEFF1" => "surfaceContainer"
    public static var n100: Color { AppTheme.currentTheme.colors.n100Color } // "#EFF4F7" => "surfaceContainerLow"
    public static var n50:  Color { AppTheme.currentTheme.colors.n50Color }  // "#F5FAFD" => "surface"/"background"
    public static var n0:   Color { AppTheme.currentTheme.colors.n0Color }   // "#FFFFFF" => "surfaceContainerLowest"

    // MARK: Primary (Material scheme)
    public static var p900: Color { AppTheme.currentTheme.colors.p900Color } // "#004E5F" => "onPrimaryContainer"
    public static var p800: Color { AppTheme.currentTheme.colors.p800Color } // "#004E5F" => "onPrimaryContainer" (fallback)
    public static var p700: Color { AppTheme.currentTheme.colors.p700Color } // "#03677E" => "primary"
    public static var p600: Color { AppTheme.currentTheme.colors.p600Color } // derived (primary scale)
    public static var p500: Color { AppTheme.currentTheme.colors.p500Color } // derived (primary scale)
    public static var p450: Color { AppTheme.currentTheme.colors.p450Color } // "#87D1EA" => "inversePrimary"
    public static var p400: Color { AppTheme.currentTheme.colors.p400Color } // "#B4EBFF" => "primaryContainer"
    public static var p300: Color { AppTheme.currentTheme.colors.p300Color } // derived (primary scale)
    public static var p200: Color { AppTheme.currentTheme.colors.p200Color } // derived (primary scale)
    public static var p100: Color { AppTheme.currentTheme.colors.p100Color } // "#F2FBFF" => palette primary "98"
    public static var p50:  Color { AppTheme.currentTheme.colors.p50Color }  // "#F9FDFF" => palette primary "99"

    // MARK: Secondary (Material scheme)
    public static var s900: Color { AppTheme.currentTheme.colors.s900Color } // "#344A52" => "onSecondaryContainer"
    public static var s800: Color { AppTheme.currentTheme.colors.s800Color } // "#4C626A" => "secondary"
    public static var s700: Color { AppTheme.currentTheme.colors.s700Color } // "#4C626A" => "secondary"
    public static var s600: Color { AppTheme.currentTheme.colors.s600Color } // derived (secondary scale)
    public static var s500: Color { AppTheme.currentTheme.colors.s500Color } // derived (secondary scale)
    public static var s400: Color { AppTheme.currentTheme.colors.s400Color } // "#B3CAD4" => "secondaryFixedDim" (close)
    public static var s300: Color { AppTheme.currentTheme.colors.s300Color } // "#CFE6F0" => "secondaryContainer"
    public static var s200: Color { AppTheme.currentTheme.colors.s200Color } // "#EEF1F3" => neutral/secondary very light
    public static var s100: Color { AppTheme.currentTheme.colors.s100Color } // "#F7FAFB" => neutral "98"
    public static var s50:  Color { AppTheme.currentTheme.colors.s50Color }  // "#FFFFFF" => "surfaceContainerLowest"
   
    // MARK: Warning (custom derived – not in scheme)
    public static var y900: Color { AppTheme.currentTheme.colors.y900Color }
    public static var y800: Color { AppTheme.currentTheme.colors.y800Color }
    public static var y700: Color { AppTheme.currentTheme.colors.y700Color }
    public static var y600: Color { AppTheme.currentTheme.colors.y600Color }
    public static var y500: Color { AppTheme.currentTheme.colors.y500Color }
    public static var y400: Color { AppTheme.currentTheme.colors.y400Color }
    public static var y300: Color { AppTheme.currentTheme.colors.y300Color }
    public static var y200: Color { AppTheme.currentTheme.colors.y200Color }
    public static var y100: Color { AppTheme.currentTheme.colors.y100Color }
    public static var y50:  Color { AppTheme.currentTheme.colors.y50Color }

    // MARK: Success (custom derived – not in scheme)
    public static var g900: Color { AppTheme.currentTheme.colors.g900Color }
    public static var g800: Color { AppTheme.currentTheme.colors.g800Color }
    public static var g700: Color { AppTheme.currentTheme.colors.g700Color }
    public static var g600: Color { AppTheme.currentTheme.colors.g600Color }
    public static var g500: Color { AppTheme.currentTheme.colors.g500Color }
    public static var g400: Color { AppTheme.currentTheme.colors.g400Color }
    public static var g300: Color { AppTheme.currentTheme.colors.g300Color }
    public static var g200: Color { AppTheme.currentTheme.colors.g200Color }
    public static var g100: Color { AppTheme.currentTheme.colors.g100Color }
    public static var g50:  Color { AppTheme.currentTheme.colors.g50Color }

    // MARK: Functional tokens (bạn đang dùng)
    public static var bgScreen: Color { AppTheme.currentTheme.colors.n50Color } // "#F5FAFD" => "background"/"surface"
    public static var bgContainer: Color { AppTheme.currentTheme.colors.surfaceColor } // "#FFFFFF" => "surfaceContainerLowest"
    public static var bgOnColor: Color { .white.opacity(0.05) } // overlay
    public static var bgHightLightSofter: Color { AppTheme.currentTheme.colors.p50Color } // "#F9FDFF" => palette primary "99"
    public static var bgHightLight: Color { AppTheme.currentTheme.colors.p200Color } // derived from primary palette
    public static var bgContainerLow: Color { AppTheme.currentTheme.colors.n100Color} // surface container low
    
    public static var characterHightlighted: Color { AppTheme.currentTheme.colors.p700Color } // "#03677E" => "primary"
    public static var characterHightlightedLighter: Color { AppTheme.currentTheme.colors.p400Color } // "#B4EBFF" => "primaryContainer"
    public static var characterPrimary: Color { AppTheme.currentTheme.colors.n900Color } // "#171C1F" => "onBackground"
    public static var characterSecondary: Color { AppTheme.currentTheme.colors.n600Color } // "#70787C" => "outline" (readable secondary)
    public static var characterTertiary: Color { AppTheme.currentTheme.colors.n400Color } // "#BFC8CC" => "outlineVariant"
    public static var characterInverse: Color { .white } // "#FFFFFF" => "onPrimary"/inverse

    public static var divider: Color { AppTheme.currentTheme.colors.n300Color } // "#DBE4E8" => "surfaceVariant"

    public static var warning: Color { AppTheme.currentTheme.colors.y700Color } // custom warning
    public static var success: Color { AppTheme.currentTheme.colors.g700Color } // custom success
    public static var active: Color { AppTheme.currentTheme.colors.p700Color } // "primary"

    public static var errorLighter: Color { Color(hex: "#FFDAD6") } // "errorContainer"
    public static var warningLighter: Color { AppTheme.currentTheme.colors.y100Color } // custom warning light
    public static var successLighter: Color { AppTheme.currentTheme.colors.g100Color } // custom success light
    public static var activeLighter: Color { AppTheme.currentTheme.colors.p400Color } // "primaryContainer"

    public static var badgeCounting: Color { AppTheme.currentTheme.colors.s300Color } // "#CFE6F0" => "secondaryContainer" (or use error-ish if you prefer)
    //mau theme moi:
    public static var primary: Color { AppTheme.currentTheme.colors.primaryColor }
    public static var onPrimary: Color { AppTheme.currentTheme.colors.onPrimaryColor }
    public static var secondary: Color { AppTheme.currentTheme.colors.secondaryColor }
    public static var onSecondary: Color { AppTheme.currentTheme.colors.onSecondaryColor }
    public static var tertiary : Color { AppTheme.currentTheme.colors.tertiaryColor }
    public static var error: Color { AppTheme.currentTheme.colors.errorColor }
    public static var onError: Color { AppTheme.currentTheme.colors.onErrorColor }
    public static var primaryContainer: Color { AppTheme.currentTheme.colors.primaryContainerColor }
    public static var secondaryContainer: Color { AppTheme.currentTheme.colors.secondaryContainerColor }
    public static var onSecondaryContainer: Color { AppTheme.currentTheme.colors.onSecondaryContainerColor }
    public static var teritaryContainer: Color { AppTheme.currentTheme.colors.teritaryContainerColor }
    public static var onTeritaryContainer: Color { AppTheme.currentTheme.colors.onTertaryContainerColor }
    public static var errorContainer: Color { AppTheme.currentTheme.colors.errorContainerColor }
    public static var onErrorContainer: Color { AppTheme.currentTheme.colors.onErrorContainerColor }
    public static var surfaceDim : Color { AppTheme.currentTheme.colors.surfaceDimColor }
    public static var surface: Color { AppTheme.currentTheme.colors.surfaceColor }
    public static var surfaceBright: Color { AppTheme.currentTheme.colors.surfaceBrightColor }
    public static var inverseSurface: Color { AppTheme.currentTheme.colors.inverseSurfaceColor }
    public static var surfContainerLowest: Color { AppTheme.currentTheme.colors.surfContainerLowestColor }
    public static var surfContainerLow: Color { AppTheme.currentTheme.colors.surfContainerLowColor }
    public static var surfContainer : Color { AppTheme.currentTheme.colors.surfContainerColor }
    public static var surfContainerHigh : Color { AppTheme.currentTheme.colors.surfContainerHighColor }
    public static var surfContainerHighest : Color {AppTheme.currentTheme.colors.surfContainerHighestColor }
    public static var inverseOnSurface: Color { AppTheme.currentTheme.colors.inverseOnSurfaceColor }
    public static var inversePrimary : Color { AppTheme.currentTheme.colors.inversePrimaryColor }
    public static var onSurface: Color { AppTheme.currentTheme.colors.onSurfaceColor }
    public static var onSurfaceVar: Color { AppTheme.currentTheme.colors.onSurfaceVarColor }
    public static var outline: Color { AppTheme.currentTheme.colors.outlineColor }
    public static var outlineVariant: Color { AppTheme.currentTheme.colors.outlineVariantColor }
    public static var scrim: Color { AppTheme.currentTheme.colors.scrimColor }
    public static var shadow: Color { AppTheme.currentTheme.colors.shadowColor }
}

// MARK: - UIKit UIColor tokens (Material 3 - Light scheme)
@MainActor
extension UIColor {

    // MARK: Neutrals
    public static var n900: UIColor { AppTheme.currentTheme.colors.n900 } // "#171C1F" => "onBackground"
    public static var n800: UIColor { AppTheme.currentTheme.colors.n800 } // "#40484B" => "onSurfaceVariant"
    public static var n700: UIColor { AppTheme.currentTheme.colors.n700 } // derived neutral
    public static var n600: UIColor { AppTheme.currentTheme.colors.n600 } // "#70787C" => "outline"
    public static var n500: UIColor { AppTheme.currentTheme.colors.n500 } // derived neutral
    public static var n400: UIColor { AppTheme.currentTheme.colors.n400 } // "#BFC8CC" => "outlineVariant"
    public static var n300: UIColor { AppTheme.currentTheme.colors.n300 } // "#DBE4E8" => "surfaceVariant"
    public static var n200: UIColor { AppTheme.currentTheme.colors.n200 } // "#EAEFF1" => "surfaceContainer"
    public static var n100: UIColor { AppTheme.currentTheme.colors.n100 } // "#EFF4F7" => "surfaceContainerLow"
    public static var n50:  UIColor { AppTheme.currentTheme.colors.n50 }  // "#F5FAFD" => "surface"/"background"
    public static var n0:   UIColor { AppTheme.currentTheme.colors.n0 }   // "#FFFFFF" => "surfaceContainerLowest"

    // MARK: Primary
    public static var p900: UIColor { AppTheme.currentTheme.colors.p900 } // "#004E5F" => "onPrimaryContainer"
    public static var p800: UIColor { AppTheme.currentTheme.colors.p800 } // "#004E5F" => "onPrimaryContainer" (fallback)
    public static var p700: UIColor { AppTheme.currentTheme.colors.p700 } // "#03677E" => "primary"
    public static var p600: UIColor { AppTheme.currentTheme.colors.p600 } // derived (primary scale)
    public static var p500: UIColor { AppTheme.currentTheme.colors.p500 } // derived (primary scale)
    public static var p450: UIColor { AppTheme.currentTheme.colors.p450 } // "#87D1EA" => "inversePrimary"
    public static var p400: UIColor { AppTheme.currentTheme.colors.p400 } // "#B4EBFF" => "primaryContainer"
    public static var p300: UIColor { AppTheme.currentTheme.colors.p300 } // derived (primary scale)
    public static var p200: UIColor { AppTheme.currentTheme.colors.p200 } // derived (primary scale)
    public static var p100: UIColor { AppTheme.currentTheme.colors.p100 } // "#F2FBFF" => palette primary "98"
    public static var p50:  UIColor { AppTheme.currentTheme.colors.p50 }  // "#F9FDFF" => palette primary "99"

    // MARK: Secondary
    public static var s900: UIColor { AppTheme.currentTheme.colors.s900 } // "#344A52" => "onSecondaryContainer"
    public static var s800: UIColor { AppTheme.currentTheme.colors.s800 } // "#4C626A" => "secondary"
    public static var s700: UIColor { AppTheme.currentTheme.colors.s700 } // "#4C626A" => "secondary"
    public static var s600: UIColor { AppTheme.currentTheme.colors.s600 } // derived (secondary scale)
    public static var s500: UIColor { AppTheme.currentTheme.colors.s500 } // derived (secondary scale)
    public static var s400: UIColor { AppTheme.currentTheme.colors.s400 } // "#B3CAD4" => "secondaryFixedDim" (close)
    public static var s300: UIColor { AppTheme.currentTheme.colors.s300 } // "#CFE6F0" => "secondaryContainer"
    public static var s200: UIColor { AppTheme.currentTheme.colors.s200 } // "#EEF1F3" => very light neutral
    public static var s100: UIColor { AppTheme.currentTheme.colors.s100 } // "#F7FAFB" => neutral "98"
    public static var s50:  UIColor { AppTheme.currentTheme.colors.s50 }  // "#FFFFFF" => "surfaceContainerLowest"
  
    // MARK: Warning (custom derived)
    public static var y900: UIColor { AppTheme.currentTheme.colors.y900 }
    public static var y800: UIColor { AppTheme.currentTheme.colors.y800 }
    public static var y700: UIColor { AppTheme.currentTheme.colors.y700 }
    public static var y600: UIColor { AppTheme.currentTheme.colors.y600 }
    public static var y500: UIColor { AppTheme.currentTheme.colors.y500 }
    public static var y400: UIColor { AppTheme.currentTheme.colors.y400 }
    public static var y300: UIColor { AppTheme.currentTheme.colors.y300 }
    public static var y200: UIColor { AppTheme.currentTheme.colors.y200 }
    public static var y100: UIColor { AppTheme.currentTheme.colors.y100 }
    public static var y50:  UIColor { AppTheme.currentTheme.colors.y50 }

    // MARK: Success (custom derived)
    public static var g900: UIColor { AppTheme.currentTheme.colors.g900 }
    public static var g800: UIColor { AppTheme.currentTheme.colors.g800 }
    public static var g700: UIColor { AppTheme.currentTheme.colors.g700 }
    public static var g600: UIColor { AppTheme.currentTheme.colors.g600 }
    public static var g500: UIColor { AppTheme.currentTheme.colors.g500 }
    public static var g400: UIColor { AppTheme.currentTheme.colors.g400 }
    public static var g300: UIColor { AppTheme.currentTheme.colors.g300 }
    public static var g200: UIColor { AppTheme.currentTheme.colors.g200 }
    public static var g100: UIColor { AppTheme.currentTheme.colors.g100 }
    public static var g50:  UIColor { AppTheme.currentTheme.colors.g50 }

    // MARK: Functional tokens
    public static var bgScreen: UIColor { AppTheme.currentTheme.colors.n50 } // "#F5FAFD" => "background"/"surface"
    public static var bgContainer: UIColor { AppTheme.currentTheme.colors.n0 } // "#FFFFFF" => "surfaceContainerLowest"
    public static var bgOnColor: UIColor { UIColor.white.withAlphaComponent(0.05) } // overlay
    public static var bgHightLightSofter: UIColor { .p50 } // "#F9FDFF" => palette primary "99"
    public static var bgHightLight: UIColor { .p200 } // derived primary scale
    public static var bgContainerLow: UIColor { .n100 } // surface container low

    public static var characterHightlighted: UIColor { .p700 } // "#03677E" => "primary"
    public static var characterHightlightedLighter: UIColor { .p400 } // "#B4EBFF" => "primaryContainer"
    public static var characterPrimary: UIColor { .n900 } // "#171C1F" => "onBackground"
    public static var characterSecondary: UIColor { .n600 } // "#70787C" => "outline"
    public static var characterTertiary: UIColor { .n400 } // "#BFC8CC" => "outlineVariant"
    public static var characterInverse: UIColor { .white }

    public static var divider: UIColor { .n300 } // "#DBE4E8" => "surfaceVariant"

    public static var warning: UIColor { .y700 } // custom warning
    public static var success: UIColor { .g700 } // custom success
    public static var active: UIColor { .p700 } // "primary"

    public static var errorLighter: UIColor { UIColor(hex: "#FFDAD6") } // "errorContainer"
    public static var warningLighter: UIColor { .y100 }
    public static var successLighter: UIColor { .g100 }
    public static var activeLighter: UIColor { .p400 } // "primaryContainer"

    public static var badgeCounting: UIColor { .s300 } // "#CFE6F0" => "secondaryContainer"
    
    //mau theme moi:
    public static var primary: UIColor { AppTheme.currentTheme.colors.primary }
    public static var onPrimary: UIColor { AppTheme.currentTheme.colors.onPrimary }
    public static var secondary: UIColor { AppTheme.currentTheme.colors.secondary }
    public static var onSecondary: UIColor { AppTheme.currentTheme.colors.onSecondary }
    public static var tertiary : UIColor { AppTheme.currentTheme.colors.tertiary }
    public static var error: UIColor { AppTheme.currentTheme.colors.error }
    public static var onError: UIColor { AppTheme.currentTheme.colors.onError }
    public static var primaryContainer: UIColor { AppTheme.currentTheme.colors.primaryContainer }
    public static var secondaryContainer: UIColor { AppTheme.currentTheme.colors.secondaryContainer }
    public static var onSecondaryContainer: UIColor { AppTheme.currentTheme.colors.onSecondaryContainer }
    public static var teritaryContainer: UIColor { AppTheme.currentTheme.colors.teritaryContainer }
    public static var onTeritaryContainer: UIColor { AppTheme.currentTheme.colors.onTeritaryContainer }
    public static var errorContainer: UIColor { AppTheme.currentTheme.colors.errorContainer }
    public static var onErrorContainer: UIColor { AppTheme.currentTheme.colors.onErrorContainer}
    public static var surfaceDim : UIColor { AppTheme.currentTheme.colors.surfaceDim }
    public static var surface: UIColor { AppTheme.currentTheme.colors.surface }
    public static var surfaceBright: UIColor { AppTheme.currentTheme.colors.surfaceBright }
    public static var inverseSurface: UIColor { AppTheme.currentTheme.colors.inverseSurface }
    public static var surfContainerLowest: UIColor { AppTheme.currentTheme.colors.surfContainerLowest }
    public static var surfContainerLow: UIColor { AppTheme.currentTheme.colors.surfContainerLow }
    public static var surfContainer : UIColor { AppTheme.currentTheme.colors.surfContainer }
    public static var surfContainerHigh : UIColor { AppTheme.currentTheme.colors.surfContainerHigh }
    public static var surfContainerHighest : UIColor { AppTheme.currentTheme.colors.surfContainerHighest }
    public static var inverseOnSurface: UIColor { AppTheme.currentTheme.colors.inverseOnSurface }
    public static var inversePrimary : UIColor { AppTheme.currentTheme.colors.inversePrimary }
    public static var onSurface: UIColor { AppTheme.currentTheme.colors.onSurface }
    public static var onSurfaceVar: UIColor { AppTheme.currentTheme.colors.onSurfaceVar }
    public static var outline: UIColor { AppTheme.currentTheme.colors.outline }
    public static var outlineVariant: UIColor { AppTheme.currentTheme.colors.outlineVariant }
    public static var scrim: UIColor { AppTheme.currentTheme.colors.scrim }
    public static var shadow: UIColor { AppTheme.currentTheme.colors.shadow }
}
