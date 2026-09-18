//
//  PopupManager.swift
//  Adapfit
//

import SwiftUI
import Combine

/// Quản lý tập trung popup qua hàng đợi (Queue) - inject 1 lần qua .environmentObject()
public final class PopupManager: ObservableObject {
    
    @Published public var showLoading: Bool = false
    @Published public var activePopup: PopupRequest? = nil
    
    private var queue: [PopupRequest] = []
    
    public init() {}
    
    public func enqueue(_ request: PopupRequest) {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.9)) {
            queue.removeAll()
            activePopup = request
        }
    }
    
    public func dequeue() {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.9)) {
            if !queue.isEmpty {
                activePopup = queue.removeFirst()
            } else {
                activePopup = nil
            }
        }
    }
    
    // MARK: - Helper Methods
    
    public func enqueueAlert(_ content: String, action: @escaping () -> Void = {}) {
        enqueue(PopupRequest(type: .alert(content: content, action: action)))
    }
    
    public func enqueueSuccess(title: String, subTitle: String, action: @escaping () -> Void = {}) {
        enqueue(PopupRequest(type: .success(title: title, subTitle: subTitle, action: action)))
    }
    
    public func enqueueError(
        title: String,
        subTitle: String,
        leftButtonTitle: String = "",
        rightButtonTitle: String = "",
        leftButtonImage: Image? = nil,
        actionLeft: @escaping () -> Void = {},
        actionRight: @escaping () -> Void = {}
    ) {
        enqueue(PopupRequest(type: .error(
            title: title,
            subTitle: subTitle,
            leftButtonTitle: leftButtonTitle,
            rightButtonTitle: rightButtonTitle,
            leftButtonImage: leftButtonImage,
            actionLeft: actionLeft,
            actionRight: actionRight
        )))
    }
}
