//
//  BadgesView.swift
//  Adapfit
//
//  Created by PhamHai Dang on 12/1/26.
//

import SwiftUI

public struct BadgesView: View {
    @Environment(\.appTheme) private var theme
    var label: String
    var action: () -> Void = {}
    
    public init(label: String, action: @escaping () -> Void = {}) {
        self.label = label
        self.action = action
    }
    public var body: some View {
        Text(label)
            .tracking(0.5)
            .padding(.horizontal, 5)
            .appStyle(.titleSm)
            .lineLimit(1)
            .frame(height: 16, alignment: .center)
            .background(Color.error)
            .foregroundStyle(theme.colors.onErrorColor)
            .clipShape(Capsule())
    }
}

#Preview {
    BadgesView(label: "1000")
}
