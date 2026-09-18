# BruProjectKit — trạng thái hiện tại (spike trong cloud, chưa chạm vào máy bạn)

## Đã xong
- `Plugin.swift` — khai báo plugin.
- `Templates/NewProject/NewProject.swift` — manifest attributes: `name` (required),
  `organizationName`, `bundleIdPrefix`, `developmentTeam` (placeholder), `includeFirebase`,
  `includeRealtimeSocket` (2 cái sau dùng `Template.Attribute.Value.boolean`, đã xác nhận Tuist
  4.118.0 hỗ trợ qua tài liệu chính thức).
- Stencils cho: `Project.swift`, `Workspace.swift`, `Tuist/Package.swift`, `SIT.xcconfig`,
  `PROD.xcconfig`, `{{ name }}App.swift`, `AppDelegate.swift`, `AppRouter.swift`,
  `AppConfig.swift` (verbatim), `{{ name }}.entitlements`.
- `Sources/Home/*` — bundle sẵn 8 file gốc từ AdapfitV2, đã sửa `HomeView.swift` thành bản
  trống (bỏ TabView nhúng Chart/Exercises/Team/Settings).

## Phát hiện mới trong lúc code (chưa có trong plan ban đầu)
1. **`HomeView.swift` gốc không trống** — nó là `TabView` nhúng thẳng
   `ChartRouter`/`ExercisesRouter`/`TeamRouter`/`SettingsRouter`. Đã hỏi và được xác nhận: đổi
   thành bản trống kiểu `View.stencil` mặc định (xong, xem `Sources/Home/HomeView.swift`).
2. **`SocketService` (dùng cho `includeRealtimeSocket`) nằm trong target `OTT` sẽ bị xoá**, và
   nó gọi thẳng `OTTHandler.shared.handlePresentNoti(...)` + dùng `OTTItem`/`OTTType` — toàn bộ
   là logic xử lý push-notification riêng của tính năng OTT, không tách tự động được thành bản
   generic. **Đã chốt:** port bản "trần" — giữ connect/disconnect/send/nhận qua
   `onMessageReceived`/`onDataReceived`, bỏ hẳn `OTTHandler`/`OTTItem`/`OTTType`. Xong ở
   `Stencils/SocketService.stencil`, nối vào `AppRouter.stencil` (import `{{ name }}Network` +
   gọi `SocketService.shared.connect(...)` trong `.onAppear` khi bật `includeRealtimeSocket`).

## Chưa làm (cần copy nguyên vẹn trên máy bạn ở Phase 2, không cần xử lý logic gì)
- `Sources/Common/**` ← copy từ `Targets/Common/**` của AdapfitV2
- `Sources/UICore/**` ← copy từ `Targets/UICore/**`
- `Sources/Network/**` ← copy từ `Targets/AdapfitNetwork/**` (không đổi nội dung file, chỉ đổi
  đường dẫn đích thành `Targets/{{ name }}Network` lúc scaffold)
- `Sources/TuistTemplates/Module`, `Sources/TuistTemplates/ChildModule` ← copy từ
  `Tuist/Templates/Module`, `Tuist/Templates/ChildModule`
- `Sources/GenerateScripts/*.sh` ← copy 4 script `generate_*.sh`

Lý do chưa copy trong spike này: các phần trên copy y nguyên 100%, không có rủi ro kỹ thuật cần
thử trước — để dành làm trực tiếp trên máy bạn bằng `device_bash` (nhanh hơn, không tốn công
đi vòng qua cloud).

## Rủi ro/giới hạn kỹ thuật đã xác minh
- `Template.Item.directory(path:sourcePath:)` **có tồn tại** trong Tuist 4.118.0 — copy nguyên
  thư mục không cần khai từng file. (nguồn: sarunw.com/posts/tuist-template)
- `Template.Attribute.Value.boolean(_:)` **có tồn tại** — dùng được attribute kiểu boolean thật,
  không cần so sánh chuỗi "true"/"false".
- Tuist scaffold **không hỗ trợ loại bỏ hẳn 1 file/thư mục theo điều kiện** (GitHub issue #6862,
  đang mở, chưa làm). Workaround đang dùng: với `includeFirebase`/`includeRealtimeSocket`, bọc
  toàn bộ nội dung trong `{% if %}` ngay trong file Stencil — khi tắt, file vẫn được tạo ra
  nhưng rỗng/vô hại (không phải không tạo file).
- Chưa thể `tuist install`/`tuist scaffold` thật trong sandbox cloud này để build-test (mạng
  cloud không cho tải Tuist CLI, và Tuist vốn cần macOS để generate/build .xcodeproj) — việc
  build-test thật sẽ làm ở Phase 7 trên máy bạn.
