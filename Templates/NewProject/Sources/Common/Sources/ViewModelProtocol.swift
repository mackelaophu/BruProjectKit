
import SwiftUI
@MainActor
public protocol ViewModelProtocol {
    associatedtype Repo: RepoProtocol
    var repo: Repo { get }
}
@MainActor
open class BaseViewModel: ObservableObject {
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil
    public init() {
        
    }
    public func post<Body: Encodable & Sendable, Response: Decodable & Sendable>(repo: RepoProtocol,
        _ request: PostRequest<Body>
    ) async -> Response? {
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            let resp: Response = try await repo.post(request)
            return resp
        } catch {
            errorMessage = error.localizedDescription
        }
        return nil
    }
}
