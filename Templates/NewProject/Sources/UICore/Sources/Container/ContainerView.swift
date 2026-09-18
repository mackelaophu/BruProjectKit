//
//  ContainerView.swift
//  Adapfit
//
//  Created by PhamHai Dang on 14/1/26.
//

import SwiftUI
public enum AlertType {
    case error
    case sucess
    case warning
    case none
}
public struct ContainerView<Content: View>: View {
    @Environment(\.appTheme) private var theme
    let content: Content
    let isLiquid: Bool
    public init(isLiquid: Bool = false,@ViewBuilder content: () -> Content) {
        self.content = content()
        self.isLiquid = isLiquid
    }
    
    @State private var popupOrder: [String] = []

    private func zIndex(for key: String) -> Double {
        let base = 1000.0
        return base + Double(popupOrder.firstIndex(of: key) ?? 0)
    }

    public var body: some View {
        ZStack(alignment: .top){
            if isLiquid {
                LiquidBackgroundView()
            }
            MetaballView()
                .opacity(0.05)
            
            VStack{
                content
            }
        }
        
        .background(isLiquid ? Color.clear : theme.colors.surfaceColor)
    }
}

#Preview {
    ContainerView(){
        Text("test container")
    }
}

