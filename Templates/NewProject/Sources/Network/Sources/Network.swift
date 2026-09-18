import Foundation
import CryptoKit
import Common

// MARK: - NetworkError

/// Các lỗi có thể xảy ra trong quá trình thực hiện network request.
///
/// Conform `LocalizedError` để hiển thị mô tả lỗi thân thiện qua `errorDescription`.
public enum NetworkError: Error, LocalizedError {
    /// URL không hợp lệ khi kết hợp `path` với `baseURL`.
    case invalidURL

    /// Không thể JSON encode body request.
    ///
    /// - Parameter Error: Lỗi gốc từ `JSONEncoder`.
    case encodingFailed(Error)

    /// Không thể mã hoá body bằng AES-GCM.
    ///
    /// - Parameter Error: Lỗi gốc từ `CryptoKit`.
    case encryptionFailed(Error)

    /// Server trả về HTTP status code ngoài phạm vi 200–299 kèm error body đã decode.
    ///
    /// - Parameters:
    ///   - statusCode: HTTP status code nhận được.
    ///   - serverError: Error body đã decode từ server (nếu parse được).
    ///   - data: Raw response body gốc.
    case requestFailed(statusCode: Int, serverError: ServerErrorBody?, data: Data?)

    /// Không thể JSON decode response thành kiểu `Response` mong muốn.
    ///
    /// - Parameter Error: Lỗi gốc từ `JSONDecoder`.
    case decodingFailed(Error)

    /// Server trả về response body rỗng khi đang chờ dữ liệu.
    case noData

    /// Lỗi không xác định từ `URLSession` hoặc các tầng khác.
    ///
    /// - Parameter Error: Lỗi gốc.
    case unknown(Error)

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .encodingFailed(let e):
            return "Encoding failed: \(e.localizedDescription)"
        case .encryptionFailed(let e):
            return "Encryption failed: \(e.localizedDescription)"
        case .requestFailed(let code, let serverError, _):
            if let message = serverError?.message {
                return message
            }
            return "Request failed with status code: \(code)"
        case .decodingFailed(let e):
            return "Decoding failed: \(e.localizedDescription)"
        case .noData:
            return "No data received"
        case .unknown(let e):
            return "Unknown error: \(e.localizedDescription)"
        }
    }
}

// MARK: - AESEncryptor

/// Mã hoá dữ liệu bằng thuật toán **AES-256-GCM** trước khi gửi lên server.
///
/// ## Thuật toán
/// Sử dụng `AES.GCM` từ Apple `CryptoKit`:
/// - Khoá: 256-bit (32 bytes).
/// - Nonce: 96-bit (12 bytes), tự sinh ngẫu nhiên mỗi lần gọi `encrypt`.
/// - Authentication tag: 128-bit (16 bytes), tích hợp để phát hiện giả mạo.
///
/// ## Định dạng output
/// Output là JSON với cấu trúc:
/// ```json
/// { "data": "<base64(nonce ‖ ciphertext ‖ tag)>" }
/// ```
/// Server cần decode base64, tách 12 bytes đầu làm nonce, 16 bytes cuối làm tag,
/// phần còn lại là ciphertext để giải mã bằng cùng khoá.
///
/// ## Lưu ý bảo mật
/// - Khoá 32 bytes phải được lưu trong Keychain (dùng module `Common.Keychain`), không hardcode.
/// - Mỗi request dùng nonce ngẫu nhiên khác nhau → tránh tấn công replay.
public struct AESEncryptor: Sendable {
    private let key: SymmetricKey

    /// Khởi tạo encryptor với khoá AES-256.
    ///
    /// - Parameter keyData: Khoá đối xứng 32 bytes (AES-256).
    ///   Phải lấy từ Keychain, không được hardcode trong source code.
    /// - Precondition: `keyData.count == 32`. App sẽ crash nếu sai kích thước.
    public init(keyData: Data) {
        precondition(keyData.count == 32, "AES-256 requires a 32-byte key")
        self.key = SymmetricKey(data: keyData)
    }

    /// Mã hoá plaintext bằng AES-256-GCM và trả về JSON payload.
    ///
    /// - Parameter plaintext: Dữ liệu cần mã hoá (thường là JSON body đã encode).
    /// - Returns: `Data` chứa JSON `{ "data": "<base64>" }`.
    /// - Throws: ``NetworkError/encryptionFailed(_:)`` nếu quá trình mã hoá thất bại.
    func encrypt(_ plaintext: Data) throws -> Data {
        do {
            let sealedBox = try AES.GCM.seal(plaintext, using: key)
            // combined = 12-byte nonce ‖ ciphertext ‖ 16-byte tag
            guard let combined = sealedBox.combined else {
                throw CryptoKitError.incorrectParameterSize
            }
            let payload = ["data": combined.base64EncodedString()]
            return try JSONEncoder().encode(payload)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.encryptionFailed(error)
        }
    }
}

// PostRequest và NetworkProtocol được định nghĩa trong Common.
// Xem Common/ModuleInterface.swift.

// MARK: - NetworkClient

/// Concrete implementation của ``NetworkClientProtocol``.
///
/// ## Tính năng
/// - Gửi HTTP POST request với body JSON encode tự động.
/// - **Mã hoá AES-256-GCM tuỳ chọn**: nếu `aesKey` được cung cấp, body JSON sẽ được
///   mã hoá trước khi gửi đi (xem ``AESEncryptor``).
/// - Inject được `URLSession`, `JSONDecoder`, `JSONEncoder` → dễ test.
/// - Dùng `async/await` — không dùng Combine.
///
/// ## Luồng xử lý một request
/// ```
/// PostRequest
///     → JSON encode body
///     → (tuỳ chọn) AES-256-GCM encrypt
///     → URLRequest (POST, Content-Type: application/json)
///     → URLSession.data(for:)
///     → Kiểm tra HTTP status 200–299
///     → JSON decode Response
/// ```
///
/// ## Ví dụ khởi tạo
/// ```swift
/// // Không mã hoá
/// let client = NetworkClient(baseURL: URL(string: "https://api.company.com")!)
///
/// // Có mã hoá AES-256 (lấy key từ Keychain)
/// if let keyData = try? Keychain.load(key: "aes_key", service: "your.bundle.id") {
///     let client = NetworkClient(baseURL: baseURL, aesKey: keyData)
/// }
/// ```
///
/// ## Ví dụ gọi API
/// ```swift
/// struct LoginBody: Encodable { let email: String; let password: String }
/// struct LoginResponse: Decodable { let token: String }
///
/// let response: LoginResponse = try await client.post(
///     PostRequest(path: "/auth/login", body: LoginBody(email: "a@b.com", password: "123"))
/// )
/// ```
public final class NetworkClient: NetworkProtocol {
    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let printDebug: Bool

    /// `AESEncryptor` được khởi tạo từ `aesKey`. `nil` nghĩa là không mã hoá.
    private let encryptor: AESEncryptor?

    /// Khởi tạo `NetworkClient`.
    ///
    /// - Parameters:
    ///   - baseURL: Base URL của API server (ví dụ: `https://api.company.com`).
    ///   - aesKey: Khoá AES-256 (32 bytes) để mã hoá body. `nil` để tắt mã hoá.
    ///     Nên lấy từ Keychain thay vì hardcode.
    ///   - printDebug: Bật/tắt log request và response ra console. Mặc định `false`.
    ///   - session: `URLSession` thực hiện request. Mặc định `.shared`.
    ///   - decoder: `JSONDecoder` để decode response. Mặc định `JSONDecoder()`.
    ///   - encoder: `JSONEncoder` để encode body. Mặc định `JSONEncoder()`.
    public init(
        baseURL: URL,
        aesKey: Data? = nil,
        printDebug: Bool = false,
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.baseURL = baseURL
        self.encryptor = aesKey.map { AESEncryptor(keyData: $0) }
        self.printDebug = printDebug
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }

    private func log(_ message: String) {
        guard printDebug else { return }
        print("[NetworkClient] \(message)")
    }

    /// Thực hiện HTTP POST request.
    ///
    /// Các bước thực thi theo thứ tự:
    /// 1. Tạo `URL` từ `request.path` + `baseURL`.
    /// 2. JSON encode `request.body`.
    /// 3. (Nếu có `encryptor`) AES-256-GCM mã hoá JSON data.
    /// 4. Tạo `URLRequest` với method POST và các header.
    /// 5. Gửi request qua `URLSession`.
    /// 6. Kiểm tra HTTP status code (200–299).
    /// 7. JSON decode response thành `Response`.
    ///
    /// - Parameter request: ``PostRequest`` chứa đầy đủ thông tin request.
    /// - Returns: Response đã decode thành kiểu generic `Response`.
    /// - Throws: ``NetworkError/invalidURL`` nếu URL không hợp lệ.
    ///           ``NetworkError/encodingFailed(_:)`` nếu encode body thất bại.
    ///           ``NetworkError/encryptionFailed(_:)`` nếu mã hoá thất bại.
    ///           ``NetworkError/requestFailed(statusCode:data:)`` nếu status ngoài 200–299.
    ///           ``NetworkError/noData`` nếu response body rỗng.
    ///           ``NetworkError/decodingFailed(_:)`` nếu decode response thất bại.
    public func post<Body: Encodable & Sendable, Response: Decodable>(
        _ request: PostRequest<Body>
    ) async throws -> Response {
        guard let url = URL(string: request.path, relativeTo: baseURL) else {
            throw NetworkError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        for (key, value) in request.headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        // Bước 1: JSON encode body
        let jsonData: Data
        do {
            jsonData = try encoder.encode(request.body)
        } catch {
            throw NetworkError.encodingFailed(error)
        }

        // Bước 2: AES-GCM encrypt nếu có encryptor
        if let encryptor {
            do {
                urlRequest.httpBody = try encryptor.encrypt(jsonData)
            } catch let error as NetworkError {
                throw error
            } catch {
                throw NetworkError.encryptionFailed(error)
            }
        } else {
            urlRequest.httpBody = jsonData
        }

        // Log request
        log("""
            ┌─ REQUEST ────────────────────────────────
            │ POST \(url.absoluteString)
            │ Headers: \(urlRequest.allHTTPHeaderFields ?? [:])
            │ Body: \(String(data: jsonData, encoding: .utf8) ?? "<binary>")
            └──────────────────────────────────────────
            """)

        let (data, response) = try await session.data(for: urlRequest)

        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1

        // Log response
        log("""
            ┌─ RESPONSE ───────────────────────────────
            │ POST \(url.absoluteString)
            │ Status: \(statusCode)
            │ Body: \(String(data: data, encoding: .utf8) ?? "<binary>")
            └──────────────────────────────────────────
            """)

        if !(200..<300).contains(statusCode) {
            let serverError = try? JSONDecoder().decode(ServerErrorBody.self, from: data)
            throw NetworkError.requestFailed(statusCode: statusCode, serverError: serverError, data: data)
        }

        guard !data.isEmpty else {
            throw NetworkError.noData
        }

        do {
            return try decoder.decode(Response.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}
