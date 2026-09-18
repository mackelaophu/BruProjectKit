//
//  PopupLoadingOverlayView.swift
//  Adapfit
//

import SwiftUI

/// Nội dung popup (alert/success/error) + loading toàn app. Được host
/// trong `OverlayWindowController` (1 UIWindow riêng) để luôn nổi trên
/// mọi sheet/fullScreenCover, thay vì `.overlay()` thường ở gốc
/// WindowGroup vốn bị các presentation đó vẽ đè lên trên.
public struct PopupLoadingOverlayView: View {
    @EnvironmentObject private var popup: PopupManager

    public init() {}

    public var body: some View {
        ZStack(alignment: .top) {
            if let activePopup = popup.activePopup {
                Group {
                    switch activePopup.type {
                    case .alert(let content, let action):
                        PopupAlert(text: content, action: action, onDismiss: { popup.dequeue() })
                    case .success(let title, let subTitle, let action):
                        PopupSuccessAlert(title: title, subTitle: subTitle, action: action, onDismiss: { popup.dequeue() })
                    case .error(let title, let subTitle, let leftButtonTitle, let rightButtonTitle, let leftButtonImage, let actionLeft, let actionRight):
                        PopupError(
                            title: title,
                            subTitle: subTitle,
                            leftButtonTitle: leftButtonTitle,
                            rightButtonTitle: rightButtonTitle,
                            leftButtonImage: leftButtonImage,
                            actionLeft: actionLeft,
                            actionRight: actionRight,
                            onDismiss: { popup.dequeue() }
                        )
                    }
                }
                .id(activePopup.id)
                .transition(.asymmetric(
                    insertion: .move(edge: .top).combined(with: .opacity),
                    removal: .move(edge: .top).combined(with: .opacity)
                ))
            }

            if popup.showLoading {
                ZStack {
                    Color.black.blur(radius: 3).ignoresSafeArea().opacity(0.3)
                    AppLottieView(name: "animation", loopMode: .loop)
                        .frame(width: 200, height: 200)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {}
                .transition(.opacity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .animation(.spring(response: 0.45, dampingFraction: 0.9), value: popup.activePopup?.id)
        .animation(.easeInOut(duration: 0.2), value: popup.showLoading)
    }
}

#Preview {
    let popup = PopupManager()
    return PopupLoadingOverlayView()
        .environmentObject(popup)
        .onAppear {
            popup.enqueueError(title: "Update Failed", subTitle: "Preview error")
        }
}
