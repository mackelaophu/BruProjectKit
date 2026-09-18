import Foundation
import Common

protocol HomeViewModelProtocol: AnyObject {
    // Add viewmodel methods here
}

class HomeViewModel: BaseViewModel, ViewModelProtocol, HomeViewModelProtocol {
    let repo: HomeRepository

    init(repo: HomeRepository) {
        self.repo = repo
    }
}
