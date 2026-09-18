import Foundation
import Common

@MainActor
public class HomeDI {
    public static let shared = HomeDI()
    private let container = DIContainer()

    func resolve<T>(_ type: T.Type) -> T {
        container.resolve(type)
    }

    public func registers(network: NetworkProtocol) {
        container.register(HomeViewModel.self, scope: .transient) {
            HomeViewModel(repo: HomeRepository(networkService: network))
        }
    }
}
