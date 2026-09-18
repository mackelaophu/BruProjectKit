import SwiftUI
import Common

struct HomeRootView: View {

    @StateObject var viewModel: HomeViewModel

    init(
        viewModel: HomeViewModel
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        HomeView(
            viewModel: viewModel
        )
    }
}
