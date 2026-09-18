//
//  ExpirableData.swift
//  AdapfitV2
//
//  Created by PhamHai Dang on 6/6/26.
//  Copyright © 2026 Bru. All rights reserved.
//


import Foundation

struct ExpirableData<T: Codable>: Codable {
    let value: T
    let expirationDate: Date
    
    var isExpired: Bool {
        return Date() > expirationDate
    }
}
