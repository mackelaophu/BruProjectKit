//
//  MetaballView.swift
//  Adapfit
//
//  Created by PhamHai Dang on 14/1/26.
//

import SwiftUI
public final class MetaballEngine: ObservableObject {
    @Published var balls: [MetaBall] = []

    let size: CGSize

    public init(count: Int, size: CGSize) {
        self.size = size

        balls = (0..<count).map { _ in
            MetaBall(
                position: CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: CGFloat.random(in: 0...size.height)
                ),
                velocity: CGVector(
                    dx: CGFloat.random(in: -40...40),
                    dy: CGFloat.random(in: -40...40)
                ),
                radius: CGFloat.random(in: 60...100)
            )
        }
    }

    public func update(dt: CGFloat) {
        for i in balls.indices {
            balls[i].position.x += balls[i].velocity.dx * dt
            balls[i].position.y += balls[i].velocity.dy * dt

            // Bounce
            if balls[i].position.x < 0 || balls[i].position.x > size.width {
                balls[i].velocity.dx *= -1
            }
            if balls[i].position.y < 0 || balls[i].position.y > size.height {
                balls[i].velocity.dy *= -1
            }
        }
    }
}

struct MetaballView: View {
    @State var startingAnim = false
    @Environment(\.appTheme) private var theme
    var body: some View {
        clubbedView()
            .onAppear {
                startingAnim = true
            }
    }
    @ViewBuilder
    func ClubbledRoundedRectagle(offset: CGSize) -> some View {
        Circle()
            .fill(theme.colors.surfaceDimColor)
            .frame(width: 120, height: 120)
            .offset(offset)
    }
    func liquidOffset(index: Int, time: CGFloat) -> CGSize {
        let speed = 0.5 + CGFloat(index) * 0.1
        let radiusX: CGFloat = 180
        let radiusY: CGFloat = 240

        let x = cos(time * speed + CGFloat(index)) * radiusX
        let y = sin(time * speed * 0.7 + CGFloat(index) * 2) * radiusY

        return CGSize(width: x, height: y)
    }
    @ViewBuilder
    func clubbedView() -> some View {
        TimelineView(.animation){ timeline in
            let time = CGFloat(timeline.date.timeIntervalSinceReferenceDate)
            Canvas { context, size in
                context.addFilter(.alphaThreshold(min: 0.5, color: .secondary))
                context.addFilter(.blur(radius: 15))
                context.drawLayer { ctx in
                    for index in 1...8 {
                        if let resolvedView = context.resolveSymbol(id: index) {
                            ctx.draw(resolvedView, at: CGPoint(x: size.width/2, y: size.height/2))
                        }
                    }
                }
            } symbols: {
                ForEach(1...8, id:\.self) { index in
                    let offset = liquidOffset(index: index, time: time)
                    ClubbledRoundedRectagle(offset: offset)
                        .tag(index)
                }
            }
        }
    }
}
#Preview {
    MetaballView()
        .background(Color.surface)
}
