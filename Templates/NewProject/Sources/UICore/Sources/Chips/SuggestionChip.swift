//
//  SuggestionChip.swift
//  Adapfit
//
//  Created by PhamHai Dang on 13/1/26.
//

import SwiftUI

public struct SuggestionChip: View {
    @Environment(\.appTheme) private var theme
    var label: String
    var isDisabled: Bool = false
    var action: () -> Void = {}
    
    private let horizontalPadding: CGFloat = 16
    private let verticalPadding: CGFloat = 10
    private let borderWidth: CGFloat = 1
    public init(
         label: String,
         isDisabled: Bool = false ,
         action: @escaping () -> Void = {}) {
        self.label = label
        self.isDisabled = isDisabled
        self.action = action
    }
    public var body: some View {
        Button(action: action) {
            Text(label)
                .appStyle(.headlineSm)
                .lineLimit(1)
                .padding(.vertical, verticalPadding)
                .padding(.horizontal, horizontalPadding)
                .frame(height: 32)
        }
        .buttonStyle(SuggestionChipStyle())
        .disabled(isDisabled)
        .accessibilityLabel(Text(label))
    }
}

#Preview {
    HStack{
        SuggestionChip(label: "Filled Button")
            .tint(Color.primary)
        SuggestionChip(label: "Filled Button", isDisabled: true)
            .tint(Color.primary)
    }
    .padding()
    .background(Color.surface)
}

private struct SuggestionChipStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.appTheme) private var theme

    func makeBody(configuration: Configuration) -> some View {

        return configuration.label
            .foregroundStyle(isEnabled ? Color.primary : theme.colors.onSurfaceColor.opacity(0.38))
            .background(
                Capsule()
                    .fill(Color.clear)
                    .overlay(
                        Capsule()
                            .fill(theme.colors.primaryColor.opacity(configuration.isPressed ? 0.10 : 0.0))
                    )
            )
            .overlay(
                Capsule()
                    .stroke(isEnabled ? theme.colors.outlineVariantColor : theme.colors.onSurfaceColor.opacity(0.12), lineWidth: 1)
            )
            .contentShape(Capsule())
            .frame(minHeight: 48)
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
