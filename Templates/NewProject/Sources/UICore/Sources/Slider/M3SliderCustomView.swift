//
//  M3SliderCustomView.swift
//  UICore
//
//  Created by PhamHai Dang on 11/8/26.
//  Copyright © 2026 Bru. All rights reserved.
//

import SwiftUI

public struct M3SliderCustomView: View {
    @Binding var value: CGFloat
    var trackBarHeight: CGFloat? = 10
    var trackBorderRadius: CGFloat? = 5
    var thumbSize: CGFloat? = 28
    var valueRange: ClosedRange<CGFloat> = 0.0...1.0
    var notedValueRange: ClosedRange<CGFloat>? = nil
    var notedLabel: String? = nil
    var isShowLabel: Bool = false
    @State private var thumbOffset: CGFloat = 0
    @Environment(\.appTheme) private var theme
    
    public init(value: Binding<CGFloat>, trackBarHeight: CGFloat? = 10, trackBorderRadius: CGFloat? = 5, thumbSize: CGFloat? = 28, valueRange: ClosedRange<CGFloat>, notedValueRange: ClosedRange<CGFloat>? = nil, notedLabel: String? = nil, isShowLabel: Bool = false) {
        self._value = value
        self.trackBarHeight = trackBarHeight
        self.trackBorderRadius = trackBorderRadius
        self.thumbSize = thumbSize
        self.valueRange = valueRange
        self.notedValueRange = notedValueRange
        self.notedLabel = notedLabel
        self.isShowLabel = isShowLabel
    }
    @State private var trackWidth: CGFloat = 0
    
    private func offset(for value: CGFloat, trackWidth: CGFloat) -> CGFloat {
        let totalValueRange = valueRange.upperBound - valueRange.lowerBound
        guard totalValueRange > 0, trackWidth > 0 else { return 0 }
        let fraction = (value - valueRange.lowerBound) / totalValueRange
        return min(max(fraction, 0), 1) * trackWidth
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .leading) {
                ZStack(alignment: .leading) {
                    if let notedValueRange {
                        let lowerNotedBound = notedValueRange.lowerBound
                        let upperNotedBound = notedValueRange.upperBound
                        
                        let totalValueRange = valueRange.upperBound - valueRange.lowerBound
                        
                        let notedWidth = ((upperNotedBound - lowerNotedBound) / totalValueRange) * trackWidth
                        
                        let notedRangeOffset = ((lowerNotedBound - valueRange.lowerBound) / totalValueRange) * trackWidth
                        
                        RoundedRectangle(cornerRadius: trackBorderRadius ?? 5)
                            .fill(theme.colors.primaryColor.opacity(0.22))
                            .frame(width: notedWidth, height: trackBarHeight)
                            .offset(x: notedRangeOffset)
                    }
                    Rectangle()
                        .fill(theme.colors.primaryColor)
                        .frame(width: thumbOffset)
                        .frame(height: trackBarHeight)
                        .clipShape(RoundedRectangle(cornerRadius: trackBorderRadius ?? 5))
                }.frame(width: trackWidth, alignment: .leading)
                    .frame(height: trackBarHeight)
                    .background(theme.colors.surfContainerHighestColor)
                    .clipShape(RoundedRectangle(cornerRadius: trackBorderRadius ?? 5))
                // Track phải dịch vào 1 nửa thumb để trùng với đường đi tâm thumb
                Circle()
                    .fill(theme.colors.surfContainerLowestColor)
                    .frame(width: thumbSize,  height: thumbSize)
                    .overlay(Circle().stroke(theme.colors.primaryColor, lineWidth: 5))
                    .offset(x: thumbOffset - 14)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gestureValue in
                                // Tính toán vị trí mới
                                let newOffset = gestureValue.location.x - ((thumbSize ?? 28) / 2)
                                // Giới hạn thumb không vượt quá 2 đầu của track
                                thumbOffset = min(max(newOffset, 0), trackWidth)
                                
                                // Cập nhật lại giá trị binding theo đúng tỉ lệ của valueRange
                                let totalValueRange = valueRange.upperBound - valueRange.lowerBound
                                let fraction = trackWidth > 0 ? thumbOffset / trackWidth : 0
                                value = valueRange.lowerBound + fraction * totalValueRange
                            }
                    )
            }
            .frame(maxWidth: .infinity)
            .frame(height: thumbSize)
            if isShowLabel {
                let thumbRadius = (thumbSize ?? 28) / 2
                let totalValueRange = valueRange.upperBound - valueRange.lowerBound
                
                ZStack(alignment: .leading) {
                    Text("\(Int(valueRange.lowerBound.rounded()))")
                        .appStyle(.labelLg)
                        .foregroundStyle(theme.colors.outlineColor)
                        .fixedSize()
                    
                    if let notedValueRange, let notedLabel {
                        let notedRangeOffset = ((notedValueRange.lowerBound - valueRange.lowerBound) / totalValueRange) * trackWidth
                        let notedWidth = ((notedValueRange.upperBound - notedValueRange.lowerBound) / totalValueRange) * trackWidth
                        
                        Text(notedLabel)
                            .appStyle(.labelLg)
                            .foregroundStyle(theme.colors.primaryColor)
                            .fixedSize()
                        // căn giữa theo vùng noted range
                            .offset(x: notedRangeOffset + thumbRadius / 2)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Text("\(Int(valueRange.upperBound.rounded()))")
                        .appStyle(.labelLg)
                        .foregroundStyle(theme.colors.outlineColor)
                        .fixedSize()
                        .offset(x: trackWidth - thumbRadius)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 8)
            }
        }
        .background(
            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        trackWidth = geometry.size.width
                        thumbOffset = offset(for: value, trackWidth: trackWidth)
                    }
                    .onChange(of: geometry.size.width) { _, newWidth in
                        trackWidth = newWidth
                        thumbOffset = offset(for: value, trackWidth: trackWidth)
                    }
            }
        )
        .onChange(of: value) { _, newValue in
            let expectedOffset = offset(for: newValue, trackWidth: trackWidth)
            if abs(thumbOffset - expectedOffset) > 0.5 {
                thumbOffset = expectedOffset
            }
        }
    }
}
#Preview {
    
    @Previewable @State var value: CGFloat = 0
    M3SliderCustomView(value: $value, valueRange: 0...30, notedValueRange: 10...20, notedLabel: "Optimal 10-20", isShowLabel: true)
        .padding(.horizontal, 24)
}
