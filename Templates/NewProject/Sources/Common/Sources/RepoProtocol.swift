import Foundation

// @MainActor vì mọi repo đều được gọi từ ViewModel (@MainActor).
// Đảm bảo toàn bộ chuỗi ViewModel → Repo → method cùng actor isolation.
@MainActor
open class RepoProtocol {
    public var networkService: NetworkProtocol?
    public init(networkService: NetworkProtocol? = nil) {
        self.networkService = networkService
    }
    public func post<Body: Encodable & Sendable, Response: Decodable>(
        _ request: PostRequest<Body>
    ) async throws -> Response {
        guard let networkService else {
            throw NSError(domain: "network service not found", code: -1, userInfo: [NSLocalizedDescriptionKey: "network service not found"])
    }
        return try await networkService.post(request)
    }
}
