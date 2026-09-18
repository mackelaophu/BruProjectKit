//
//  MetaBall.swift
//  Adapfit
//
//  Created by PhamHai Dang on 14/1/26.
//

import UIKit
public struct MetaBall: Identifiable {
    public let id = UUID()
    public var position: CGPoint
    public var velocity: CGVector
    public var radius: CGFloat
}
