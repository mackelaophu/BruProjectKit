//
//  MemoryWrapper.swift
//  AdapfitV2
//
//  Created by PhamHai Dang on 6/6/26.
//  Copyright © 2026 Bru. All rights reserved.
//


import Foundation
final class MemoryWrapper: NSObject {
    let value: Any
    let expirationDate: Date
    
    init(value: Any, expirationDate: Date) {
        self.value = value
        self.expirationDate = expirationDate
    }
    
    var isExpired: Bool {
        return Date() > expirationDate
    }
}