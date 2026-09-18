import SwiftUI
import Common

@MainActor
public class HomeRouter {
    public init(){}

    public func initView() -> some View {
        let vm = HomeDI.shared.resolve(HomeViewModel.self)

        return HomeRootView(
            viewModel: vm
        )
    }
}

@MainActor
@ViewBuilder
public func homeDestination(for route: AppRoute) -> some View {
    switch route {
    // case .someRoute:
    //     // TODO: SomeRouter(nav: nav).initView()
    //     Text("Some Route")
    default:
        homeDefaultDestination(for: route)
    }
}

@MainActor
@ViewBuilder
private func homeDefaultDestination(for route: AppRoute) -> some View {
    if route.isParamsRoute {
        homeParamsRouteDestination(for: route.rawValue)
    } else {
        // Fallback an toàn nếu có route rác
        Text("Màn hình không tồn tại")
    }
}

@MainActor
@ViewBuilder
private func homeParamsRouteDestination(for path: String) -> some View {
    if let route = decodeRouteQueryParams(path),
       route.path == "home", route.function == "example_function",
       let someParam = route.param("param_name") {
        // TODO: ExampleRouter(param: someParam, nav: nav).initView()
        Text("Example Function: \(someParam)")
    } else {
        Text("Lỗi: Không đúng định dạng URL")
    }
}
