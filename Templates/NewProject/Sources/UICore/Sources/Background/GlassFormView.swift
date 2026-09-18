//
//  GlassLoginForm.swift
//  AdapfitV2
//
//  Created by PhamHai Dang on 13/6/26.
//  Copyright © 2026 Bru. All rights reserved.
//


import SwiftUI
// MARK: - Glass Form Component
public struct GlassFormView<Content:View>: View {
    @Environment(\.appTheme) private var theme
    public let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content = {EmptyView()}) {
        self.content = content
    }
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content()
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 24)
        .applyGlass()
        
    }
}

// MARK: - Preview
struct GlassLoginForm_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            // Cắm background "Liquid Glass" ở câu trước vào để test form
            LiquidBackgroundView()
            
            GlassFormView {
                Text("Sample Content")
                    .foregroundColor(.white)
                    .padding()
            }
            .padding(.horizontal, 24)
        }
    }
}
public struct GlassModier: ViewModifier {
    
    @Environment(\.appTheme) private var theme
    let radius:Double
    public init(radius: Double) {
        self.radius = radius
    }
    public func body(content: Content) -> some View {
        content
        // CẤU TRÚC LỚP KÍNH (LIQUID GLASS CONTAINER)
        .background(
            // Lớp 1: Blur native của iOS (tương đương backdrop-filter)
            RoundedRectangle(cornerRadius: radius)
                .fill(.ultraThinMaterial)
        )
        .background(
            // Lớp 2: Lớp phủ màu trắng bán trong suốt (đặt ngay sau vật liệu blur)
            RoundedRectangle(cornerRadius: radius)
                .fill(Color.white.opacity(0.5))
        )
        .overlay(
            // Đường viền trắng mờ để làm sắc nét khối kính
            RoundedRectangle(cornerRadius: radius)
                .stroke(Color.white.opacity(0.8), lineWidth: 1)
        )
        .overlay(
            // Tạo hiệu ứng ánh sáng hắt từ trên xuống (tương đương inner shadow top: 1px)
            RoundedRectangle(cornerRadius: radius)
                .stroke(LinearGradient(
                    colors: [Color.white.opacity(0.95), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                ), lineWidth: 1)
        )
        // Hiệu ứng shadow toả đều tạo cảm giác nổi
        .shadow(color: theme.colors.primaryColor.opacity(0.1), radius: 16, x: 0, y: 8)
    }
}
extension View {
    func applyGlass(radius:Double = 28) -> some View {
        self.modifier(GlassModier(radius: radius))
    }
}
