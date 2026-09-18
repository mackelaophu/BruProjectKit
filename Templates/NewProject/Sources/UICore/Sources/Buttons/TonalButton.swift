//
//  TonalButton.swift
//  Adapfit
//
//  Created by PhamHai Dang on 12/1/26.
//

import SwiftUI
import Common

public struct TonalButton: View {
    @Environment(\.appTheme) private var theme
    var label: String
    var leftImage: Image?
    var rightImage: Image?
    var isDisabled: Bool = false
    var minHeight: CGFloat?
    var iconWidth: CGFloat?
    var iconHeight: CGFloat?
    var action: () -> Void = {}
    
    private let horizontalPadding: CGFloat = 16
    private let verticalPadding: CGFloat = 10
    private let borderWidth: CGFloat = 1
    
    public init(label: String, leftImage: Image? = nil, rightImage: Image? = nil, isDisabled: Bool = false, minHeight: CGFloat? = 56, iconWidth: CGFloat? = 24, iconHeight: CGFloat? = 24, action: @escaping () -> Void = {}) {
        self.label = label
        self.leftImage = leftImage
        self.rightImage = rightImage
        self.isDisabled = isDisabled
        self.action = action
        self.minHeight = minHeight
        self.iconWidth = iconWidth
        self.iconHeight = iconHeight
    }
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let leftImage {
                    leftImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: iconWidth, height: iconHeight)
                }
                Text(label)
                    .appStyle(.headlineSm)
                if let rightImage {
                    rightImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: iconWidth, height: iconHeight)
                }
            }
                .appStyle(.headlineSm)
                .lineLimit(1)
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                .frame(minHeight: minHeight, alignment: .center)
        }
        .buttonStyle(TonalCapsuleStyle(
            foregroundColor: theme.colors.onSecondaryContainerColor,
            backgroundColor: theme.colors.secondaryContainerColor,
            disabledForegroundColor: theme.colors.onSurfaceVarColor.opacity(0.38),
            borderWidth: borderWidth
        ))
        .disabled(isDisabled)
        .accessibilityLabel(Text(label))
    }
}

#Preview {
    HStack{
        TonalButton(label: "Tonal button")
//            .tint(Color.primary)
        TonalButton(label: "Tonal button", isDisabled: true)
//            .tint(Color.primary)
    }
    .padding()
    .background(Color.surface)
}

private struct TonalCapsuleStyle: ButtonStyle {
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
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
