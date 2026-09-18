import Foundation
import Security

// MARK: - KeychainError

/// Các lỗi có thể xảy ra khi thao tác với Keychain.
///
/// Conform `LocalizedError` để cung cấp mô tả lỗi dễ đọc thông qua `errorDescription`.
public enum KeychainError: Error, LocalizedError {
    /// Item với cùng `key` và `service` đã tồn tại trong Keychain.
    /// Trường hợp này thường không xảy ra vì `save` tự xử lý bằng `SecItemUpdate`.
    case duplicateItem

    /// Không tìm thấy item trong Keychain ứng với `key` và `service` được cung cấp.
    case itemNotFound

    /// Dữ liệu lấy từ Keychain không thể chuyển đổi sang kiểu mong muốn
    /// (ví dụ: `Data` không decode được thành `String` UTF-8).
    case invalidData

    /// Keychain trả về mã lỗi hệ thống không xác định.
    ///
    /// - Parameter OSStatus: Mã lỗi gốc từ Security framework.
    ///   Tra cứu tại: https://www.osstatus.com
    case unexpectedStatus(OSStatus)

    public var errorDescription: String? {
        switch self {
        case .duplicateItem:
            return "Keychain item already exists"
        case .itemNotFound:
            return "Keychain item not found"
        case .invalidData:
            return "Invalid data retrieved from Keychain"
        case .unexpectedStatus(let status):
            return "Keychain error with OSStatus: \(status)"
        }
    }
}

// MARK: - Keychain

/// Wrapper an toàn cho Keychain Services API của Apple.
///
/// ## Tính năng
/// - Lưu, đọc, xoá dữ liệu nhạy cảm (`Data` hoặc `String`) khỏi Keychain thiết bị.
/// - **Không đồng bộ iCloud**: tất cả item được tạo với `kSecAttrSynchronizable = false`,
///   đảm bảo dữ liệu chỉ tồn tại trên thiết bị vật lý hiện tại.
/// - **Mức bảo vệ cao nhất**: `kSecAttrAccessibleWhenUnlockedThisDeviceOnly` —
///   item chỉ đọc được khi thiết bị đã mở khoá và không thể migrate qua backup/restore.
///
/// ## Cách dùng
/// ```swift
/// let service = "com.bru.adapfit"
///
/// // Lưu token
/// try Keychain.save("my-token", key: "auth_token", service: service)
///
/// // Đọc token
/// let token = try Keychain.loadString(key: "auth_token", service: service)
///
/// // Xoá token
/// try Keychain.delete(key: "auth_token", service: service)
/// ```
///
/// ## Lưu ý
/// - `key` là định danh duy nhất trong phạm vi `service`. Nên dùng hằng số để tránh lỗi chính tả.
/// - `service` nên là Bundle ID của app (ví dụ: `"com.bru.adapfit"`).
public enum Keychain {

    // MARK: - Save

    /// Lưu dữ liệu thô (`Data`) vào Keychain.
    ///
    /// Nếu item với cùng `key` + `service` đã tồn tại, dữ liệu sẽ được **cập nhật** tự động
    /// thay vì throw lỗi `duplicateItem`.
    ///
    /// - Parameters:
    ///   - data: Dữ liệu cần lưu trữ an toàn.
    ///   - key: Định danh duy nhất của item trong phạm vi `service`.
    ///   - service: Tên service phân nhóm các item (thường là Bundle ID).
    /// - Throws: ``KeychainError/unexpectedStatus(_:)`` nếu Keychain trả về lỗi hệ thống.
    public static func save(_ data: Data, key: String, service: String) throws {
        let query = baseQuery(key: key, service: service)

        var addAttributes = query
        addAttributes[kSecValueData as String] = data
        addAttributes[kSecAttrSynchronizable as String] = kCFBooleanFalse
        addAttributes[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlockedThisDeviceOnly

        let addStatus = SecItemAdd(addAttributes as CFDictionary, nil)

        switch addStatus {
        case errSecSuccess:
            return
        case errSecDuplicateItem:
            // Item đã tồn tại → cập nhật giá trị mới
            let updateAttributes: [String: Any] = [kSecValueData as String: data]
            let updateStatus = SecItemUpdate(query as CFDictionary, updateAttributes as CFDictionary)
            guard updateStatus == errSecSuccess else {
                throw KeychainError.unexpectedStatus(updateStatus)
            }
        default:
            throw KeychainError.unexpectedStatus(addStatus)
        }
    }

    /// Lưu chuỗi văn bản (`String`) vào Keychain dưới dạng UTF-8.
    ///
    /// Là convenience wrapper của ``save(_:key:service:)-data``.
    ///
    /// - Parameters:
    ///   - string: Chuỗi cần lưu (token, password, v.v.).
    ///   - key: Định danh duy nhất của item trong phạm vi `service`.
    ///   - service: Tên service phân nhóm các item.
    /// - Throws: ``KeychainError/invalidData`` nếu chuỗi không encode được sang UTF-8.
    ///           ``KeychainError/unexpectedStatus(_:)`` nếu Keychain trả về lỗi hệ thống.
    public static func save(_ string: String, key: String, service: String) throws {
        guard let data = string.data(using: .utf8) else {
            throw KeychainError.invalidData
        }
        try save(data, key: key, service: service)
    }

    // MARK: - Load

    /// Đọc dữ liệu thô (`Data`) từ Keychain.
    ///
    /// - Parameters:
    ///   - key: Định danh của item cần đọc.
    ///   - service: Tên service chứa item.
    /// - Returns: `Data` nếu tìm thấy, `nil` nếu item chưa được lưu.
    /// - Throws: ``KeychainError/invalidData`` nếu kết quả trả về không phải `Data`.
    ///           ``KeychainError/unexpectedStatus(_:)`` nếu Keychain trả về lỗi hệ thống.
    public static func load(key: String, service: String) throws -> Data? {
        var query = baseQuery(key: key, service: service)
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        switch status {
        case errSecSuccess:
            guard let data = result as? Data else {
                throw KeychainError.invalidData
            }
            return data
        case errSecItemNotFound:
            return nil
        default:
            throw KeychainError.unexpectedStatus(status)
        }
    }

    /// Đọc chuỗi văn bản (`String`) từ Keychain (giải mã UTF-8).
    ///
    /// Là convenience wrapper của ``load(key:service:)``.
    ///
    /// - Parameters:
    ///   - key: Định danh của item cần đọc.
    ///   - service: Tên service chứa item.
    /// - Returns: `String` nếu tìm thấy, `nil` nếu item chưa được lưu.
    /// - Throws: ``KeychainError/invalidData`` nếu dữ liệu không decode được sang UTF-8.
    ///           ``KeychainError/unexpectedStatus(_:)`` nếu Keychain trả về lỗi hệ thống.
    public static func loadString(key: String, service: String) throws -> String? {
        guard let data = try load(key: key, service: service) else { return nil }
        guard let string = String(data: data, encoding: .utf8) else {
            throw KeychainError.invalidData
        }
        return string
    }

    // MARK: - Delete

    /// Xoá item khỏi Keychain.
    ///
    /// Không throw lỗi nếu item không tồn tại (`errSecItemNotFound` được bỏ qua).
    ///
    /// - Parameters:
    ///   - key: Định danh của item cần xoá.
    ///   - service: Tên service chứa item.
    /// - Throws: ``KeychainError/unexpectedStatus(_:)`` nếu Keychain trả về lỗi hệ thống.
    public static func delete(key: String, service: String) throws {
        let query = baseQuery(key: key, service: service)
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unexpectedStatus(status)
        }
    }

    // MARK: - Private

    /// Tạo query dictionary dùng chung cho mọi thao tác Keychain.
    ///
    /// Các trường cố định:
    /// - `kSecClass`: `kSecClassGenericPassword` — loại item generic password.
    /// - `kSecAttrAccount`: giá trị `key` — định danh item.
    /// - `kSecAttrService`: giá trị `service` — nhóm item theo app/service.
    /// - `kSecAttrSynchronizable`: `false` — tắt hoàn toàn đồng bộ iCloud.
    private static func baseQuery(key: String, service: String) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: service,
            kSecAttrSynchronizable as String: kCFBooleanFalse as Any
        ]
    }
}
