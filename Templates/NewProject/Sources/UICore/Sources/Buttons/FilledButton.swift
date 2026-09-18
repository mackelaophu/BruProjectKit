//
//  FilledButton.swift
//  Adapfit
//
//  Created by PhamHai Dang on 12/1/26.
//

import SwiftUI
import Common

public struct FilledButton: View {
    @Environment(\.appTheme) private var theme
    var label: String
    var icon: String?
    var leftImage: Image?
    var rightImage: Image?
    var isDisabled: Bool = false
    var buttonStyle: FilledCapsuleStyle?
    /// `nil` = tự co theo nội dung (dùng cho tab/chip trong ScrollView ngang)
    var maxWidth: CGFloat?
    var action: () -> Void = {}
    public init(label: String, icon: String? = nil, leftImage: Image? = nil, rightImage: Image? = nil, isDisabled: Bool = false, buttonStyle: FilledCapsuleStyle? = nil, maxWidth: CGFloat? = .infinity, action: @escaping () -> Void = {}) {
        self.label = label
        self.icon = icon
        self.leftImage = leftImage
        self.rightImage = rightImage
        self.isDisabled = isDisabled
        self.action = action
        self.buttonStyle = buttonStyle
        self.maxWidth = maxWidth
    }
    private let horizontalPadding: CGFloat = 16
    private let verticalPadding: CGFloat = 10
    private let borderWidth: CGFloat = 1
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let leftImage {
                    leftImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                } else if let icon {
                    Image(systemName: icon)
                }
                Text(label)
                    .appStyle(.headlineSm)
                if let rightImage {
                    rightImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
            }
            .appStyle(.headlineSm)
            .lineLimit(1)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .frame(maxWidth: maxWidth)
            .frame(minHeight: 56, alignment: .center)
        }
        .buttonStyle(buttonStyle ?? FilledCapsuleStyle(
            foregroundColor: theme.colors.onPrimaryColor,
            backgroundColor: theme.colors.primaryColor,
            disabledForegroundColor: theme.colors.onSurfaceColor.opacity(0.38),
            borderWidth: borderWidth
        ))
        .disabled(isDisabled)
        .accessibilityLabel(Text(label))
    }
}

#Preview {
    HStack{
        FilledButton(label: "Filled Button")
//            .tint(Color.primary)
        FilledButton(label: "Filled Button", isDisabled: true)
//            .tint(Color.primary)
    }
    .padding()
    .background(Color.surface)
}

public struct FilledCapsuleStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.appTheme) private var theme
    let foregroundColor: Color
    let backgroundColor: Color
    let disabledForegroundColor: Color
    let borderWidth: CGFloat
    public init(
        foregroundColor: Color, backgroundColor: Color, disabledForegroundColor: Color, borderWidth: CGFloat) {
            self.foregroundColor = foregroundColor
            self.backgroundColor = backgroundColor
            self.disabledForegroundColor = disabledForegroundColor
            self.borderWidth = borderWidth
        }
    public func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .foregroundStyle(isEnabled ? foregroundColor : disabledForegroundColor)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(isEnabled ? backgroundColor : theme.colors.onSurfaceColor.opacity(0.12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(foregroundColor.opacity(configuration.isPressed ? 0.10 : 0.0))
                    )
            )
            .contentShape(RoundedRectangle(cornerRadius: 18))
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
