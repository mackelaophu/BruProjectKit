//
//  Divider.swift
//  Adapfit
//
//  Created by PhamHai Dang on 13/1/26.
//

import SwiftUI

public struct M3Divider: View {
    @Environment(\.appTheme) private var theme
    public init(){
        
    }
    public var body: some View {
        Rectangle()
            .fill(theme.colors.outlineVariantColor)
            .frame(height: 1)
    }
}

#Preview {
    M3Divider()
}
