//
//  M3Snackbar.swift
//  Adapfit
//
//  Created by PhamHai Dang on 13/1/26.
//

import SwiftUI

public struct M3Snackbar: View {
    @Environment(\.appTheme) private var theme
    let message: String
    var actionLabel: String?
    var action: (() -> Void)? = nil
    public init(message: String,
                actionLabel: String? = nil,
                action: (() -> Void)? = nil) {
        self.message = message
        self.actionLabel = actionLabel
        self.action = action
    }
    public var body: some View {
        HStack {
            Text(message)
                .appStyle(.bodyMd)
                .foregroundStyle(theme.colors.inverseOnSurfaceColor)
            
            Spacer()
            
            if let label = actionLabel {
                Button(label) { action?() }
                    .appStyle(.bodyLg)
                    .foregroundStyle(theme.colors.inversePrimaryColor)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(theme.colors.inverseSurfaceColor)
        .clipShape(Capsule())
        .padding()
    }
}

#Preview {
    M3Snackbar(message: "test message", actionLabel: "do it")
}
