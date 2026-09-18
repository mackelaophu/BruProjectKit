import Foundation

public enum DIScope {
    case transient   // mỗi lần resolve → new instance
    case singleton   // giữ 1 instance duy nhất
}

private struct DIEntry {
    let factory: () -> Any
    let scope: DIScope
    var instance: Any?
}

@MainActor
open class DIContainer {

    public init() {}

    // ObjectIdentifier(T.self) — hash của metatype descriptor.
    // Unique per type theo compiler, không cần string key, không collision,
    // hoạt động đúng với generic types (LoginViewModel vs LoginViewModel<T>).
    private var entries: [ObjectIdentifier: DIEntry] = [:]

    open func register<T>(
        _ type: T.Type,
        scope: DIScope = .transient,
        factory: @escaping @MainActor () -> T
    ) {
        let key = ObjectIdentifier(type)
        entries[key] = DIEntry(factory: factory, scope: scope, instance: nil)
    }

    public func resolve<T>(_ type: T.Type) -> T {
        let key = ObjectIdentifier(type)

        guard var entry = entries[key] else {
            assertionFailure("❌ No registration for \(type)")
            fatalError("❌ No registration for \(type)")
        }

        switch entry.scope {
        case .transient:
            guard let obj = entry.factory() as? T else {
                assertionFailure("❌ Type mismatch for \(type)")
                fatalError("❌ Type mismatch for \(type)")
            }
            return obj

        case .singleton:
            if let cached = entry.instance as? T {
                return cached
            }
            guard let obj = entry.factory() as? T else {
                assertionFailure("❌ Type mismatch for \(type)")
                fatalError("❌ Type mismatch for \(type)")
            }
            entry.instance = obj
            entries[key] = entry
            return obj
        }
    }
}
