import SwiftUI

// MARK: - SessionStorageKey
public protocol SessionStorageKey {
    associatedtype Value: Sendable
    static var defaultValue: Value { get }
}

// MARK: - AppSession
// KHÔNG đánh dấu @MainActor trên class vì:
//   1. EnvironmentKey.defaultValue là nonisolated → @MainActor class gây conformance error
//   2. ObservableObject được thiết kế dùng @unchecked Sendable cho pattern này
//
// Thread safety đến từ callsite:
//   - App tạo AppSession trên @MainActor (App.body)
//   - Chỉ SwiftUI View (@MainActor) mới đọc/ghi qua @Environment(\.session)
//   - Module code mutate session qua View callbacks → luôn trên main thread
//
// @unchecked Sendable nói với Swift: "tôi đảm bảo thread safety theo architecture,
// không cần compiler check thêm."
public final class AppSession: ObservableObject, @unchecked Sendable {

    // MARK: Shared primitives
    @Published public var accessToken: String?
    @Published public var refreshToken: String?
    @Published public var accessExpiresIn: String?
    @Published public var refreshExpiresIn: String?
    @Published public var authToken: String?
    @Published public var userID: String?
    @Published public var displayName: String?
    @Published public var avatarURL: URL?
    @Published public var isPremium: Bool = false
    @Published public var role: String?

    public var isLoggedIn: Bool { authToken != nil }

    // MARK: Extensible storage
    private var storage: [ObjectIdentifier: any Sendable] = [:]

    public subscript<K: SessionStorageKey>(key: K.Type) -> K.Value {
        get { storage[ObjectIdentifier(key)] as? K.Value ?? key.defaultValue }
        set { storage[ObjectIdentifier(key)] = newValue }
    }

    public init() {}

    public func clear() {
        authToken = nil
        userID = nil
        displayName = nil
        avatarURL = nil
        isPremium = false
        accessToken = nil
        refreshToken = nil
        accessExpiresIn = nil
        refreshExpiresIn = nil
        storage.removeAll()
    }
}

// MARK: - Environment
private struct AppSessionKey: EnvironmentKey {
    // static let: initialized lazily on first access (Swift runtime lock).
    // First access = SwiftUI rendering = @MainActor → init() chạy đúng thread.
    static let defaultValue = AppSession()
}

public extension EnvironmentValues {
    var session: AppSession {
        get { self[AppSessionKey.self] }
        set { self[AppSessionKey.self] = newValue }
    }
}
//
//private struct NavigationManagerKey: EnvironmentKey {
//    // NavigationManager is @MainActor; EnvironmentKey.defaultValue is nonisolated.
//    // In practice SwiftUI only accesses this on the main actor, so @unchecked
//    // suppression via nonisolated(unsafe) is safe here — same pattern as AppSessionKey.
//    static let defaultValue: NavigationManager<AppRoute> = {
//        MainActor.assumeIsolated {
//            NavigationManager<AppRoute>(cacheKey: "app.navigation")
//        }
//    }()
//}
//public extension EnvironmentValues {
//    var navigation: NavigationManager<AppRoute> {
//        get { self[NavigationManagerKey.self] }
//        set { self[NavigationManagerKey.self] = newValue }
//    }
//}
