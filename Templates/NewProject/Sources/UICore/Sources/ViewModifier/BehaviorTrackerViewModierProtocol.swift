//
//  BehaviorTrackerViewModierProtocol.swift
//  UICore
//
//  Created by PhamHai Dang on 10/6/26.
//  Copyright © 2026 Bru. All rights reserved.
//

import SwiftUI
public struct BehaviorTrackedKey: EnvironmentKey {
    public static let defaultValue: @MainActor (AnyView, String,[String: String]) -> AnyView = { view, _, _ in view }
}
public extension EnvironmentValues {
    var behaviorTrack: @MainActor (AnyView, String,[String: String]) -> AnyView {
        get {
            self[BehaviorTrackedKey.self]
        } set {
            self[BehaviorTrackedKey.self] = newValue
        }
    }
}
public extension View {
    func behaviorTracked(_ name: String, metadata: [String: String] = [:]) -> some View {
        modifier(_BehaviorTrackedProxy(name: name, metadata: metadata))
    }
}
private struct _BehaviorTrackedProxy: ViewModifier {
    let name: String
    let metadata: [String: String]
    @Environment(\.behaviorTrack) private var bridge

    func body(content: Content) -> some View {
        bridge(AnyView(content), name, metadata)
    }
}
