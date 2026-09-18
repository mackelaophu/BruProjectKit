import Foundation

// MARK: - Network interface

/// PostRequest và NetworkProtocol nằm ở Common để feature modules
/// dùng network mà không cần import Network framework.
public struct PostRequest<Body: Encodable & Sendable>: Sendable {
    /// Đường dẫn endpoint tương đối, sẽ được ghép với `baseURL` trong `NetworkClient`.
    ///
    /// Ví dụ: `"/auth/login"`, `"/user/profile"`.
    public let path: String

    /// Dữ liệu body của request, sẽ được JSON encode trước khi gửi.
    public let body: Body

    /// HTTP headers bổ sung cho request này.
    ///
    /// Các header mặc định (`Content-Type`, `Accept`) luôn được đặt bởi `NetworkClient`.
    /// Dùng để truyền thêm header đặc thù như `Authorization`, `X-App-Version`, v.v.
    public let headers: [String: String]

    /// Khởi tạo một POST request.
    ///
    /// - Parameters:
    ///   - path: Endpoint tương đối (ví dụ: `"/auth/login"`).
    ///   - body: Body payload conform `Encodable`.
    ///   - headers: Custom headers bổ sung (mặc định rỗng).
    public init(path: String, body: Body, headers: [String: String] = [:]) {
        self.path = path
        self.body = body
        self.headers = headers
    }
}

public protocol NetworkProtocol: Sendable {
    /// Thực hiện HTTP POST request và trả về response đã decode.
    ///
    /// - Parameter request: ``PostRequest`` chứa path, body, và headers.
    /// - Returns: Response decode thành kiểu `Response`.
    /// - Throws: ``NetworkError`` nếu bất kỳ bước nào thất bại.
    func post<Body: Encodable & Sendable, Response: Decodable>(
        _ request: PostRequest<Body>
    ) async throws -> Response
}
// MARK: - ServerErrorBody

/// Error body trả về từ server theo định dạng chuẩn.
///
/// Ví dụ: `{"code": 5, "message": "User not found", "details": []}`
public struct ServerErrorBody: Decodable {
    public let code: Int
    public let message: String
}
