//
//  FIlledCard.swift
//  Adapfit
//
//  Created by PhamHai Dang on 12/1/26.
//

import SwiftUI

public struct ElevatedCard<Content:View>: View {
    let content:Content
    @Environment(\.appTheme) private var theme
    public init(isDisabled: Bool = false,
                @ViewBuilder content: () -> Content, action: @escaping () -> Void = {}) {
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
        .buttonStyle(ElevatedCapsuleCardStyle(
            foregroundColor: theme.colors.primaryColor,
            backgroundColor: theme.colors.surfContainerLowColor,
            cornerRadius: theme.radius.defaultRadius
        ))
        .disabled(isDisabled)
    }
}

#Preview {
    ElevatedCard{
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
        .padding()
}
private struct ElevatedCapsuleCardStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.appTheme) private var theme
    let foregroundColor: Color
    let backgroundColor: Color
    let cornerRadius: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .foregroundStyle(isEnabled ? foregroundColor : theme.colors.onSurfaceColor.opacity(0.38))
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(isEnabled ? backgroundColor : theme.colors.onSurfaceColor.opacity(0.12))
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(foregroundColor.opacity(configuration.isPressed ? 0.10 : 0.0))
                    )
            )
            .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
        
            .shadow(
                color: theme.colors.shadowColor.opacity(isEnabled ? (configuration.isPressed ? 0.10 : 0.18) : 0.0),
                radius: isEnabled ? (configuration.isPressed ? 2 : 6) : 0,
                x: 0,
                y: isEnabled ? (configuration.isPressed ? 1 : 3) : 0
            )
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
