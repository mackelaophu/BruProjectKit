//
//  AppTheme.swift
//  AdapfitV2
//
//  Created by PhamHai Dang on 29/5/26.
//  Copyright © 2026 Bru. All rights reserved.
//


import SwiftUI
import UIKit

// MARK: - AppTheme
public struct AppTheme: Sendable {

    // MARK: Colors
    public struct Colors: Sendable {

        // Neutral
        public let n900, n800, n700, n600, n500, n400, n300, n200, n100, n50, n0: UIColor
        // Neutral Variant
        public let nv900, nv800, nv700, nv600, nv500, nv400, nv300, nv200, nv100, nv50: UIColor

        // Primary
        public let p900, p800, p700, p600, p500, p450, p400, p300, p200, p100, p50: UIColor

        // Secondary
        public let s900, s800, s700, s600, s500, s400, s300, s200, s100, s50: UIColor

        // Warning
        public let y900, y800, y700, y600, y500, y400, y300, y200, y100, y50: UIColor

        // Success
        public let g900, g800, g700, g600, g500, g400, g300, g200, g100, g50: UIColor
        // Tertiary
        public let t900, t800, t700, t600, t500, t400, t300, t200, t100, t50: UIColor

        public let white: UIColor
        public let primary: UIColor
        public let onPrimary: UIColor
        public let secondary: UIColor
        public let onSecondary: UIColor
        public let tertiary: UIColor
        public let error: UIColor
        public let onError: UIColor
        public let primaryContainer: UIColor
        public let secondaryContainer: UIColor
        public let onSecondaryContainer: UIColor
        public let teritaryContainer: UIColor
        public let onTeritaryContainer: UIColor
        public let errorContainer: UIColor
        public let onErrorContainer: UIColor
        public let surfaceDim: UIColor
        public let surface: UIColor
        public let surfaceBright: UIColor
        public let inverseSurface: UIColor
        public let surfContainerLowest: UIColor
        public let surfContainerLow: UIColor
        public let surfContainer: UIColor
        public let surfContainerHigh: UIColor
        public let surfContainerHighest: UIColor
        public let inverseOnSurface: UIColor
        public let inversePrimary: UIColor
        public let onSurface: UIColor
        public let onSurfaceVar: UIColor
        public let outline: UIColor
        public let outlineVariant: UIColor
        public let scrim: UIColor
        public let shadow: UIColor

        // MARK: SwiftUI bridge
        public var n900Color: Color { Color(n900) }
        public var n800Color: Color { Color(n800) }
        public var n700Color: Color { Color(n700) }
        public var n600Color: Color { Color(n600) }
        public var n500Color: Color { Color(n500) }
        public var n400Color: Color { Color(n400) }
        public var n300Color: Color { Color(n300) }
        public var n200Color: Color { Color(n200) }
        public var n100Color: Color { Color(n100) }
        public var n50Color:  Color { Color(n50) }
        public var n0Color:   Color { Color(n0) }
        // Neutral Variant
        public var nv900Color: Color { Color(nv900) }
        public var nv800Color: Color { Color(nv800) }
        public var nv700Color: Color { Color(nv700) }
        public var nv600Color: Color { Color(nv600) }
        public var nv500Color: Color { Color(nv500) }
        public var nv400Color: Color { Color(nv400) }
        public var nv300Color: Color { Color(nv300) }
        public var nv200Color: Color { Color(nv200) }
        public var nv100Color: Color { Color(nv100) }
        public var nv50Color:  Color { Color(nv50) }
        
        // Primary
        public var p900Color: Color { Color(p900) }
        public var p800Color: Color { Color(p800) }
        public var p700Color: Color { Color(p700) }
        public var p600Color: Color { Color(p600) }
        public var p500Color: Color { Color(p500) }
        public var p450Color: Color { Color(p450) }
        public var p400Color: Color { Color(p400) }
        public var p300Color: Color { Color(p300) }
        public var p200Color: Color { Color(p200) }
        public var p100Color: Color { Color(p100) }
        public var p50Color:  Color { Color(p50) }
        
        // Secondary
        public var s900Color: Color { Color(s900) }
        public var s800Color: Color { Color(s800) }
        public var s700Color: Color { Color(s700) }
        public var s600Color: Color { Color(s600) }
        public var s500Color: Color { Color(s500) }
        public var s400Color: Color { Color(s400) }
        public var s300Color: Color { Color(s300) }
        public var s200Color: Color { Color(s200) }
        public var s100Color: Color { Color(s100) }
        public var s50Color:  Color { Color(s50) }
        
        // Warning
        public var y900Color: Color { Color(y900) }
        public var y800Color: Color { Color(y800) }
        public var y700Color: Color { Color(y700) }
        public var y600Color: Color { Color(y600) }
        public var y500Color: Color { Color(y500) }
        public var y400Color: Color { Color(y400) }
        public var y300Color: Color { Color(y300) }
        public var y200Color: Color { Color(y200) }
        public var y100Color: Color { Color(y100) }
        public var y50Color:  Color { Color(y50) }
        
        // Success
        public var g900Color: Color { Color(g900) }
        public var g800Color: Color { Color(g800) }
        public var g700Color: Color { Color(g700) }
        public var g600Color: Color { Color(g600) }
        public var g500Color: Color { Color(g500) }
        public var g400Color: Color { Color(g400) }
        public var g300Color: Color { Color(g300) }
        public var g200Color: Color { Color(g200) }
        public var g100Color: Color { Color(g100) }
        public var g50Color:  Color { Color(g50) }
        // Tertiary
        public var t900Color: Color { Color(t900) }
        public var t800Color: Color { Color(t800) }
        public var t700Color: Color { Color(t700) }
        public var t600Color: Color { Color(t600) }
        public var t500Color: Color { Color(t500) }
        public var t400Color: Color { Color(t400) }
        public var t300Color: Color { Color(t300) }
        public var t200Color: Color { Color(t200) }
        public var t100Color: Color { Color(t100) }
        public var t50Color:  Color { Color(t50) }
       
        public var secondaryColor: Color {Color(secondary)}
        public var onSecondaryColor: Color {Color(n0)}
        public var tertiaryColor: Color {Color(tertiary)}
        public var onTertiaryColor: Color {Color(n0)}
        public var errorColor: Color {Color(error)}
        public var onErrorColor: Color {Color(onError)}

        //primary
        public var primaryColor: Color {Color(primary)}
        public var onPrimaryColor: Color {Color(onPrimary)}
        public var primaryContainerColor: Color {Color(primaryContainer)}
        public var onPrimaryContainerColor: Color {Color(p700)}
        public var secondaryContainerColor: Color {Color(secondaryContainer)}
        public var onSecondaryContainerColor: Color {Color(onSecondaryContainer)}
        public var teritaryContainerColor: Color {Color(teritaryContainer)}
        public var onTertaryContainerColor: Color {Color(onTeritaryContainer)}
        public var errorContainerColor: Color {Color(errorContainer)}
        public var onErrorContainerColor: Color {Color(onErrorContainer)}
        public var surfaceDimColor: Color {Color(surfaceDim)}
        public var surfaceColor: Color {Color(surface)}
        public var surfaceBrightColor: Color {Color(surfaceBright)}
        public var inverseSurfaceColor: Color {Color(inverseSurface)}
        public var surfContainerLowestColor: Color {Color(surfContainerLowest)}
        public var surfContainerLowColor: Color {Color(surfContainerLow)}
        public var surfContainerColor: Color {Color(surfContainer)}
        public var surfContainerHighColor: Color {Color(surfContainerHigh)}
        public var surfContainerHighestColor: Color {Color(surfContainerHighest)}
        public var inverseOnSurfaceColor: Color {Color(inverseOnSurface)}
        public var inversePrimaryColor: Color {Color(inversePrimary)}
        public var onSurfaceColor: Color {Color(onSurface)}
        public var onSurfaceVarColor: Color {Color(onSurfaceVar)}
        public var outlineColor: Color {Color(outline)}
        public var outlineVariantColor: Color {Color(outlineVariant)}
        public var scrimColor: Color {Color(scrim)}
        public var shadowColor: Color {Color(shadow)}
        // Custom
        public var whiteColor: Color { Color(white) }

        // MARK: Functional tokens (Material-like)
        public var bgScreen: Color { n50Color }
        public var bgContainer: Color { n0Color }
        public var bgHighlight: Color { p200Color }

       
        public var divider: Color { Color(n300) }
        public var warning: Color { y700Color }
        public var success: Color { g700Color }
    }

    // MARK: Radius
    public struct Radius: Sendable {
        public let defaultRadius: CGFloat = 24
        public let roundedRadius: CGFloat = 999
    }

    public let colors: Colors
    public let radius: Radius = .init()
}

// MARK: - Material Light Theme
extension AppTheme {

    public static let light: AppTheme = {
        // Break colors into explicit constants to help the type-checker
        let n900 = UIColor(hex: "#444747")
        let n800 = UIColor(hex: "#5C5F5F")
        let n700 = UIColor(hex: "#757778")
        let n600 = UIColor(hex: "#8F9191")
        let n500 = UIColor(hex: "#A9ACAC")
        let n400 = UIColor(hex: "#C5C7C7")
        let n300 = UIColor(hex: "#E1E3E3")
        let n200 = UIColor(hex: "#EFF1F1")
        let n100 = UIColor(hex: "#F8FAF9")
        let n50  = UIColor(hex: "#FBFCFC")
        let n0   = UIColor(hex: "#FFFFFF")
        
        
        let nv900 = UIColor(hex: "#404849")
        let nv800 = UIColor(hex: "#576061")
        let nv700 = UIColor(hex: "#707979")
        let nv600 = UIColor(hex: "#8A9293")
        let nv500 = UIColor(hex: "#A4ADAE")
        let nv400 = UIColor(hex: "#BFC8C9")
        let nv300 = UIColor(hex: "#DBE4E5")
        let nv200 = UIColor(hex: "#EAF2F3")
        let nv100 = UIColor(hex: "#F2FBFC")
        let nv50  = UIColor(hex: "#F5FEFE")

        let p900 = UIColor(hex: "#004F54")
        let p800 = UIColor(hex: "#006970")
        let p700 = UIColor(hex: "#00848D")
        let p600 = UIColor(hex: "#10A0AA")
        let p500 = UIColor(hex: "#41BBC5")
        let p450 = UIColor(hex: "#87D1EA")
        let p400 = UIColor(hex: "#63D7E1")
        let p300 = UIColor(hex: "#81F4FE")
        let p200 = UIColor(hex: "#C7FAFF")
        let p100 = UIColor(hex: "#E9FDFF")
        let p50  = UIColor(hex: "#F4FEFF")

        let s900 = UIColor(hex: "#354A4D")
        let s800 = UIColor(hex: "#4C6264")
        let s700 = UIColor(hex: "#657B7D")
        let s600 = UIColor(hex: "#7E9597")
        let s500 = UIColor(hex: "#98AFB2")
        let s400 = UIColor(hex: "#B3CBCD")
        let s300 = UIColor(hex: "#CFE7E9")
        let s200 = UIColor(hex: "#DDF5F8")
        let s100 = UIColor(hex: "#E9FDFF")
        let s50  = UIColor(hex: "#F4FEFF")

        let y900 = UIColor(hex: "#5C3D00")
        let y800 = UIColor(hex: "#855800")
        let y700 = UIColor(hex: "#AD7400")
        let y600 = UIColor(hex: "#D68F00")
        let y500 = UIColor(hex: "#FFAD0A")
        let y400 = UIColor(hex: "#FFBC36")
        let y300 = UIColor(hex: "#FFCA62")
        let y200 = UIColor(hex: "#FFD98E")
        let y100 = UIColor(hex: "#FFE8BA")
        let y50  = UIColor(hex: "#FFF7E6")

        let g900 = UIColor(hex: "#2C5800")
        let g800 = UIColor(hex: "#407A05")
        let g700 = UIColor(hex: "#569C0F")
        let g600 = UIColor(hex: "#6EBE1D")
        let g500 = UIColor(hex: "#88E02F")
        let g400 = UIColor(hex: "#97FE30")
        let g300 = UIColor(hex: "#B6FF6E")
        let g200 = UIColor(hex: "#CBFF98")
        let g100 = UIColor(hex: "#E0FFC2")
        let g50  = UIColor(hex: "#F5FFEC")

        let t900 = UIColor(hex: "#3A4761")
        let t800 = UIColor(hex: "#515E7A")
        let t700 = UIColor(hex: "#6A7794")
        let t600 = UIColor(hex: "#8391AE")
        let t500 = UIColor(hex: "#9EABCA")
        let t400 = UIColor(hex: "#B9C7E6")
        let t300 = UIColor(hex: "#D7E2FF")
        let t200 = UIColor(hex: "#ECF0FF")
        let t100 = UIColor(hex: "#F9F9FF")
        let t50  = UIColor(hex: "#FDFBFF")

        let white = UIColor.white
        let primary = UIColor(hex: "#006970")
        let onPrimary = UIColor(hex: "#FFFFFF")
        let secondary = UIColor(hex: "#4A6365")
        let onSecondary = UIColor(hex: "#FFFFFF")
        let tertiary = UIColor(hex: "#4F5E7D")
        let error = UIColor(hex: "#BA1A1A")
        let onError = UIColor(hex: "#FFFFFF")
        let primaryContainer = UIColor(hex: "#004F54")
        let secondaryContainer = UIColor(hex: "#CCE8EA")
        let onSecondaryContainer = UIColor(hex: "#324B4D")
        let teritaryContainer = UIColor(hex: "#D7E2FF")
        let onTeritaryContainer = UIColor(hex: "#384764")
        let errorContainer = UIColor(hex: "#FFDAD6")
        let onErrorContainer = UIColor(hex: "#93000A")
        let surfaceDim = UIColor(hex: "#D5DBDB")
        let surface = UIColor(hex: "#F4FAFB")
        let surfaceBright = UIColor(hex: "#F4FAFB")
        let inverseSurface = UIColor(hex: "#2B3232")
        let surfContainerLowest = UIColor(hex: "#FFFFFF")
        let surfContainerLow = UIColor(hex: "#EFF5F5")
        let surfContainer = UIColor(hex: "#E9EFEF")
        let surfContainerHigh = UIColor(hex: "#E3E9EA")
        let surfContainerHighest = UIColor(hex: "#DEE4E4")
        let inverseOnSurface = UIColor(hex: "#ECF2F2")
        let inversePrimary = UIColor(hex: "#80D4DC")
        let onSurface = UIColor(hex: "#161D1D")
        let onSurfaceVar = UIColor(hex: "#3F4849")
        let outline = UIColor(hex: "#6F797A")
        let outlineVariant = UIColor(hex: "#BEC8C9")
        let scrim = UIColor(hex: "#000000")
        let shadow = UIColor(hex: "#000000")

        let colors = Colors(n900: n900,
                            n800: n800,
                            n700: n700,
                            n600: n600,
                            n500: n500,
                            n400: n400,
                            n300: n300,
                            n200: n200,
                            n100: n100,
                            n50: n50,
                            n0: n0,
                            nv900: nv900,
                            nv800: nv800,
                            nv700: nv700,
                            nv600: nv600,
                            nv500: nv500,
                            nv400: nv400,
                            nv300: nv300,
                            nv200: nv200,
                            nv100: nv100,
                            nv50: nv50,
                            p900: p900,
                            p800: p800,
                            p700: p700,
                            p600: p600,
                            p500: p500,
                            p450: p450,
                            p400: p400,
                            p300: p300,
                            p200: p200,
                            p100: p100,
                            p50: p50,
                            s900: s900,
                            s800: s800,
                            s700: s700,
                            s600: s600,
                            s500: s500,
                            s400: s400,
                            s300: s300,
                            s200: s200,
                            s100: s100,
                            s50: s50,
                            y900: y900,
                            y800: y800,
                            y700: y700,
                            y600: y600,
                            y500: y500,
                            y400: y400,
                            y300: y300,
                            y200: y200,
                            y100: y100,
                            y50: y50,
                            g900: g900,
                            g800: g800,
                            g700: g700,
                            g600: g600,
                            g500: g500,
                            g400: g400,
                            g300: g300,
                            g200: g200,
                            g100: g100,
                            g50: g50,
                            t900: t900,
                            t800: t800,
                            t700: t700,
                            t600: t600,
                            t500: t500,
                            t400: t400,
                            t300: t300,
                            t200: t200,
                            t100: t100,
                            t50: t50,
                            white: white,
                            primary: primary,
                            onPrimary: onPrimary,
                            secondary: secondary,
                            onSecondary: onSecondary,
                            tertiary: tertiary,
                            error: error,
                            onError: onError,
                            primaryContainer: primaryContainer,
                            secondaryContainer: secondaryContainer,
                            onSecondaryContainer: onSecondaryContainer,
                            teritaryContainer: teritaryContainer,
                            onTeritaryContainer: onTeritaryContainer,
                            errorContainer: errorContainer,
                            onErrorContainer: onErrorContainer,
                            surfaceDim: surfaceDim,
                            surface: surface,
                            surfaceBright: surfaceBright,
                            inverseSurface: inverseSurface,
                            surfContainerLowest: surfContainerLowest,
                            surfContainerLow: surfContainerLow,
                            surfContainer: surfContainer,
                            surfContainerHigh: surfContainerHigh,
                            surfContainerHighest: surfContainerHighest,
                            inverseOnSurface: inverseOnSurface,
                            inversePrimary: inversePrimary,
                            onSurface: onSurface,
                            onSurfaceVar: onSurfaceVar,
                            outline: outline,
                            outlineVariant: outlineVariant,
                            scrim: scrim,
                            shadow: shadow)

        return AppTheme(colors: colors)
    }()
    
    
    public static let lightMediumContrast: AppTheme = {
        // Break colors into explicit constants to help the type-checker
        let n900 = UIColor(hex: "#444747")
        let n800 = UIColor(hex: "#5C5F5F")
        let n700 = UIColor(hex: "#757778")
        let n600 = UIColor(hex: "#8F9191")
        let n500 = UIColor(hex: "#A9ACAC")
        let n400 = UIColor(hex: "#C5C7C7")
        let n300 = UIColor(hex: "#E1E3E3")
        let n200 = UIColor(hex: "#EFF1F1")
        let n100 = UIColor(hex: "#F8FAF9")
        let n50  = UIColor(hex: "#FBFCFC")
        let n0   = UIColor(hex: "#FFFFFF")
        
        
        let nv900 = UIColor(hex: "#404849")
        let nv800 = UIColor(hex: "#576061")
        let nv700 = UIColor(hex: "#707979")
        let nv600 = UIColor(hex: "#8A9293")
        let nv500 = UIColor(hex: "#A4ADAE")
        let nv400 = UIColor(hex: "#BFC8C9")
        let nv300 = UIColor(hex: "#DBE4E5")
        let nv200 = UIColor(hex: "#EAF2F3")
        let nv100 = UIColor(hex: "#F2FBFC")
        let nv50  = UIColor(hex: "#F5FEFE")

        let p900 = UIColor(hex: "#004F54")
        let p800 = UIColor(hex: "#006970")
        let p700 = UIColor(hex: "#00848D")
        let p600 = UIColor(hex: "#10A0AA")
        let p500 = UIColor(hex: "#41BBC5")
        let p450 = UIColor(hex: "#87D1EA")
        let p400 = UIColor(hex: "#63D7E1")
        let p300 = UIColor(hex: "#81F4FE")
        let p200 = UIColor(hex: "#C7FAFF")
        let p100 = UIColor(hex: "#E9FDFF")
        let p50  = UIColor(hex: "#F4FEFF")

        let s900 = UIColor(hex: "#354A4D")
        let s800 = UIColor(hex: "#4C6264")
        let s700 = UIColor(hex: "#657B7D")
        let s600 = UIColor(hex: "#7E9597")
        let s500 = UIColor(hex: "#98AFB2")
        let s400 = UIColor(hex: "#B3CBCD")
        let s300 = UIColor(hex: "#CFE7E9")
        let s200 = UIColor(hex: "#DDF5F8")
        let s100 = UIColor(hex: "#E9FDFF")
        let s50  = UIColor(hex: "#F4FEFF")

        let y900 = UIColor(hex: "#5C3D00")
        let y800 = UIColor(hex: "#855800")
        let y700 = UIColor(hex: "#AD7400")
        let y600 = UIColor(hex: "#D68F00")
        let y500 = UIColor(hex: "#FFAD0A")
        let y400 = UIColor(hex: "#FFBC36")
        let y300 = UIColor(hex: "#FFCA62")
        let y200 = UIColor(hex: "#FFD98E")
        let y100 = UIColor(hex: "#FFE8BA")
        let y50  = UIColor(hex: "#FFF7E6")

        let g900 = UIColor(hex: "#2C5800")
        let g800 = UIColor(hex: "#407A05")
        let g700 = UIColor(hex: "#569C0F")
        let g600 = UIColor(hex: "#6EBE1D")
        let g500 = UIColor(hex: "#88E02F")
        let g400 = UIColor(hex: "#97FE30")
        let g300 = UIColor(hex: "#B6FF6E")
        let g200 = UIColor(hex: "#CBFF98")
        let g100 = UIColor(hex: "#E0FFC2")
        let g50  = UIColor(hex: "#F5FFEC")

        let t900 = UIColor(hex: "#3A4761")
        let t800 = UIColor(hex: "#515E7A")
        let t700 = UIColor(hex: "#6A7794")
        let t600 = UIColor(hex: "#8391AE")
        let t500 = UIColor(hex: "#9EABCA")
        let t400 = UIColor(hex: "#B9C7E6")
        let t300 = UIColor(hex: "#D7E2FF")
        let t200 = UIColor(hex: "#ECF0FF")
        let t100 = UIColor(hex: "#F9F9FF")
        let t50  = UIColor(hex: "#FDFBFF")

        let white = UIColor.white
        let primary = UIColor(hex: "#003D41")
        let onPrimary = UIColor(hex: "#FFFFFF")
        
        let secondary = UIColor(hex: "#213A3C")
        let onSecondary = UIColor(hex: "#FFFFFF")
        
        let tertiary = UIColor(hex: "#273652")
        
        let error = UIColor(hex: "#FFFFFF")
        let onError = UIColor(hex: "#FFFFFF")
        let primaryContainer = UIColor(hex: "#167880")
        let secondaryContainer = UIColor(hex: "#587174")
        let onSecondaryContainer = UIColor(hex: "#FFFFFF")
        
        let teritaryContainer = UIColor(hex: "#5E6D8C")
        let onTeritaryContainer = UIColor(hex: "#FFFFFF")
        
        let errorContainer = UIColor(hex: "#CF2C27")
        let onErrorContainer = UIColor(hex: "#FFFFFF")
        
        let surfaceDim = UIColor(hex: "#C1C8C8")
        let surface = UIColor(hex: "#F4FAFB")
        let surfaceBright = UIColor(hex: "#F4FAFB")
        let inverseSurface = UIColor(hex: "#2B3232")
        
        let surfContainerLowest = n0
        let surfContainerLow = UIColor(hex: "#EFF5F5")
        let surfContainer = UIColor(hex: "#E3E9EA")
        let surfContainerHigh = UIColor(hex: "#D8DEDE")
        let surfContainerHighest = UIColor(hex: "#CDD3D3")
        
        let inverseOnSurface = UIColor(hex: "#ECF2F2")
        let inversePrimary = UIColor(hex: "#80D4DC")
        
        let onSurface = UIColor(hex: "#0C1213")
        let onSurfaceVar = UIColor(hex: "#2E3839")
        
        let outline = UIColor(hex: "#4B5455")
        let outlineVariant = UIColor(hex: "#4B5455")
        
        let scrim = UIColor(hex: "#000000")
        let shadow = UIColor(hex: "#000000")

        let colors = Colors(n900: n900,
                            n800: n800,
                            n700: n700,
                            n600: n600,
                            n500: n500,
                            n400: n400,
                            n300: n300,
                            n200: n200,
                            n100: n100,
                            n50: n50,
                            n0: n0,
                            nv900: nv900,
                            nv800: nv800,
                            nv700: nv700,
                            nv600: nv600,
                            nv500: nv500,
                            nv400: nv400,
                            nv300: nv300,
                            nv200: nv200,
                            nv100: nv100,
                            nv50: nv50,
                            p900: p900,
                            p800: p800,
                            p700: p700,
                            p600: p600,
                            p500: p500,
                            p450: p450,
                            p400: p400,
                            p300: p300,
                            p200: p200,
                            p100: p100,
                            p50: p50,
                            s900: s900,
                            s800: s800,
                            s700: s700,
                            s600: s600,
                            s500: s500,
                            s400: s400,
                            s300: s300,
                            s200: s200,
                            s100: s100,
                            s50: s50,
                            y900: y900,
                            y800: y800,
                            y700: y700,
                            y600: y600,
                            y500: y500,
                            y400: y400,
                            y300: y300,
                            y200: y200,
                            y100: y100,
                            y50: y50,
                            g900: g900,
                            g800: g800,
                            g700: g700,
                            g600: g600,
                            g500: g500,
                            g400: g400,
                            g300: g300,
                            g200: g200,
                            g100: g100,
                            g50: g50,
                            t900: t900,
                            t800: t800,
                            t700: t700,
                            t600: t600,
                            t500: t500,
                            t400: t400,
                            t300: t300,
                            t200: t200,
                            t100: t100,
                            t50: t50,
                            white: white,
                            primary: primary,
                            onPrimary: onPrimary,
                            secondary: secondary,
                            onSecondary: onSecondary,
                            tertiary: tertiary,
                            error: error,
                            onError: onError,
                            primaryContainer: primaryContainer,
                            secondaryContainer: secondaryContainer,
                            onSecondaryContainer: onSecondaryContainer,
                            teritaryContainer: teritaryContainer,
                            onTeritaryContainer: onTeritaryContainer,
                            errorContainer: errorContainer,
                            onErrorContainer: onErrorContainer,
                            surfaceDim: surfaceDim,
                            surface: surface,
                            surfaceBright: surfaceBright,
                            inverseSurface: inverseSurface,
                            surfContainerLowest: surfContainerLowest,
                            surfContainerLow: surfContainerLow,
                            surfContainer: surfContainer,
                            surfContainerHigh: surfContainerHigh,
                            surfContainerHighest: surfContainerHighest,
                            inverseOnSurface: inverseOnSurface,
                            inversePrimary: inversePrimary,
                            onSurface: onSurface,
                            onSurfaceVar: onSurfaceVar,
                            outline: outline,
                            outlineVariant: outlineVariant,
                            scrim: scrim,
                            shadow: shadow)

        return AppTheme(colors: colors)
    }()
    
    
    public static let lightHighContrast: AppTheme = {
        // Break colors into explicit constants to help the type-checker
        let n900 = UIColor(hex: "#444747")
        let n800 = UIColor(hex: "#5C5F5F")
        let n700 = UIColor(hex: "#757778")
        let n600 = UIColor(hex: "#8F9191")
        let n500 = UIColor(hex: "#A9ACAC")
        let n400 = UIColor(hex: "#C5C7C7")
        let n300 = UIColor(hex: "#E1E3E3")
        let n200 = UIColor(hex: "#EFF1F1")
        let n100 = UIColor(hex: "#F8FAF9")
        let n50  = UIColor(hex: "#FBFCFC")
        let n0   = UIColor(hex: "#FFFFFF")
        
        
        let nv900 = UIColor(hex: "#404849")
        let nv800 = UIColor(hex: "#576061")
        let nv700 = UIColor(hex: "#707979")
        let nv600 = UIColor(hex: "#8A9293")
        let nv500 = UIColor(hex: "#A4ADAE")
        let nv400 = UIColor(hex: "#BFC8C9")
        let nv300 = UIColor(hex: "#DBE4E5")
        let nv200 = UIColor(hex: "#EAF2F3")
        let nv100 = UIColor(hex: "#F2FBFC")
        let nv50  = UIColor(hex: "#F5FEFE")

        let p900 = UIColor(hex: "#004F54")
        let p800 = UIColor(hex: "#006970")
        let p700 = UIColor(hex: "#00848D")
        let p600 = UIColor(hex: "#10A0AA")
        let p500 = UIColor(hex: "#41BBC5")
        let p450 = UIColor(hex: "#87D1EA")
        let p400 = UIColor(hex: "#63D7E1")
        let p300 = UIColor(hex: "#81F4FE")
        let p200 = UIColor(hex: "#C7FAFF")
        let p100 = UIColor(hex: "#E9FDFF")
        let p50  = UIColor(hex: "#F4FEFF")

        let s900 = UIColor(hex: "#354A4D")
        let s800 = UIColor(hex: "#4C6264")
        let s700 = UIColor(hex: "#657B7D")
        let s600 = UIColor(hex: "#7E9597")
        let s500 = UIColor(hex: "#98AFB2")
        let s400 = UIColor(hex: "#B3CBCD")
        let s300 = UIColor(hex: "#CFE7E9")
        let s200 = UIColor(hex: "#DDF5F8")
        let s100 = UIColor(hex: "#E9FDFF")
        let s50  = UIColor(hex: "#F4FEFF")

        let y900 = UIColor(hex: "#5C3D00")
        let y800 = UIColor(hex: "#855800")
        let y700 = UIColor(hex: "#AD7400")
        let y600 = UIColor(hex: "#D68F00")
        let y500 = UIColor(hex: "#FFAD0A")
        let y400 = UIColor(hex: "#FFBC36")
        let y300 = UIColor(hex: "#FFCA62")
        let y200 = UIColor(hex: "#FFD98E")
        let y100 = UIColor(hex: "#FFE8BA")
        let y50  = UIColor(hex: "#FFF7E6")

        let g900 = UIColor(hex: "#2C5800")
        let g800 = UIColor(hex: "#407A05")
        let g700 = UIColor(hex: "#569C0F")
        let g600 = UIColor(hex: "#6EBE1D")
        let g500 = UIColor(hex: "#88E02F")
        let g400 = UIColor(hex: "#97FE30")
        let g300 = UIColor(hex: "#B6FF6E")
        let g200 = UIColor(hex: "#CBFF98")
        let g100 = UIColor(hex: "#E0FFC2")
        let g50  = UIColor(hex: "#F5FFEC")

        let t900 = UIColor(hex: "#3A4761")
        let t800 = UIColor(hex: "#515E7A")
        let t700 = UIColor(hex: "#6A7794")
        let t600 = UIColor(hex: "#8391AE")
        let t500 = UIColor(hex: "#9EABCA")
        let t400 = UIColor(hex: "#B9C7E6")
        let t300 = UIColor(hex: "#D7E2FF")
        let t200 = UIColor(hex: "#ECF0FF")
        let t100 = UIColor(hex: "#F9F9FF")
        let t50  = UIColor(hex: "#FDFBFF")

        let white = UIColor.white
        let primary = UIColor(hex: "#003235")
        let onPrimary = n0
        let secondary = UIColor(hex: "#4A6365")
        let onSecondary = n0
        let tertiary = UIColor(hex: "#4F5E7D")
        let error = UIColor(hex: "#BA1A1A")
        let onError = UIColor(hex: "#FFFFFF")
        let primaryContainer = UIColor(hex: "#005257")
        let secondaryContainer = UIColor(hex: "#CCE8EA")
        let onSecondaryContainer = UIColor(hex: "#324B4D")
        let teritaryContainer = UIColor(hex: "#D7E2FF")
        let onTeritaryContainer = UIColor(hex: "#384764")
        let errorContainer = UIColor(hex: "#FFDAD6")
        let onErrorContainer = UIColor(hex: "#93000A")
        let surfaceDim = UIColor(hex: "#D5DBDB")
        let surface = UIColor(hex: "#F4FAFB")
        let surfaceBright = UIColor(hex: "#F4FAFB")
        let inverseSurface = UIColor(hex: "#2B3232")
        let surfContainerLowest = n0
        let surfContainerLow = UIColor(hex: "#EFF5F5")
        let surfContainer = UIColor(hex: "#E9EFEF")
        let surfContainerHigh = UIColor(hex: "#E3E9EA")
        let surfContainerHighest = UIColor(hex: "#DEE4E4")
        let inverseOnSurface = UIColor(hex: "#ECF2F2")
        let inversePrimary = UIColor(hex: "#80D4DC")
        let onSurface = UIColor(hex: "#161D1D")
        let onSurfaceVar = UIColor(hex: "#3F4849")
        let outline = UIColor(hex: "#6F797A")
        let outlineVariant = UIColor(hex: "#BEC8C9")
        let scrim = n0
        let shadow = n0

        let colors = Colors(n900: n900,
                            n800: n800,
                            n700: n700,
                            n600: n600,
                            n500: n500,
                            n400: n400,
                            n300: n300,
                            n200: n200,
                            n100: n100,
                            n50: n50,
                            n0: n0,
                            nv900: nv900,
                            nv800: nv800,
                            nv700: nv700,
                            nv600: nv600,
                            nv500: nv500,
                            nv400: nv400,
                            nv300: nv300,
                            nv200: nv200,
                            nv100: nv100,
                            nv50: nv50,
                            p900: p900,
                            p800: p800,
                            p700: p700,
                            p600: p600,
                            p500: p500,
                            p450: p450,
                            p400: p400,
                            p300: p300,
                            p200: p200,
                            p100: p100,
                            p50: p50,
                            s900: s900,
                            s800: s800,
                            s700: s700,
                            s600: s600,
                            s500: s500,
                            s400: s400,
                            s300: s300,
                            s200: s200,
                            s100: s100,
                            s50: s50,
                            y900: y900,
                            y800: y800,
                            y700: y700,
                            y600: y600,
                            y500: y500,
                            y400: y400,
                            y300: y300,
                            y200: y200,
                            y100: y100,
                            y50: y50,
                            g900: g900,
                            g800: g800,
                            g700: g700,
                            g600: g600,
                            g500: g500,
                            g400: g400,
                            g300: g300,
                            g200: g200,
                            g100: g100,
                            g50: g50,
                            t900: t900,
                            t800: t800,
                            t700: t700,
                            t600: t600,
                            t500: t500,
                            t400: t400,
                            t300: t300,
                            t200: t200,
                            t100: t100,
                            t50: t50,
                            white: white,
                            primary: primary,
                            onPrimary: onPrimary,
                            secondary: secondary,
                            onSecondary: onSecondary,
                            tertiary: tertiary,
                            error: error,
                            onError: onError,
                            primaryContainer: primaryContainer,
                            secondaryContainer: secondaryContainer,
                            onSecondaryContainer: onSecondaryContainer,
                            teritaryContainer: teritaryContainer,
                            onTeritaryContainer: onTeritaryContainer,
                            errorContainer: errorContainer,
                            onErrorContainer: onErrorContainer,
                            surfaceDim: surfaceDim,
                            surface: surface,
                            surfaceBright: surfaceBright,
                            inverseSurface: inverseSurface,
                            surfContainerLowest: surfContainerLowest,
                            surfContainerLow: surfContainerLow,
                            surfContainer: surfContainer,
                            surfContainerHigh: surfContainerHigh,
                            surfContainerHighest: surfContainerHighest,
                            inverseOnSurface: inverseOnSurface,
                            inversePrimary: inversePrimary,
                            onSurface: onSurface,
                            onSurfaceVar: onSurfaceVar,
                            outline: outline,
                            outlineVariant: outlineVariant,
                            scrim: scrim,
                            shadow: shadow)

        return AppTheme(colors: colors)
    }()
    
    
    public static let dark: AppTheme = {
        // Break colors into explicit constants to help the type-checker
        let n900 = UIColor(hex: "#444747")
        let n800 = UIColor(hex: "#5C5F5F")
        let n700 = UIColor(hex: "#757778")
        let n600 = UIColor(hex: "#8F9191")
        let n500 = UIColor(hex: "#A9ACAC")
        let n400 = UIColor(hex: "#C5C7C7")
        let n300 = UIColor(hex: "#E1E3E3")
        let n200 = UIColor(hex: "#EFF1F1")
        let n100 = UIColor(hex: "#F8FAF9")
        let n50  = UIColor(hex: "#FBFCFC")
        let n0   = UIColor(hex: "#FFFFFF")
        
        
        let nv900 = UIColor(hex: "#404849")
        let nv800 = UIColor(hex: "#576061")
        let nv700 = UIColor(hex: "#707979")
        let nv600 = UIColor(hex: "#8A9293")
        let nv500 = UIColor(hex: "#A4ADAE")
        let nv400 = UIColor(hex: "#BFC8C9")
        let nv300 = UIColor(hex: "#DBE4E5")
        let nv200 = UIColor(hex: "#EAF2F3")
        let nv100 = UIColor(hex: "#F2FBFC")
        let nv50  = UIColor(hex: "#F5FEFE")

        let p900 = UIColor(hex: "#004F54")
        let p800 = UIColor(hex: "#006970")
        let p700 = UIColor(hex: "#00848D")
        let p600 = UIColor(hex: "#10A0AA")
        let p500 = UIColor(hex: "#41BBC5")
        let p450 = UIColor(hex: "#87D1EA")
        let p400 = UIColor(hex: "#63D7E1")
        let p300 = UIColor(hex: "#81F4FE")
        let p200 = UIColor(hex: "#C7FAFF")
        let p100 = UIColor(hex: "#E9FDFF")
        let p50  = UIColor(hex: "#F4FEFF")

        let s900 = UIColor(hex: "#354A4D")
        let s800 = UIColor(hex: "#4C6264")
        let s700 = UIColor(hex: "#657B7D")
        let s600 = UIColor(hex: "#7E9597")
        let s500 = UIColor(hex: "#98AFB2")
        let s400 = UIColor(hex: "#B3CBCD")
        let s300 = UIColor(hex: "#CFE7E9")
        let s200 = UIColor(hex: "#DDF5F8")
        let s100 = UIColor(hex: "#E9FDFF")
        let s50  = UIColor(hex: "#F4FEFF")

        let y900 = UIColor(hex: "#5C3D00")
        let y800 = UIColor(hex: "#855800")
        let y700 = UIColor(hex: "#AD7400")
        let y600 = UIColor(hex: "#D68F00")
        let y500 = UIColor(hex: "#FFAD0A")
        let y400 = UIColor(hex: "#FFBC36")
        let y300 = UIColor(hex: "#FFCA62")
        let y200 = UIColor(hex: "#FFD98E")
        let y100 = UIColor(hex: "#FFE8BA")
        let y50  = UIColor(hex: "#FFF7E6")

        let g900 = UIColor(hex: "#2C5800")
        let g800 = UIColor(hex: "#407A05")
        let g700 = UIColor(hex: "#569C0F")
        let g600 = UIColor(hex: "#6EBE1D")
        let g500 = UIColor(hex: "#88E02F")
        let g400 = UIColor(hex: "#97FE30")
        let g300 = UIColor(hex: "#B6FF6E")
        let g200 = UIColor(hex: "#CBFF98")
        let g100 = UIColor(hex: "#E0FFC2")
        let g50  = UIColor(hex: "#F5FFEC")

        let t900 = UIColor(hex: "#3A4761")
        let t800 = UIColor(hex: "#515E7A")
        let t700 = UIColor(hex: "#6A7794")
        let t600 = UIColor(hex: "#8391AE")
        let t500 = UIColor(hex: "#9EABCA")
        let t400 = UIColor(hex: "#B9C7E6")
        let t300 = UIColor(hex: "#D7E2FF")
        let t200 = UIColor(hex: "#ECF0FF")
        let t100 = UIColor(hex: "#F9F9FF")
        let t50  = UIColor(hex: "#FDFBFF")

        let white = UIColor.white
        let primary = UIColor(hex: "#80D4DC")
        let onPrimary = UIColor(hex: "#00363A")
        
        let secondary = UIColor(hex: "#B1CBCE")
        let onSecondary = UIColor(hex: "#1B3437")
        
        let tertiary = UIColor(hex: "#B7C7EA")
        let error = UIColor(hex: "#FFB4AB")
        let onError = UIColor(hex: "#690005")
        
        let primaryContainer = UIColor(hex: "#004F54")
        let secondaryContainer = UIColor(hex: "#324B4D")
        let onSecondaryContainer = UIColor(hex: "#CCE8EA")
        
        let teritaryContainer = UIColor(hex: "#384764")
        let onTeritaryContainer = UIColor(hex: "#D7E2FF")
        
        let errorContainer = UIColor(hex: "#93000A")
        let onErrorContainer = UIColor(hex: "#FFDAD6")
        
        let surfaceDim = UIColor(hex: "#0E1415")
        let surface = UIColor(hex: "#0E1415")
        let surfaceBright = UIColor(hex: "#343A3B")
        let inverseSurface = UIColor(hex: "#DEE4E4")
        
        let surfContainerLowest = UIColor(hex: "#090F10")
        let surfContainerLow = UIColor(hex: "#161D1D")
        let surfContainer = UIColor(hex: "#1A2121")
        let surfContainerHigh = UIColor(hex: "#252B2C")
        let surfContainerHighest = UIColor(hex: "#303636")
        
        let inverseOnSurface = UIColor(hex: "#2B3232")
        let inversePrimary = UIColor(hex: "#006970")
        
        let onSurface = UIColor(hex: "#DEE4E4")
        let onSurfaceVar = UIColor(hex: "#BEC8C9")
        
        let outline = UIColor(hex: "#899393")
        let outlineVariant = UIColor(hex: "#3F4849")
        
        let scrim = UIColor(hex: "#000000")
        let shadow = UIColor(hex: "#000000")

        let colors = Colors(n900: n900,
                            n800: n800,
                            n700: n700,
                            n600: n600,
                            n500: n500,
                            n400: n400,
                            n300: n300,
                            n200: n200,
                            n100: n100,
                            n50: n50,
                            n0: n0,
                            nv900: nv900,
                            nv800: nv800,
                            nv700: nv700,
                            nv600: nv600,
                            nv500: nv500,
                            nv400: nv400,
                            nv300: nv300,
                            nv200: nv200,
                            nv100: nv100,
                            nv50: nv50,
                            p900: p900,
                            p800: p800,
                            p700: p700,
                            p600: p600,
                            p500: p500,
                            p450: p450,
                            p400: p400,
                            p300: p300,
                            p200: p200,
                            p100: p100,
                            p50: p50,
                            s900: s900,
                            s800: s800,
                            s700: s700,
                            s600: s600,
                            s500: s500,
                            s400: s400,
                            s300: s300,
                            s200: s200,
                            s100: s100,
                            s50: s50,
                            y900: y900,
                            y800: y800,
                            y700: y700,
                            y600: y600,
                            y500: y500,
                            y400: y400,
                            y300: y300,
                            y200: y200,
                            y100: y100,
                            y50: y50,
                            g900: g900,
                            g800: g800,
                            g700: g700,
                            g600: g600,
                            g500: g500,
                            g400: g400,
                            g300: g300,
                            g200: g200,
                            g100: g100,
                            g50: g50,
                            t900: t900,
                            t800: t800,
                            t700: t700,
                            t600: t600,
                            t500: t500,
                            t400: t400,
                            t300: t300,
                            t200: t200,
                            t100: t100,
                            t50: t50,
                            white: white,
                            primary: primary,
                            onPrimary: onPrimary,
                            secondary: secondary,
                            onSecondary: onSecondary,
                            tertiary: tertiary,
                            error: error,
                            onError: onError,
                            primaryContainer: primaryContainer,
                            secondaryContainer: secondaryContainer,
                            onSecondaryContainer: onSecondaryContainer,
                            teritaryContainer: teritaryContainer,
                            onTeritaryContainer: onTeritaryContainer,
                            errorContainer: errorContainer,
                            onErrorContainer: onErrorContainer,
                            surfaceDim: surfaceDim,
                            surface: surface,
                            surfaceBright: surfaceBright,
                            inverseSurface: inverseSurface,
                            surfContainerLowest: surfContainerLowest,
                            surfContainerLow: surfContainerLow,
                            surfContainer: surfContainer,
                            surfContainerHigh: surfContainerHigh,
                            surfContainerHighest: surfContainerHighest,
                            inverseOnSurface: inverseOnSurface,
                            inversePrimary: inversePrimary,
                            onSurface: onSurface,
                            onSurfaceVar: onSurfaceVar,
                            outline: outline,
                            outlineVariant: outlineVariant,
                            scrim: scrim,
                            shadow: shadow)

        return AppTheme(colors: colors)
    }()
    
    public static let darkMediumContrast: AppTheme = {
        // Break colors into explicit constants to help the type-checker
        let n900 = UIColor(hex: "#444747")
        let n800 = UIColor(hex: "#5C5F5F")
        let n700 = UIColor(hex: "#757778")
        let n600 = UIColor(hex: "#8F9191")
        let n500 = UIColor(hex: "#A9ACAC")
        let n400 = UIColor(hex: "#C5C7C7")
        let n300 = UIColor(hex: "#E1E3E3")
        let n200 = UIColor(hex: "#EFF1F1")
        let n100 = UIColor(hex: "#F8FAF9")
        let n50  = UIColor(hex: "#FBFCFC")
        let n0   = UIColor(hex: "#FFFFFF")
        
        
        let nv900 = UIColor(hex: "#404849")
        let nv800 = UIColor(hex: "#576061")
        let nv700 = UIColor(hex: "#707979")
        let nv600 = UIColor(hex: "#8A9293")
        let nv500 = UIColor(hex: "#A4ADAE")
        let nv400 = UIColor(hex: "#BFC8C9")
        let nv300 = UIColor(hex: "#DBE4E5")
        let nv200 = UIColor(hex: "#EAF2F3")
        let nv100 = UIColor(hex: "#F2FBFC")
        let nv50  = UIColor(hex: "#F5FEFE")

        let p900 = UIColor(hex: "#004F54")
        let p800 = UIColor(hex: "#006970")
        let p700 = UIColor(hex: "#00848D")
        let p600 = UIColor(hex: "#10A0AA")
        let p500 = UIColor(hex: "#41BBC5")
        let p450 = UIColor(hex: "#87D1EA")
        let p400 = UIColor(hex: "#63D7E1")
        let p300 = UIColor(hex: "#81F4FE")
        let p200 = UIColor(hex: "#C7FAFF")
        let p100 = UIColor(hex: "#E9FDFF")
        let p50  = UIColor(hex: "#F4FEFF")

        let s900 = UIColor(hex: "#354A4D")
        let s800 = UIColor(hex: "#4C6264")
        let s700 = UIColor(hex: "#657B7D")
        let s600 = UIColor(hex: "#7E9597")
        let s500 = UIColor(hex: "#98AFB2")
        let s400 = UIColor(hex: "#B3CBCD")
        let s300 = UIColor(hex: "#CFE7E9")
        let s200 = UIColor(hex: "#DDF5F8")
        let s100 = UIColor(hex: "#E9FDFF")
        let s50  = UIColor(hex: "#F4FEFF")

        let y900 = UIColor(hex: "#5C3D00")
        let y800 = UIColor(hex: "#855800")
        let y700 = UIColor(hex: "#AD7400")
        let y600 = UIColor(hex: "#D68F00")
        let y500 = UIColor(hex: "#FFAD0A")
        let y400 = UIColor(hex: "#FFBC36")
        let y300 = UIColor(hex: "#FFCA62")
        let y200 = UIColor(hex: "#FFD98E")
        let y100 = UIColor(hex: "#FFE8BA")
        let y50  = UIColor(hex: "#FFF7E6")

        let g900 = UIColor(hex: "#2C5800")
        let g800 = UIColor(hex: "#407A05")
        let g700 = UIColor(hex: "#569C0F")
        let g600 = UIColor(hex: "#6EBE1D")
        let g500 = UIColor(hex: "#88E02F")
        let g400 = UIColor(hex: "#97FE30")
        let g300 = UIColor(hex: "#B6FF6E")
        let g200 = UIColor(hex: "#CBFF98")
        let g100 = UIColor(hex: "#E0FFC2")
        let g50  = UIColor(hex: "#F5FFEC")

        let t900 = UIColor(hex: "#3A4761")
        let t800 = UIColor(hex: "#515E7A")
        let t700 = UIColor(hex: "#6A7794")
        let t600 = UIColor(hex: "#8391AE")
        let t500 = UIColor(hex: "#9EABCA")
        let t400 = UIColor(hex: "#B9C7E6")
        let t300 = UIColor(hex: "#D7E2FF")
        let t200 = UIColor(hex: "#ECF0FF")
        let t100 = UIColor(hex: "#F9F9FF")
        let t50  = UIColor(hex: "#FDFBFF")

        let white = UIColor.white
        let primary = UIColor(hex: "#96EAF2")
        let onPrimary = UIColor(hex: "#002B2E")
        
        let secondary = UIColor(hex: "#C6E1E4")
        let onSecondary = UIColor(hex: "#10292C")
        
        let tertiary = UIColor(hex: "#CEDCFF")
        let error = UIColor(hex: "#FFD2CC")
        
        let onError = UIColor(hex: "#540003")
        let primaryContainer = UIColor(hex: "#479DA5")
        let secondaryContainer = UIColor(hex: "#7C9598")
        let onSecondaryContainer = UIColor(hex: "#000000")
        
        let teritaryContainer = UIColor(hex: "#8291B2")
        let onTeritaryContainer = UIColor(hex: "#000000")
        
        let errorContainer = UIColor(hex: "#FF5449")
        let onErrorContainer = UIColor(hex: "#000000")
        
        let surfaceDim = UIColor(hex: "#0E1415")
        let surface = UIColor(hex: "#0E1415")
        let surfaceBright = UIColor(hex: "#3F4646")
        let inverseSurface = UIColor(hex: "#DEE4E4")
        
        let surfContainerLowest = UIColor(hex: "#040809")
        let surfContainerLow = UIColor(hex: "#181F1F")
        let surfContainer = UIColor(hex: "#23292A")
        let surfContainerHigh = UIColor(hex: "#2D3434")
        let surfContainerHighest = UIColor(hex: "#383F3F")
        
        let inverseOnSurface = UIColor(hex: "#252B2C")
        let inversePrimary = UIColor(hex: "#005056")
        
        let onSurface = UIColor(hex: "#FFFFFF")
        let onSurfaceVar = UIColor(hex: "#D4DEDF")
        
        let outline = UIColor(hex: "#AAB4B5")
        let outlineVariant = UIColor(hex: "#889293")
        
        let scrim = UIColor(hex: "#000000")
        let shadow = UIColor(hex: "#000000")

        let colors = Colors(n900: n900,
                            n800: n800,
                            n700: n700,
                            n600: n600,
                            n500: n500,
                            n400: n400,
                            n300: n300,
                            n200: n200,
                            n100: n100,
                            n50: n50,
                            n0: n0,
                            nv900: nv900,
                            nv800: nv800,
                            nv700: nv700,
                            nv600: nv600,
                            nv500: nv500,
                            nv400: nv400,
                            nv300: nv300,
                            nv200: nv200,
                            nv100: nv100,
                            nv50: nv50,
                            p900: p900,
                            p800: p800,
                            p700: p700,
                            p600: p600,
                            p500: p500,
                            p450: p450,
                            p400: p400,
                            p300: p300,
                            p200: p200,
                            p100: p100,
                            p50: p50,
                            s900: s900,
                            s800: s800,
                            s700: s700,
                            s600: s600,
                            s500: s500,
                            s400: s400,
                            s300: s300,
                            s200: s200,
                            s100: s100,
                            s50: s50,
                            y900: y900,
                            y800: y800,
                            y700: y700,
                            y600: y600,
                            y500: y500,
                            y400: y400,
                            y300: y300,
                            y200: y200,
                            y100: y100,
                            y50: y50,
                            g900: g900,
                            g800: g800,
                            g700: g700,
                            g600: g600,
                            g500: g500,
                            g400: g400,
                            g300: g300,
                            g200: g200,
                            g100: g100,
                            g50: g50,
                            t900: t900,
                            t800: t800,
                            t700: t700,
                            t600: t600,
                            t500: t500,
                            t400: t400,
                            t300: t300,
                            t200: t200,
                            t100: t100,
                            t50: t50,
                            white: white,
                            primary: primary,
                            onPrimary: onPrimary,
                            secondary: secondary,
                            onSecondary: onSecondary,
                            tertiary: tertiary,
                            error: error,
                            onError: onError,
                            primaryContainer: primaryContainer,
                            secondaryContainer: secondaryContainer,
                            onSecondaryContainer: onSecondaryContainer,
                            teritaryContainer: teritaryContainer,
                            onTeritaryContainer: onTeritaryContainer,
                            errorContainer: errorContainer,
                            onErrorContainer: onErrorContainer,
                            surfaceDim: surfaceDim,
                            surface: surface,
                            surfaceBright: surfaceBright,
                            inverseSurface: inverseSurface,
                            surfContainerLowest: surfContainerLowest,
                            surfContainerLow: surfContainerLow,
                            surfContainer: surfContainer,
                            surfContainerHigh: surfContainerHigh,
                            surfContainerHighest: surfContainerHighest,
                            inverseOnSurface: inverseOnSurface,
                            inversePrimary: inversePrimary,
                            onSurface: onSurface,
                            onSurfaceVar: onSurfaceVar,
                            outline: outline,
                            outlineVariant: outlineVariant,
                            scrim: scrim,
                            shadow: shadow)

        return AppTheme(colors: colors)
    }()
    
    public static let darkHighContrast: AppTheme = {
        // Break colors into explicit constants to help the type-checker
        let n900 = UIColor(hex: "#444747")
        let n800 = UIColor(hex: "#5C5F5F")
        let n700 = UIColor(hex: "#757778")
        let n600 = UIColor(hex: "#8F9191")
        let n500 = UIColor(hex: "#A9ACAC")
        let n400 = UIColor(hex: "#C5C7C7")
        let n300 = UIColor(hex: "#E1E3E3")
        let n200 = UIColor(hex: "#EFF1F1")
        let n100 = UIColor(hex: "#F8FAF9")
        let n50  = UIColor(hex: "#FBFCFC")
        let n0   = UIColor(hex: "#FFFFFF")
        
        
        let nv900 = UIColor(hex: "#404849")
        let nv800 = UIColor(hex: "#576061")
        let nv700 = UIColor(hex: "#707979")
        let nv600 = UIColor(hex: "#8A9293")
        let nv500 = UIColor(hex: "#A4ADAE")
        let nv400 = UIColor(hex: "#BFC8C9")
        let nv300 = UIColor(hex: "#DBE4E5")
        let nv200 = UIColor(hex: "#EAF2F3")
        let nv100 = UIColor(hex: "#F2FBFC")
        let nv50  = UIColor(hex: "#F5FEFE")

        let p900 = UIColor(hex: "#004F54")
        let p800 = UIColor(hex: "#006970")
        let p700 = UIColor(hex: "#00848D")
        let p600 = UIColor(hex: "#10A0AA")
        let p500 = UIColor(hex: "#41BBC5")
        let p450 = UIColor(hex: "#87D1EA")
        let p400 = UIColor(hex: "#63D7E1")
        let p300 = UIColor(hex: "#81F4FE")
        let p200 = UIColor(hex: "#C7FAFF")
        let p100 = UIColor(hex: "#E9FDFF")
        let p50  = UIColor(hex: "#F4FEFF")

        let s900 = UIColor(hex: "#354A4D")
        let s800 = UIColor(hex: "#4C6264")
        let s700 = UIColor(hex: "#657B7D")
        let s600 = UIColor(hex: "#7E9597")
        let s500 = UIColor(hex: "#98AFB2")
        let s400 = UIColor(hex: "#B3CBCD")
        let s300 = UIColor(hex: "#CFE7E9")
        let s200 = UIColor(hex: "#DDF5F8")
        let s100 = UIColor(hex: "#E9FDFF")
        let s50  = UIColor(hex: "#F4FEFF")

        let y900 = UIColor(hex: "#5C3D00")
        let y800 = UIColor(hex: "#855800")
        let y700 = UIColor(hex: "#AD7400")
        let y600 = UIColor(hex: "#D68F00")
        let y500 = UIColor(hex: "#FFAD0A")
        let y400 = UIColor(hex: "#FFBC36")
        let y300 = UIColor(hex: "#FFCA62")
        let y200 = UIColor(hex: "#FFD98E")
        let y100 = UIColor(hex: "#FFE8BA")
        let y50  = UIColor(hex: "#FFF7E6")

        let g900 = UIColor(hex: "#2C5800")
        let g800 = UIColor(hex: "#407A05")
        let g700 = UIColor(hex: "#569C0F")
        let g600 = UIColor(hex: "#6EBE1D")
        let g500 = UIColor(hex: "#88E02F")
        let g400 = UIColor(hex: "#97FE30")
        let g300 = UIColor(hex: "#B6FF6E")
        let g200 = UIColor(hex: "#CBFF98")
        let g100 = UIColor(hex: "#E0FFC2")
        let g50  = UIColor(hex: "#F5FFEC")

        let t900 = UIColor(hex: "#3A4761")
        let t800 = UIColor(hex: "#515E7A")
        let t700 = UIColor(hex: "#6A7794")
        let t600 = UIColor(hex: "#8391AE")
        let t500 = UIColor(hex: "#9EABCA")
        let t400 = UIColor(hex: "#B9C7E6")
        let t300 = UIColor(hex: "#D7E2FF")
        let t200 = UIColor(hex: "#ECF0FF")
        let t100 = UIColor(hex: "#F9F9FF")
        let t50  = UIColor(hex: "#FDFBFF")

        let white = UIColor.white
        let primary = UIColor(hex: "#C3FAFF")
        let onPrimary = UIColor(hex: "#000000")
        
        let secondary = UIColor(hex: "#DAF5F8")
        let onSecondary = UIColor(hex: "#000000")
        
        let tertiary = UIColor(hex: "#EBF0FF")
        let error = UIColor(hex: "#FFECE9")
        
        
        let onError = UIColor(hex: "#000000")
        let primaryContainer = UIColor(hex: "#7CD0D8")
        let secondaryContainer = UIColor(hex: "#ADC8CA")
        let onSecondaryContainer = UIColor(hex: "#000E0F")
        
        let teritaryContainer = UIColor(hex: "#B3C3E6")
        let onTeritaryContainer = UIColor(hex: "#000B21")
        
        let errorContainer = UIColor(hex: "#FFAEA4")
        let onErrorContainer = UIColor(hex: "#220001")
        
        let surfaceDim = UIColor(hex: "#0E1415")
        let surface = UIColor(hex: "#0E1415")
        let surfaceBright = UIColor(hex: "#4B5152")
        let inverseSurface = UIColor(hex: "#DEE4E4")
        
        let surfContainerLowest = UIColor(hex: "#000000")
        let surfContainerLow = UIColor(hex: "#1A2121")
        let surfContainer = UIColor(hex: "#2B3232")
        let surfContainerHigh = UIColor(hex: "#363D3D")
        let surfContainerHighest = UIColor(hex: "#424848")
        
        let inverseOnSurface = UIColor(hex: "#000000")
        let inversePrimary = UIColor(hex: "#005056")
        
        let onSurface = UIColor(hex: "#FFFFFF")
        let onSurfaceVar = UIColor(hex: "#FFFFFF")
        
        let outline = UIColor(hex: "#E8F2F3")
        let outlineVariant = UIColor(hex: "#BAC4C5")
        
        let scrim = UIColor(hex: "#000000")
        let shadow = UIColor(hex: "#000000")

        let colors = Colors(n900: n900,
                            n800: n800,
                            n700: n700,
                            n600: n600,
                            n500: n500,
                            n400: n400,
                            n300: n300,
                            n200: n200,
                            n100: n100,
                            n50: n50,
                            n0: n0,
                            nv900: nv900,
                            nv800: nv800,
                            nv700: nv700,
                            nv600: nv600,
                            nv500: nv500,
                            nv400: nv400,
                            nv300: nv300,
                            nv200: nv200,
                            nv100: nv100,
                            nv50: nv50,
                            p900: p900,
                            p800: p800,
                            p700: p700,
                            p600: p600,
                            p500: p500,
                            p450: p450,
                            p400: p400,
                            p300: p300,
                            p200: p200,
                            p100: p100,
                            p50: p50,
                            s900: s900,
                            s800: s800,
                            s700: s700,
                            s600: s600,
                            s500: s500,
                            s400: s400,
                            s300: s300,
                            s200: s200,
                            s100: s100,
                            s50: s50,
                            y900: y900,
                            y800: y800,
                            y700: y700,
                            y600: y600,
                            y500: y500,
                            y400: y400,
                            y300: y300,
                            y200: y200,
                            y100: y100,
                            y50: y50,
                            g900: g900,
                            g800: g800,
                            g700: g700,
                            g600: g600,
                            g500: g500,
                            g400: g400,
                            g300: g300,
                            g200: g200,
                            g100: g100,
                            g50: g50,
                            t900: t900,
                            t800: t800,
                            t700: t700,
                            t600: t600,
                            t500: t500,
                            t400: t400,
                            t300: t300,
                            t200: t200,
                            t100: t100,
                            t50: t50,
                            white: white,
                            primary: primary,
                            onPrimary: onPrimary,
                            secondary: secondary,
                            onSecondary: onSecondary,
                            tertiary: tertiary,
                            error: error,
                            onError: onError,
                            primaryContainer: primaryContainer,
                            secondaryContainer: secondaryContainer,
                            onSecondaryContainer: onSecondaryContainer,
                            teritaryContainer: teritaryContainer,
                            onTeritaryContainer: onTeritaryContainer,
                            errorContainer: errorContainer,
                            onErrorContainer: onErrorContainer,
                            surfaceDim: surfaceDim,
                            surface: surface,
                            surfaceBright: surfaceBright,
                            inverseSurface: inverseSurface,
                            surfContainerLowest: surfContainerLowest,
                            surfContainerLow: surfContainerLow,
                            surfContainer: surfContainer,
                            surfContainerHigh: surfContainerHigh,
                            surfContainerHighest: surfContainerHighest,
                            inverseOnSurface: inverseOnSurface,
                            inversePrimary: inversePrimary,
                            onSurface: onSurface,
                            onSurfaceVar: onSurfaceVar,
                            outline: outline,
                            outlineVariant: outlineVariant,
                            scrim: scrim,
                            shadow: shadow)

        return AppTheme(colors: colors)
    }()
}

// MARK: - Current Theme
extension AppTheme {
    @MainActor public static var currentTheme: AppTheme = .light

    @MainActor
    public static func loadSavedTheme(theme: String) {
        switch theme {
        case "light":
            currentTheme = .light
        case "dark":
            currentTheme = .dark
        case "system":
            // No SwiftUI environment exists yet at app-launch time (e.g. inside
            // AdapfitV2App.init()), so resolve the system appearance via UIKit instead
            // of @Environment(\.colorScheme).
            currentTheme = UITraitCollection.current.userInterfaceStyle == .dark ? .dark : .light
        default:
            break // no saved preference yet, keep the default (.light)
        }
    }
}


