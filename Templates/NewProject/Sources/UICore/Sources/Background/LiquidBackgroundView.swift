//
//  AdapfitLoginScreen.swift
//  AdapfitV2
//
//  Created by PhamHai Dang on 14/6/26.
//  Copyright © 2026 Bru. All rights reserved.
//

import SwiftUI
import Common

// MARK: - Adapfit Login Screen
public struct LiquidBackgroundView: View {
    @Environment(\.appTheme) private var theme

    public init() {}

    public var body: some View {
        ZStack {
            // 1. Background Gradient
            LinearGradient(
                stops: [
                    Gradient.Stop(color: theme.colors.s200Color, location: 0.0),
                    Gradient.Stop(color: theme.colors.s300Color, location: 0.35),
                    Gradient.Stop(color: theme.colors.s400Color, location: 0.70),
                    Gradient.Stop(color: theme.colors.secondaryContainerColor, location: 1.0)
                ],
                startPoint: UnitPoint(x: 0.3, y: 0.0),
                endPoint: UnitPoint(x: 0.7, y: 1.0)
            )
            .ignoresSafeArea()
            
            // 2. Ambient Blobs (Hiệu ứng ánh sáng)
            GeometryReader { geo in
                // Blob trên cùng bên phải
                Circle()
                    .fill(RadialGradient(colors: [theme.colors.p800Color.opacity(0.22), .clear], center: .center, startRadius: 0, endRadius: 140))
                    .frame(width: 280, height: 280)
                    .position(x: geo.size.width + 20, y: -40)
                
                // Blob dưới cùng bên trái
                Circle()
                    .fill(RadialGradient(colors: [theme.colors.p800Color.opacity(0.15), .clear], center: .center, startRadius: 0, endRadius: 130))
                    .frame(width: 260, height: 260)
                    .position(x: -40, y: geo.size.height - 40)
                
                // Blob sáng ở giữa bên phải
                Circle()
                    .fill(RadialGradient(colors: [theme.colors.whiteColor.opacity(0.5), .clear], center: .center, startRadius: 0, endRadius: 80))
                    .frame(width: 160, height: 160)
                    .position(x: geo.size.width * 0.9, y: geo.size.height * 0.38)
            }
            .allowsHitTesting(false) // pointer-events: none
            
        }
        .accessibilityIdentifier("Login")
    }
}
#Preview {
    LiquidBackgroundView()
}
