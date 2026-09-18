//
//  PopupError.swift
//  Adapfit
//

import SwiftUI

public struct PopupError: View {
    @Environment(\.appTheme) private var theme
    
    let title: String
    let subTitle: String
    let leftButtonTitle: String
    let rightButtonTitle: String
    let leftButtonImage: Image?
    let actionLeft: () -> Void
    let actionRight: () -> Void
    let onDismiss: () -> Void
    
    @State private var remainingTime: Int = MAX_POPUP_SHOW_IN_SECONDS
    @State private var timer: Timer? = nil

    public init(
        title: String,
        subTitle: String,
        leftButtonTitle: String = "",
        rightButtonTitle: String = "",
        leftButtonImage: Image? = nil,
        actionLeft: @escaping () -> Void = {},
        actionRight: @escaping () -> Void = {},
        onDismiss: @escaping () -> Void
    ) {
        self.title = title
        self.subTitle = subTitle
        self.leftButtonTitle = leftButtonTitle
        self.rightButtonTitle = rightButtonTitle
        self.leftButtonImage = leftButtonImage
        self.actionLeft = actionLeft
        self.actionRight = actionRight
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
                Image(systemName: "info.circle.fill")
                    .foregroundStyle(theme.colors.onErrorContainerColor)
                    .padding(8)
            }
            .background(theme.colors.surfaceColor.opacity(0.5))
            .padding(.leading, 16)
            .containerShape(Capsule())
            
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .appStyle(.headlineSm)
                    .padding(.horizontal, 8)
                    .foregroundStyle(theme.colors.onErrorContainerColor)
                Text(subTitle)
                    .appStyle(.titleSm)
                    .padding(.horizontal, 8)
                    .foregroundStyle(theme.colors.onErrorContainerColor.opacity(0.8))
                
                if !leftButtonTitle.isEmpty || !rightButtonTitle.isEmpty {
                    HStack(spacing: 16) {
                        if !leftButtonTitle.isEmpty {
                            Button(action: {
                                dismissWithAnimation()
                                actionLeft()
                            }) {
                                HStack {
                                    if let img = leftButtonImage {
                                        img
                                    }
                                    Text(leftButtonTitle.uppercased())
                                        .appStyle(.headlineSm)
                                }
                                .frame(minHeight: 48)
                                .foregroundStyle(theme.colors.onErrorContainerColor)
                            }
                        } else {
                            Spacer()
                        }
                        
                        if !rightButtonTitle.isEmpty {
                            Button(action: {
                                dismissWithAnimation()
                                actionRight()
                            }) {
                                Text(rightButtonTitle.uppercased())
                                    .appStyle(.headlineSm)
                                    .frame(minHeight: 48)
                                    .foregroundStyle(theme.colors.onErrorContainerColor.opacity(0.7))
                            }
                            .padding(.trailing, 8)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal, 8)
                }
            }
            .padding(.vertical, 16)
            .padding(.trailing, 16)
            
            if leftButtonTitle.isEmpty && rightButtonTitle.isEmpty {
                Button(action: {
                    dismissWithAnimation()
                }) {
                    Image(systemName: "xmark")
                        .foregroundStyle(theme.colors.onErrorContainerColor)
                        .padding()
                }
                .frame(minWidth: 48, minHeight: 48)
                .padding(.trailing, 16)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .background(theme.colors.errorContainerColor)
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
    PopupError(title: "Update Failed", subTitle: "Error occurred", onDismiss: {})
        .padding()
}
