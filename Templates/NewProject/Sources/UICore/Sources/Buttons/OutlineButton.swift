//
//  OutlineButton.swift
//  Adapfit
//
//  Created by PhamHai Dang on 12/1/26.
//

import SwiftUI
import Common

public struct OutlineButton: View {
    @Environment(\.appTheme) private var theme
    var label: String
    var leftImage: Image?
    var rightImage: Image?
    var isDisabled: Bool = false
    var action: () -> Void = {}
    public init(label: String, leftImage: Image? = nil, rightImage: Image? = nil, isDisabled: Bool = false, action: @escaping () -> Void = {}) {
        self.label = label
        self.leftImage = leftImage
        self.rightImage = rightImage
        self.isDisabled = isDisabled
        self.action = action
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
        .buttonStyle(OutlinedCapsuleStyle(
            borderColor: theme.colors.outlineColor,
            disabledBorderColor: theme.colors.outlineVariantColor,
            foregroundColor: theme.colors.onSurfaceColor,
            disabledForegroundColor: theme.colors.onSurfaceVarColor.opacity(0.38),
            borderWidth: borderWidth
        ))
        .disabled(isDisabled)
        .accessibilityLabel(Text(label))
    }
}
public struct OutlinedCapsuleStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.appTheme) private var theme
    let borderColor: Color
    let disabledBorderColor: Color
    let foregroundColor: Color
    let disabledForegroundColor: Color
    let borderWidth: CGFloat
    public init(borderColor: Color,
                disabledBorderColor: Color,
                foregroundColor: Color,
                disabledForegroundColor: Color,
                borderWidth: CGFloat) {
        self.borderColor = borderColor
        self.disabledBorderColor = disabledBorderColor
        self.foregroundColor = foregroundColor
        self.disabledForegroundColor = disabledForegroundColor
        self.borderWidth = borderWidth
    }

    public func makeBody(configuration: Configuration) -> some View {
       
        return configuration.label
            .foregroundStyle(isEnabled ? foregroundColor : theme.colors.onSurfaceColor.opacity(0.38))
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(foregroundColor.opacity(configuration.isPressed ? 0.10 : 0.0))
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isEnabled ? borderColor : Color.onSurface.opacity(0.12), lineWidth: borderWidth)
            )
            .applyGlass(radius: 18)
            .contentShape(RoundedRectangle(cornerRadius: 18))
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
#Preview {
    HStack{
        OutlineButton(label: "Outline button")
//            .tint(Color.onPrimary)
        OutlineButton(label: "Outline button", isDisabled: true)
//            .tint(Color.onPrimary)
    }
    .padding()
    .background(Color.surface)
}
