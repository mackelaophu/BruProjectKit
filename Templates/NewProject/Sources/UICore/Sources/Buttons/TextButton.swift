//
//  TextButton.swift
//  UICore
//
//  Created by PhamHai Dang on 9/8/26.
//  Copyright © 2026 Bru. All rights reserved.
//

import SwiftUI
import Common

public struct TextButton: View {
    @Environment(\.appTheme) private var theme
    var label: String
    var isDisabled: Bool = false
    var buttonStyle: TextCapsuleStyle?
    /// `nil` = tự co theo nội dung (dùng cho tab/chip trong ScrollView ngang)
    var action: () -> Void = {}
    public init(label: String, isDisabled: Bool = false, buttonStyle: TextCapsuleStyle? = nil, action: @escaping () -> Void = {}) {
        self.label = label
        self.isDisabled = isDisabled
        self.action = action
        self.buttonStyle = buttonStyle
    }
    private let horizontalPadding: CGFloat = 16
    private let verticalPadding: CGFloat = 10
    private let borderWidth: CGFloat = 1
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(label)
                    .appStyle(.bodyLg)
            }
            .appStyle(.headlineSm)
            .lineLimit(1)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .frame(minHeight: 56, alignment: .center)
        }
        .buttonStyle(buttonStyle ?? TextCapsuleStyle(
            foregroundColor: theme.colors.primaryColor,
            disabledForegroundColor: theme.colors.outlineColor
        ))
        .disabled(isDisabled)
        .accessibilityLabel(Text(label))
    }
}

#Preview {
    HStack{
        TextButton(label: "Filled Button")
//            .tint(Color.primary)
        TextButton(label: "Filled Button", isDisabled: true)
//            .tint(Color.primary)
    }
    .padding()
    .background(Color.surface)
}

public struct TextCapsuleStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.appTheme) private var theme
    let foregroundColor: Color
    let disabledForegroundColor: Color
    public init(
        foregroundColor: Color, disabledForegroundColor: Color) {
            self.foregroundColor = foregroundColor
            self.disabledForegroundColor = disabledForegroundColor
        }
    public func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .foregroundStyle(isEnabled ? foregroundColor : disabledForegroundColor)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
