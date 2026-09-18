//
//  M3Progress.swift
//  Adapfit
//
//  Material 3 (Expressive) linear progress indicators.
//  Khác với M3Slider: đây là view chỉ-hiển-thị, không nhận gesture.
//

import SwiftUI

// MARK: - Determinate

/// Linear progress theo chuẩn M3 Expressive:
/// active track (bo tròn) + gap + inactive track + stop indicator ở cuối.
public struct M3LinearProgress: View {
    @Environment(\.appTheme) private var theme

    private let value: Double
    private let height: CGFloat
    private let gap: CGFloat
    private let showsStopIndicator: Bool
    private let activeColor: Color?
    private let trackColor: Color?

    /// - Parameters:
    ///   - value: 0...1 (tự clamp).
    ///   - height: chiều cao track. M3 mặc định 4, Expressive dùng 8–12 cho card lớn.
    ///   - gap: khoảng hở giữa active và inactive track. Đặt 0 để về style M3 cũ.
    ///   - showsStopIndicator: chấm tròn ở cuối track.
    public init(
        value: Double,
        height: CGFloat = 12,
        gap: CGFloat = 4,
        showsStopIndicator: Bool = true,
        activeColor: Color? = nil,
        trackColor: Color? = nil
    ) {
        self.value = min(max(value, 0), 1)
        self.height = height
        self.gap = gap
        self.showsStopIndicator = showsStopIndicator
        self.activeColor = activeColor
        self.trackColor = trackColor
    }

    private var active: Color { activeColor ?? theme.colors.primaryColor }
    private var inactive: Color { trackColor ?? theme.colors.secondaryContainerColor }

    public var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            // Gap chỉ xuất hiện khi cả 2 đoạn cùng tồn tại.
            let g: CGFloat = (value <= 0.001 || value >= 0.999) ? 0 : gap

            if g == 0 {
                // Style liền: một track duy nhất, fill đè lên trên.
                // Tránh hai capsule úp nắp vào nhau tạo cảm giác "2 cục".
                ZStack(alignment: .leading) {
                    Capsule(style: .continuous)
                        .fill(inactive)

                    if showsStopIndicator, value < 0.999 {
                        Circle()
                            .fill(active)
                            .frame(width: height, height: height)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }

                    Capsule(style: .continuous)
                        .fill(active)
                        .frame(width: max(0, min(w, w * value)))
                }
            } else {
                // Style M3 Expressive: hai đoạn tách nhau bởi gap.
                let activeWidth = max(0, min(w, (w - g) * value))
                let inactiveWidth = max(0, w - activeWidth - g)

                HStack(spacing: g) {
                    Capsule(style: .continuous)
                        .fill(active)
                        .frame(width: activeWidth)

                    ZStack(alignment: .trailing) {
                        Capsule(style: .continuous)
                            .fill(inactive)
                        if showsStopIndicator {
                            Circle()
                                .fill(active)
                                .frame(width: height, height: height)
                        }
                    }
                    .frame(width: inactiveWidth)
                }
            }
        }
        .frame(height: height)
        .animation(.spring(response: 0.45, dampingFraction: 0.85), value: value)
        .accessibilityElement()
        .accessibilityLabel("Tiến độ")
        .accessibilityValue("\(Int((value * 100).rounded())) phần trăm")
    }
}

// MARK: - Indeterminate

/// Track chạy vô hạn — dùng khi chưa biết tổng tiến độ (đang tải, đang sync...).
public struct M3IndeterminateProgress: View {
    @Environment(\.appTheme) private var theme

    private let height: CGFloat
    private let duration: Double
    private let activeColor: Color?
    private let trackColor: Color?

    @State private var isAnimating = false

    public init(
        height: CGFloat = 12,
        duration: Double = 1.2,
        activeColor: Color? = nil,
        trackColor: Color? = nil
    ) {
        self.height = height
        self.duration = duration
        self.activeColor = activeColor
        self.trackColor = trackColor
    }

    private var active: Color { activeColor ?? theme.colors.primaryColor }
    private var inactive: Color { trackColor ?? theme.colors.secondaryContainerColor }

    public var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let barWidth = w * 0.35

            Capsule(style: .continuous)
                .fill(inactive)
                .overlay(alignment: .leading) {
                    Capsule(style: .continuous)
                        .fill(active)
                        .frame(width: barWidth)
                        .offset(x: isAnimating ? w : -barWidth)
                }
                .clipShape(Capsule(style: .continuous))
        }
        .frame(height: height)
        .onAppear {
            guard !isAnimating else { return }
            withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                isAnimating = true
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Đang xử lý")
    }
}

// MARK: - Segmented

/// Progress chia đoạn — hợp cho "bài tập 3/5", "set 2/4", onboarding steps.
public struct M3SegmentedProgress: View {
    @Environment(\.appTheme) private var theme

    private let total: Int
    private let completed: Int
    private let height: CGFloat
    private let spacing: CGFloat
    private let activeColor: Color?
    private let trackColor: Color?

    public init(
        total: Int,
        completed: Int,
        height: CGFloat = 8,
        spacing: CGFloat = 4,
        activeColor: Color? = nil,
        trackColor: Color? = nil
    ) {
        self.total = max(total, 1)
        self.completed = min(max(completed, 0), max(total, 1))
        self.height = height
        self.spacing = spacing
        self.activeColor = activeColor
        self.trackColor = trackColor
    }

    private var active: Color { activeColor ?? theme.colors.primaryColor }
    private var inactive: Color { trackColor ?? theme.colors.secondaryContainerColor }

    public var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<total, id: \.self) { index in
                Capsule(style: .continuous)
                    .fill(index < completed ? active : inactive)
            }
        }
        .frame(height: height)
        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: completed)
        .accessibilityElement()
        .accessibilityLabel("Tiến độ")
        .accessibilityValue("\(completed) trên \(total)")
    }
}

// MARK: - Previews

#Preview("Determinate") {
    @Previewable @State var value: Double = 0.62

    VStack(alignment: .leading, spacing: 32) {
        M3LinearProgress(value: value)
        M3LinearProgress(value: value, height: 4, gap: 0, showsStopIndicator: false)
        M3LinearProgress(value: value, height: 20, gap: 6)

        Slider(value: $value, in: 0...1)
    }
    .padding(24)
}

#Preview("Indeterminate") {
    M3IndeterminateProgress()
        .padding(24)
}

#Preview("Segmented") {
    @Previewable @State var step: Int = 3

    VStack(spacing: 32) {
        M3SegmentedProgress(total: 5, completed: step)
        Stepper("Bước \(step)", value: $step, in: 0...5)
    }
    .padding(24)
}
