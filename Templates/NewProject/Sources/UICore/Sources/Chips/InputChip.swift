//
//  InputChip.swift
//  Adapfit
//
//  Created by PhamHai Dang on 13/1/26.
//

import SwiftUI

public struct InputChip: View {
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
                    .padding(.trailing, rightImage == nil ? 16 : 0)
                if let rightImage {
                    rightImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 10, height: 10)
                    .padding(8)
                    .padding(.trailing, 8)
                }
            }
            .frame(height: 32)
        }
        .buttonStyle(InputChipStyle())
        .disabled(isDisabled)
        .accessibilityLabel(Text(label))
    }
}

#Preview {
    HStack{
        InputChip(leftImage: Image(systemName: "checkmark.circle.dotted"),
                   rightImage: Image(systemName: "xmark"),
                   label: "Filter chip")
        InputChip(label: "Filter chip", isDisabled: true)
    }
    .padding()
    .background(Color.surface)
    
}

private struct InputChipStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.appTheme) private var theme

    func makeBody(configuration: Configuration) -> some View {
        // Màu sắc nội dung (Text/Icon)
        let contentColor = isEnabled
            ? theme.colors.onSecondaryContainerColor
            : theme.colors.onSurfaceColor.opacity(0.38)
        
        return configuration.label
            .foregroundStyle(contentColor)
            .background(
                Capsule()
                    // Nền: 12% onSurface khi disabled
                    .fill(isEnabled ? theme.colors.secondaryContainerColor : theme.colors.onSurfaceColor.opacity(0.12))
                    .overlay(
                        Capsule()
                            // Lớp nhấn: 10% cùng màu nội dung
                            .fill(contentColor.opacity(configuration.isPressed ? 0.10 : 0.0))
                    )
            )
            .overlay(
                Capsule()
                    // Viền: Thường dùng outlineVariant hoặc clear nếu đã có nền Container
                    .stroke(isEnabled ? Color.clear : theme.colors.onSurfaceColor.opacity(0.12), lineWidth: 1)
            )
            .frame(minHeight: 48) // Giữ nguyên để đạt chuẩn Touch Target
            .contentShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
