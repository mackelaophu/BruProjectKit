//
//  ClearTextModier.swift
//  Common
//
//  Created by PhamHai Dang on 3/6/26.
//  Copyright © 2026 Bru. All rights reserved.
//

import SwiftUI
public struct ClearTextModier: ViewModifier {
    @Binding var text: String
    public func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            content
                .padding(.trailing, 56)
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
public extension View {
    func clearText(_ binding: Binding<String>) -> some View {
        self.modifier(ClearTextModier(text: binding))
    }
}
