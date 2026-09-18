//
//  FIlledCard.swift
//  Adapfit
//
//  Created by PhamHai Dang on 12/1/26.
//

import SwiftUI

public struct FilledCard<Content:View>: View {
    let content:Content
    @Environment(\.appTheme) private var theme
    private var buttonStyle: FilledCapsuleCardStyle?
    public init(isDisabled: Bool = false,
                buttonStyle: FilledCapsuleCardStyle? = nil,
         @ViewBuilder content: () -> Content,
         action: @escaping () -> Void = {}) {
        self.buttonStyle = buttonStyle
        self.content = content()
        self.isDisabled = isDisabled
        self.action = action
    }
    private let horizontalPadding: CGFloat = 16
    private let verticalPadding: CGFloat = 10
    private let borderWidth: CGFloat = 1
    var isDisabled: Bool = false
    var action: () -> Void = {}
    public var body: some View {
        Button(action: action) {
            content
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .buttonStyle(buttonStyle ?? FilledCapsuleCardStyle(
            foregroundColor: theme.colors.primaryColor,
            backgroundColor: theme.colors.surfContainerHighestColor,
            disabledForegroundColor: theme.colors.onSurfaceColor.opacity(0.38),
            cornerRadius: theme.radius.defaultRadius
        ))
        .disabled(isDisabled)
    }
}

#Preview {
    FilledCard{
        VStack {
            Text("Hello World")
                .appStyle(.headlineMd)
                .foregroundStyle(Color.primary)
            VStack{
                FilledButton(label: "Filled Button")
                TonalButton(label: "Tonal Button")
                
            }
            .padding()
        }
    }
}
public struct FilledCapsuleCardStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.appTheme) private var theme
    let foregroundColor: Color
    let backgroundColor: Color
    let disabledForegroundColor: Color
    let cornerRadius: CGFloat
    public init(foregroundColor: Color,
                backgroundColor: Color, disabledForegroundColor: Color, cornerRadius: CGFloat) {
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.disabledForegroundColor = disabledForegroundColor
        self.cornerRadius = cornerRadius
    }
    public func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .foregroundStyle(isEnabled ? foregroundColor : disabledForegroundColor)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(isEnabled ? backgroundColor : theme.colors.onSurfaceColor.opacity(0.12))
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(foregroundColor.opacity(configuration.isPressed ? 0.10 : 0.0))
                    )
            )
            .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
//            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
