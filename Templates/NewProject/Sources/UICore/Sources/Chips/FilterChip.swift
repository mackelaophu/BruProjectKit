//
//  FilterChip.swift
//  Adapfit
//
//  Created by PhamHai Dang on 13/1/26.
//

import SwiftUI

public struct FilterChip: View {
    @Environment(\.appTheme) private var theme
    var label: String
    var isDisabled: Bool = false
    var action: () -> Void = {}
    
    private let horizontalPadding: CGFloat = 8
    private let verticalPadding: CGFloat = 10
    private let borderWidth: CGFloat = 1
    @State var isSelected: Bool = false
    var leftImage: Image?
    var rightImage: Image?
    public init(leftImage: Image? = nil,
         rightImage: Image? = nil,
         label: String,
         isDisabled: Bool = false ,
         action: @escaping () -> Void = {}) {
        self.label = label
        self.isDisabled = isDisabled
        self.action = action
        self.leftImage = leftImage
        self.rightImage = rightImage
    }
    public var body: some View {
        Button(action: {
            isSelected.toggle()
            action()
        }) {
            HStack(spacing: 0){
                if let leftImage {
                    leftImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 18, height: 18)
                    .padding(.leading, 8)
                }
                    
                Text(label)
                    .appStyle(.headlineSm)
                    .lineLimit(1)
                    .padding(.vertical, verticalPadding)
                    .padding(.leading, leftImage == nil ? 16 : 8)
                    .padding(.trailing, rightImage == nil ? 16 : 8)
                if let rightImage {
                    rightImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 18, height: 18)
                    .padding(.trailing, 8)
                }
            }
            .frame(height: 32)
        }
        .buttonStyle(FilterChipStyle(isSelected: isSelected))
        .disabled(isDisabled)
        .accessibilityLabel(Text(label))
    }
}

#Preview {
    HStack{
        FilterChip(leftImage: Image(systemName: "checkmark.circle.dotted"),
                   rightImage: Image(systemName: "checkmark.circle.dotted"),
                   label: "Filter chip")
        FilterChip(label: "Filter chip", isDisabled: true)
    }
    .padding()
    .background(Color.surface)
    
}

private struct FilterChipStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.appTheme) private var theme
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        let contentColor = isEnabled
            ? (isSelected ? theme.colors.onSecondaryContainerColor : theme.colors.onSurfaceColor)
            : theme.colors.onSurfaceColor.opacity(0.38)
        
        return configuration.label
            .foregroundStyle(contentColor)
            .background(
                Capsule() // Chuyển sang Pill-shape cho đúng chuẩn Chip
                    .fill(isSelected && isEnabled ? theme.colors.secondaryContainerColor : !isEnabled ? theme.colors.onSurfaceColor.opacity(0.12) : Color.clear)
                    .overlay(
                        Capsule()
                            .fill(contentColor.opacity(configuration.isPressed ? 0.10 : 0.0))
                    )
            )
            // Thêm viền cho chip khi chưa chọn (tùy chọn theo chuẩn M3)
            .overlay(
                Capsule()
                    .stroke(isSelected || !isEnabled ? Color.clear : theme.colors.outlineColor, lineWidth: 1)
            )
            .frame(minHeight: 48) // Đảm bảo vùng chạm tối thiểu 48dp
            .contentShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
