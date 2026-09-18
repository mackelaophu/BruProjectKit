//
//  FlowLayout.swift
//  AdapfitV2
//
//  Created by PhamHai Dang on 7/8/26.
//  Copyright © 2026 Bru. All rights reserved.
//


import SwiftUI

// Sử dụng custom layout từ iOS 16
public struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    public init(spacing: CGFloat) {
        self.spacing = spacing
    }
    
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, subviews: subviews, spacing: spacing)
        return result.bounds
    }
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            let point = result.points[index]
            subview.place(at: CGPoint(x: point.x + bounds.minX, y: point.y + bounds.minY), proposal: .unspecified)
        }
    }
    
    // Logic tính toán tọa độ (Rút gọn để tham khảo)
    public struct FlowResult {
        var bounds: CGSize = .zero
        var points: [CGPoint] = []
        
        public init(in maxWidth: CGFloat, subviews: Layout.Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                points.append(CGPoint(x: currentX, y: currentY))
                lineHeight = max(lineHeight, size.height)
                currentX += size.width + spacing
            }
            bounds = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}

// Cách sử dụng
struct TagView: View {
    let tags = ["SwiftUI", "iOS", "UICollectionView", "Apple", "Lập trình di động", "Flow Layout"]
    
    var body: some View {
        FlowLayout(spacing: 10) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(20)
            }
        }
        .padding()
    }
}
