import SwiftUI

// MARK: - NavigationRoute
/// Mọi route enum đều phải conform protocol này.
/// Hashable → dùng được trong NavigationStack typed path.
/// Codable  → persist/restore được stack.
public protocol NavigationRoute: Hashable, Codable {}

// MARK: - NavigationSearchPriority
/// Khi gọi back(to:), tìm màn đích ở stack nào trước.
public enum NavigationSearchPriority {
    /// Tìm trong stack hiện tại (child) trước, không thấy mới lên stack cha (parent).
    case childFirst
    /// Tìm trong stack cha (parent) trước, không thấy mới xuống stack con (child).
    case parentFirst
}

// MARK: - AnyNavigationStack
/// Type-erased protocol để NavigationManager generic có thể giữ reference
/// tới parent stack mà không bị ràng buộc bởi Route type cụ thể.
/// Cho phép delegate cross-stack operations giữa parent và child.
@MainActor
public protocol AnyNavigationStack: AnyObject {
    /// Pop 1 màn.
    func back()
    /// Pop N màn.
    func back(count: Int)
    /// Pop toàn bộ stack.
    func popToRoot()
    /// Tìm phần tử thỏa điều kiện (type-erased Any) và pop về đó.
    /// Trả về true nếu tìm thấy và đã pop thành công.
    @discardableResult
    func backToFirst(where predicate: (Any) -> Bool) -> Bool
    /// Kiểm tra stack có chứa phần tử thỏa điều kiện không.
    func contains(where predicate: (Any) -> Bool) -> Bool
}

// MARK: - NavigationManager
/// Generic navigation manager dùng typed array làm path.
/// Tương thích với: NavigationStack(path: $nav.path) { ... }
/// Data = [Route] thỏa: MutableCollection, RandomAccessCollection,
/// RangeReplaceableCollection, Element: Hashable.
@MainActor
public final class NavigationManager<Route: NavigationRoute>: ObservableObject, AnyNavigationStack {

    @Published public var path: [Route] = []

    /// Parent stack (type-erased).
    /// Khi stack hiện tại cạn hoặc không tìm thấy màn đích, delegate lên đây.
    public weak var parent: (any AnyNavigationStack)?

    private let cacheKey: String?

    public init(cacheKey: String? = nil) {
        self.cacheKey = cacheKey
        if let key = cacheKey { load(key: key) }
    }

    // MARK: - Navigate forward

    public func push(_ route: Route) {
        path.append(route)
    }

    // MARK: - Back (1 màn)
    /// Pop 1 màn trong stack hiện tại.
    /// Nếu stack rỗng → delegate lên parent.
    public func back() {
        if !path.isEmpty {
            path.removeLast()
        } else {
            parent?.back()
        }
    }

    // MARK: - Back (N màn)
    /// Pop N màn. Nếu stack hiện tại ít hơn N → pop hết rồi delegate remaining lên parent.
    public func back(count: Int) {
        guard count > 0 else { return }
        let available = min(count, path.count)
        if available > 0 { path.removeLast(available) }
        let remaining = count - available
        if remaining > 0 { parent?.back(count: remaining) }
    }

    // MARK: - Back (về màn cụ thể)
    /// Tìm `route` trong stack theo `priority`, pop về màn đó.
    ///
    /// - `.childFirst` (default): tìm trong stack này trước.
    ///   Nếu không thấy → tìm tiếp trong parent stack.
    ///
    /// - `.parentFirst`: tìm trong parent stack trước.
    ///   Nếu không thấy → tìm trong stack này.
    ///
    /// Parent stack dùng predicate `Any`-based để tránh generic type conflict.
    /// Nếu parent có Route type khác → predicate tự động miss → graceful fallback.
    public func back(to route: Route, priority: NavigationSearchPriority = .childFirst) {
        switch priority {
        case .childFirst:
            if popToLastOccurrence(of: route) { return }
            parent?.backToFirst { ($0 as? Route) == route }

        case .parentFirst:
            if parent?.backToFirst(where: { ($0 as? Route) == route }) == true { return }
            popToLastOccurrence(of: route)
        }
    }

    // MARK: - Pop to root

    /// Pop toàn bộ stack hiện tại.
    /// - Parameter includingParent: nếu true, parent cũng bị pop toàn bộ.
    public func popToRoot(includingParent: Bool = false) {
        path.removeAll()
        if includingParent { parent?.popToRoot() }
    }

    public func popToRoot() {
        path.removeAll()
    }

    // MARK: - AnyNavigationStack (type-erased, dùng bởi child)

    @discardableResult
    public func backToFirst(where predicate: (Any) -> Bool) -> Bool {
        guard let lastIndex = path.indices.reversed()
            .first(where: { predicate(path[$0]) })
        else { return false }
        path = Array(path.prefix(lastIndex + 1))
        return true
    }

    public func contains(where predicate: (Any) -> Bool) -> Bool {
        path.contains { predicate($0) }
    }

    // MARK: - Persistence

    /// Lưu path hiện tại vào UserDefaults (nếu có cacheKey).
    public func save() {
        guard let key = cacheKey,
              let data = try? JSONEncoder().encode(path)
        else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    /// Xoá cache đã lưu.
    public func clearCache() {
        guard let key = cacheKey else { return }
        UserDefaults.standard.removeObject(forKey: key)
    }

    // MARK: - Private

    @discardableResult
    private func popToLastOccurrence(of route: Route) -> Bool {
        guard let index = path.lastIndex(of: route) else { return false }
        path = Array(path.prefix(index + 1))
        return true
    }

    private func load(key: String) {
        guard let data = UserDefaults.standard.data(forKey: key),
              let saved = try? JSONDecoder().decode([Route].self, from: data)
        else { return }
        path = saved
    }
}
