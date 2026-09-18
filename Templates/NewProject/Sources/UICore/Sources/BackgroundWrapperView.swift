//
//  BackgroundWrapperView.swift
//  AdapfitV2
//
//  Created by PhamHai Dang on 29/5/26.
//  Copyright © 2026 Bru. All rights reserved.
//

import SwiftUI

public struct BackgroundWrapperView<Content:View>: View {
    let content: Content
    let image: Image
    public init(image: Image = UICoreAsset.bgLogin.swiftUIImage,@ViewBuilder content:  () -> Content) {
        self.content = content()
        self.image = image
    }
    
    public var body: some View {
        ZStack {
            content
        }
        .background {
            image
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}

#Preview {
    BackgroundWrapperView() {
        EmptyView()
    }
}

#if canImport(UIKit)
public extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}
#endif
