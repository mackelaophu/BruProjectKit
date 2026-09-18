//
//  M3Tooltip.swift
//  Adapfit
//
//  Created by PhamHai Dang on 13/1/26.
//

import SwiftUI
import Common

public struct M3Tooltip: View {
    @Environment(\.appTheme) private var theme
    let text: String
    public init(text: String) {
        self.text = text
    }
    public var body: some View {
        Text(text)
            .appStyle(.labelMd)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .foregroundStyle(theme.colors.inverseOnSurfaceColor)
            .background(theme.colors.inverseSurfaceColor)
            .clipShape(Capsule())
    }
}

#Preview {
    M3Tooltip(text: "tooltip text")
}
