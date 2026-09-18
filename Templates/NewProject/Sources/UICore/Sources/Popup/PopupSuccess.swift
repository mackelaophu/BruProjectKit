//
//  PopupSuccess.swift
//  Adapfit
//

import SwiftUI

public struct PopupSuccessAlert: View {
    @Environment(\.appTheme) private var theme
    
    let title: String
    let subTitle: String
    let action: () -> Void
    let onDismiss: () -> Void
    
    @State private var remainingTime: Int = MAX_POPUP_SHOW_IN_SECONDS
    @State private var timer: Timer? = nil

    public init(title: String, subTitle: String, action: @escaping () -> Void = {}, onDismiss: @escaping () -> Void) {
        self.title = title
        self.subTitle = subTitle
        self.action = action
        self.onDismiss = onDismiss
    }
    
    private func cleanUp() {
        timer?.invalidate()
        timer = nil
    }
    
    private func startTimer() {
        timer?.invalidate()
        remainingTime = MAX_POPUP_SHOW_IN_SECONDS
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            Task { @MainActor in
                if remainingTime > 0 {
                    remainingTime -= 1
                } else {
                    cleanUp()
                    dismissWithAnimation()
                }
            }
        }
        if let t = timer { RunLoop.current.add(t, forMode: .common) }
    }
    
    private func dismissWithAnimation() {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.9)) {
            onDismiss()
        }
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(theme.colors.onSecondaryContainerColor)
                    .padding(8)
            }
            .background(theme.colors.surfaceColor.opacity(0.5))
            .padding(.leading, 16)
            .containerShape(Capsule())
            
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .appStyle(.headlineSm)
                    .padding(.horizontal, 8)
                    .foregroundStyle(theme.colors.onSecondaryContainerColor)
                Text(subTitle)
                    .appStyle(.titleSm)
                    .padding(.horizontal, 8)
                    .foregroundStyle(theme.colors.onSecondaryContainerColor)
            }
            .padding(.vertical, 16)
            
            Button(action: {
                dismissWithAnimation()
                action()
            }) {
                Image(systemName: "xmark")
                    .foregroundStyle(theme.colors.onSecondaryContainerColor)
                    .padding()
            }
            .frame(minWidth: 48, minHeight: 48)
            .padding(.trailing, 16)
        }
        .background(theme.colors.secondaryContainerColor)
        .clipShape(Capsule())
        .gesture(
            DragGesture(minimumDistance: 20, coordinateSpace: .local)
                .onEnded { value in
                    if value.translation.height < 0 {
                        dismissWithAnimation()
                    }
                }
        )
        .onAppear {
            startTimer()
        }
        .onDisappear {
            cleanUp()
        }
    }
}

#Preview {
    PopupSuccessAlert(title: "Success", subTitle: "Operation completed", onDismiss: {})
}
