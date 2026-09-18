import SwiftUI

// EnvironmentKey để inject NetworkProtocol vào toàn bộ view hierarchy.
// Feature module lấy ra bằng @Environment(\.network) — không cần biết NetworkClient tồn tại.
private struct NetworkEnvironmentKey: EnvironmentKey {
    static let defaultValue: (any NetworkProtocol)? = nil
}

public extension EnvironmentValues {
    var network: (any NetworkProtocol)? {
        get { self[NetworkEnvironmentKey.self] }
        set { self[NetworkEnvironmentKey.self] = newValue }
    }
}
