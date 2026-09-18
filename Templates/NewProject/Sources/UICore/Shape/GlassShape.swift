//
//  GlassShape.swift
//  AdapfitV2
//
//  Created by PhamHai Dang on 7/8/26.
//  Copyright © 2026 Bru. All rights reserved.
//
import SwiftUI

public struct GlassShape: InsettableShape {
    public var cornerRadius: CGFloat
    public var insetAmount: CGFloat = 0

    public init(cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
    }

    public func path(in rect: CGRect) -> Path {
        let bounds = rect.insetBy(dx: insetAmount, dy: insetAmount)
        guard bounds.width > 0, bounds.height > 0 else { return Path() }

        let maxRadius = min(bounds.width, bounds.height) / 2
        let radius = min(max(0, cornerRadius - insetAmount), maxRadius)
        
        guard radius >= maxRadius - 0.01 else {
            return Path(roundedRect: bounds, cornerRadius: radius, style: .circular)
        }
        if abs(bounds.width - bounds.height) < 0.01 {
            return Circle().path(in: bounds)
        }
        return Capsule(style: .circular).path(in: bounds)
    }

    public func inset(by amount: CGFloat) -> some InsettableShape {
        var shape = self
        shape.insetAmount += amount
        return shape
    }
}

@MainActor public let glassStrokeJoin: (CGFloat) -> StrokeStyle = { lineWidth in
    StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round)
}
