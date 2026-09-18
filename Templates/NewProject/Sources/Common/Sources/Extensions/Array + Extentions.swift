//
//  File.swift
//  AdapfitV2
//
//  Created by PhamHai Dang on 31/5/26.
//  Copyright © 2026 Bru. All rights reserved.
//


import Foundation
public extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
