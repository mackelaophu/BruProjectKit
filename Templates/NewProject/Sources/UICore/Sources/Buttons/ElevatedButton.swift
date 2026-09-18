//
//  ElevatedButton.swift
//  Adapfit
//
//  Created by PhamHai Dang on 12/1/26.
//

import SwiftUI
import Common

public struct ElevatedButton: View {
    @Environment(\.appTheme) private var theme
    var label: String
    var leftImage: Image?
    var rightImage: Image?
    var isDisabled: Bool = false
    var action: () -> Void = {}
    
    private let horizontalPadding: CGFloat = 16
    private let verticalPadding: CGFloat = 10
    private let borderWidth: CGFloat = 1
    
    public init(label: String, leftImage: Image? = nil, rightImage: Image? = nil, isDisabled: Bool = false, action: @escaping () -> Void = {}) {
        self.label = label
        self.leftImage = leftImage
        self.rightImage = rightImage
        self.isDisabled = isDisabled
        self.action = action
    }
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let leftImage {
                    leftImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
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
                .frame(maxWidth: .infinity, minHeight: 56, alignment: .center)
        }
        .buttonStyle(ElevatedCapsuleStyle(
            foregroundColor: theme.colors.primaryColor,
            backgroundColor: theme.colors.surfContainerLowColor,
            disabledForegroundColor: theme.colors.onSurfaceVarColor.opacity(0.38),
            borderWidth: borderWidth
        ))
        .disabled(isDisabled)
        .accessibilityLabel(Text(label))
    }
}


#Preview {
    HStack{
        ElevatedButton(label: "Elevated button")
//            .tint(Color.primary)
        ElevatedButton(label: "Elevated button", isDisabled: true)
//            .tint(Color.primary)
    }
    .padding()
    .background(Color.surface)
}

private struct ElevatedCapsuleStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.appTheme) private var theme
    let foregroundColor: Color
    let backgroundColor: Color
    let disabledForegroundColor: Color
    let borderWidth: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .foregroundStyle(isEnabled ? foregroundColor : theme.colors.onSurfaceColor.opacity(0.38))
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(isEnabled ? backgroundColor : theme.colors.onSurfaceColor.opacity(0.12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(foregroundColor.opacity(configuration.isPressed ? 0.10 : 0.0))
                    )
            )
            .contentShape(RoundedRectangle(cornerRadius: 18))
            .shadow(
                color: theme.colors.shadowColor.opacity(isEnabled ? (configuration.isPressed ? 0.10 : 0.18) : 0.0),
                radius: isEnabled ? (configuration.isPressed ? 2 : 6) : 0,
                x: 0,
                y: isEnabled ? (configuration.isPressed ? 1 : 3) : 0
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
