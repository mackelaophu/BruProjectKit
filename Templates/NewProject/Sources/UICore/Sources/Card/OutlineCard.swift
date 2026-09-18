//
//  FIlledCard.swift
//  Adapfit
//
//  Created by PhamHai Dang on 12/1/26.
//

import SwiftUI

public struct OutlineCard<Content:View>: View {
    let content:Content
    @Environment(\.appTheme) private var theme
    public init(isDisabled: Bool = false,
         @ViewBuilder content: () -> Content,
                action: @escaping () -> Void = {}) {
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
        .buttonStyle(OutlinedCapsuleCardStyle(
            borderColor: theme.colors.outlineColor,
            disabledBorderColor: theme.colors.outlineVariantColor,
            foregroundColor: theme.colors.primaryColor,
            disabledForegroundColor: theme.colors.onSurfaceVarColor.opacity(0.38),
            borderWidth: borderWidth,
            cornerRadius: theme.radius.defaultRadius
        ))
        .disabled(isDisabled)
    }
}

#Preview {
    OutlineCard{
        VStack {
            Text("Hello World")
                .appStyle(.titleLg)
                .foregroundStyle(Color.primary)
            VStack{
                FilledButton(label: "Filled Button")
                TonalButton(label: "Tonal Button")
                
            }
            .padding()
        }
    }
}
private struct OutlinedCapsuleCardStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.appTheme) private var theme
    let borderColor: Color
    let disabledBorderColor: Color
    let foregroundColor: Color
    let disabledForegroundColor: Color
    let borderWidth: CGFloat
    let cornerRadius: CGFloat
    func makeBody(configuration: Configuration) -> some View {
        
        return configuration.label
            .foregroundStyle(isEnabled ? foregroundColor : theme.colors.onSurfaceColor.opacity(0.38))
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(foregroundColor.opacity(0.0))
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(isEnabled ? borderColor : theme.colors.outlineColor.opacity(0.12), lineWidth: borderWidth)
            )
            .contentShape(
                RoundedRectangle(cornerRadius: cornerRadius))
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
