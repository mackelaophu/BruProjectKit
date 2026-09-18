import SwiftUI
import UICore
import Common

// Đã đổi thành bản trống (giống View mặc định của Tuist/Templates/Module) vì bản gốc
// trong AdapfitV2 là 1 TabView nhúng thẳng ChartRouter/ExercisesRouter/TeamRouter/
// SettingsRouter — toàn bộ module nghiệp vụ đó không có trong base template này.
struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        VStack {
            Text("Welcome to Home")
                .appStyle(.titleLg)
        }
        .overlay(alignment: .top) {
            if let error = viewModel.errorMessage {
                Text(error)
                    .appStyle(.labelMd)
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.red.opacity(0.85))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.easeInOut, value: viewModel.errorMessage)
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(repo: HomeRepository()))
}
