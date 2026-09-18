//
//  CheckBox.swift
//  Adapfit
//
//  Created by PhamHai Dang on 12/1/26.
//

import SwiftUI
public enum CheckBoxState {
    case checked,indeterminate, unchecked
    var imageName: String {
        switch self {
        case .checked:
            "checkmark.square.fill"
        case .indeterminate:
            "minus.square.fill"
        case .unchecked:
            "square"
        }
    }
}
public struct CheckBox: View {
    @Environment(\.appTheme) private var theme
    var isDisabled: Bool = false
    var action: () -> Void = {}
    @State var state: CheckBoxState = .checked
    @State var isError: Bool = false
    
    private let borderWidth: CGFloat = 2
    public init(isDisabled: Bool = false,
                action: @escaping () -> Void = {},
                state: CheckBoxState = .checked,
                isError: Bool = false) {
        self.isDisabled = isDisabled
        self.action = action
        self.state = state
        self.isError = isError
    }
    public var body: some View {
        Button(action: {
            if state == .indeterminate || state == .unchecked {
                state = .checked
            } else if state == .checked {
                state = .unchecked
            }
            action()
        }) {
            Image(systemName: state.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 18, height: 18, alignment: .center)
        }
        .buttonStyle(CheckBoxStyle(
            foregroundColor: theme.colors.onPrimaryColor,
            borderWidth: borderWidth,
            state: state,
            isError: isError
        ))
        .disabled(isDisabled)
    }
}

#Preview {
    HStack{
        CheckBox(state: .indeterminate)
        CheckBox(state: .unchecked)
        CheckBox(state: .checked, isError: true)
        CheckBox(isDisabled: true)
        CheckBox(isDisabled: true,state: .unchecked)
    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(Color.surface)
}

private struct CheckBoxStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.appTheme) private var theme
    let foregroundColor: Color
    let borderWidth: CGFloat
    let state: CheckBoxState
    let isError: Bool

    func makeBody(configuration: Configuration) -> some View {
       
        return configuration.label
            .foregroundStyle(isEnabled ? isError ? theme.colors.errorColor : theme.colors.primaryColor : theme.colors.onSurfaceColor.opacity(0.38))
            .background(
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 2)
                            .fill(foregroundColor.opacity(configuration.isPressed ? 0.10 : 0.0))
                    )
            )
            .contentShape(RoundedRectangle(cornerRadius: 2))
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
