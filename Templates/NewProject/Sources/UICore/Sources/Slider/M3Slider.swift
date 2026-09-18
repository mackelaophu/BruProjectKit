//
//  M3Slider.swift
//  Adapfit
//
//  Created by PhamHai Dang on 13/1/26.
//

import SwiftUI

public struct M3Slider: View {
    @Environment(\.appTheme) private var theme
    @Binding var value: Double
    let closeRange: ClosedRange<Double>
    public init(value: Binding<Double>, closeRange: ClosedRange<Double>) {
        self._value = value
        self.closeRange = closeRange
    }
    public var body: some View {
        Slider(value: $value, in: closeRange, step: 1)
            .accentColor(theme.colors.primaryColor) // Active track dùng Primary
            .frame(minHeight: 48) // Đảm bảo vùng chạm tối thiểu 48dp [2, 9]
            .accessibilityLabel("Volume slider") // Hỗ trợ Screen Reader [10, 11]
            .padding(.horizontal)
    }
}

#Preview {
    @Previewable @State var progress: Double = 0
    M3Slider(value: $progress, closeRange: 0...100)
}
