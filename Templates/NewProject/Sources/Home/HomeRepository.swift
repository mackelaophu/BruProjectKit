import Foundation
import Common

@MainActor
public protocol HomeRepoProtocol {
    // Add protocol methods here
}

@MainActor
class HomeRepository: RepoProtocol, HomeRepoProtocol {
    // Add implementation here
}
