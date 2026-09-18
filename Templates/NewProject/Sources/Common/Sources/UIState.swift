//
//  UIState.swift
//  Common
//
//  Created by PhamHai Dang on 2/6/26.
//  Copyright © 2026 Bru. All rights reserved.
//

import Foundation
public enum UIState: Equatable {
    case loading
    case failure(Error)
    case success(Decodable)
    case done
    case none

    public static func == (lhs: UIState, rhs: UIState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (.failure, .failure): return true
        case (.success, .success): return true
        case (.done, .done): return true
        case (.none, .none): return true
        default: return false
        }
    }
}
