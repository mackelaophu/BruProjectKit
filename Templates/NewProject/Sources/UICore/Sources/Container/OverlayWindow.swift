//
//  OverlayWindow.swift
//  Adapfit
//
//  Vấn đề: popup/loading gắn qua `.overlay()` ở gốc WindowGroup không thể
//  nổi lên trên `.sheet()` / `.fullScreenCover()` (vd M3BottomSheet), vì
//  các presentation này được UIKit trình bày (present) đè lên toàn bộ
//  view hierarchy của root view controller — trong khi `.overlay()` vẫn
//  là 1 phần của chính view hierarchy đó, nên luôn bị presented view vẽ
//  đè lên trên, bất kể thứ tự modifier trong code.
//
//  Giải pháp: tạo 1 UIWindow thứ hai với windowLevel cao hơn window
//  chính, chỉ dùng để hiển thị popup/loading. UIWindow là 1 layer hoàn
//  toàn tách biệt với view hierarchy bên trong window chính (kể cả các
//  view controller được present), nên luôn vẽ đè lên trên bất kể sheet/
//  alert nào đang hiển thị. `PassthroughWindow` cho phép touch "xuyên
//  qua" các vùng trống (không có nội dung SwiftUI nào được vẽ) để rơi
//  xuống window chính, nên window này không chặn tương tác khi không có
//  popup nào đang hiện.
//

import SwiftUI
import UIKit
import Combine

/// Hosting controller nền trong suốt để không che UI phía dưới khi
/// không có nội dung nào được vẽ.
final class PassthroughHostingController<Content: View>: UIHostingController<Content> {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
}

/// UIWindow cho phép touch xuyên qua vùng trống của nó (không có nội
/// dung SwiftUI nào được vẽ tại điểm chạm) để rơi xuống window bên
/// dưới. Chỉ điểm chạm trúng nội dung thực sự (popup card, nút bấm,
/// scrim loading...) mới bị window này giữ lại.
final class PassthroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event) else { return nil }
        return rootViewController?.view == hitView ? nil : hitView
    }
}

/// Quản lý vòng đời của overlay window chứa popup/loading toàn app.
/// Gắn 1 lần vào scene hiện tại; nội dung bên trong tự cập nhật vì
/// `PopupManager` được inject qua `.environmentObject()` (reference type).
@MainActor
public final class OverlayWindowController: ObservableObject {
    private var overlayWindow: UIWindow?

    public init() {}

    /// Gắn overlay window vào 1 `UIWindowScene` cụ thể. Gọi nhiều lần
    /// vô hại (chỉ tạo window ở lần gọi đầu tiên).
    public func attach<Content: View>(to scene: UIWindowScene, @ViewBuilder content: () -> Content) {
        guard overlayWindow == nil else { return }

        let hosting = PassthroughHostingController(rootView: content())
        hosting.view.backgroundColor = .clear

        let window = PassthroughWindow(windowScene: scene)
        window.backgroundColor = .clear
        window.rootViewController = hosting
        // Cao hơn cả .alert để chắc chắn nổi trên mọi sheet/fullScreenCover/UIAlertController.
        // (UIWindow.Level là typealias của CGFloat nên cộng thẳng số là hợp lệ.)
        window.windowLevel = .alert + 1
        window.isHidden = false

        overlayWindow = window
    }

    /// Tự tìm scene đang active để gắn vào — dùng trong `.onAppear` ở
    /// root view, thời điểm app đã có `UIWindowScene`.
    public func attachToActiveScene<Content: View>(@ViewBuilder content: () -> Content) {
        guard overlayWindow == nil else { return }
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        guard let scene = scenes.first(where: { $0.activationState == .foregroundActive }) ?? scenes.first else {
            return
        }
        attach(to: scene, content: content)
    }
}
