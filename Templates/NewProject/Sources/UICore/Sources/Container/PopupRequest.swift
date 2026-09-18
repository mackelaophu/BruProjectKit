//
//  PopupRequest.swift
//  Adapfit
//

import SwiftUI

public struct PopupRequest: Identifiable {
    public let id = UUID()
    public let type: PopupType
    
    public init(type: PopupType) {
        self.type = type
    }
}

public enum PopupType {
    case alert(content: String, action: () -> Void)
    case success(title: String, subTitle: String, action: () -> Void)
    case error(
        title: String,
        subTitle: String,
        leftButtonTitle: String,
        rightButtonTitle: String,
        leftButtonImage: Image?,
        actionLeft: () -> Void,
        actionRight: () -> Void
    )
}
