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

## Cập nhật sau khi test thật trên máy (2026-09-18)
- Bug đã gặp & đã sửa:
  1. `.local(path: "../BruProjectKit")` không hoạt động — Tuist không resolve `..` trong
     `.local(path:)` như filesystem thường. Fix: dùng đường dẫn tuyệt đối. Đã cập nhật README.
  2. Sau khi sửa path, `tuist install` "Success" nhưng `tuist scaffold list` không thấy
     `NewProject` — do Tuist cache lại kết quả resolve plugin từ lần chạy path sai trước đó.
     Fix: `tuist clean plugins` trước khi `tuist install` lại. Đã thêm vào README như bước bắt
     buộc khi đổi path plugin.
  3. `tuist scaffold NewProject ...` báo lỗi `File already exists` khi ghi `Tuist.swift` — Tuist
     không cho phép template ghi đè file đã tồn tại, mà `Tuist.swift` (khai báo plugin) buộc phải
     có sẵn trước khi scaffold chạy được. Đã hỏi và được xác nhận: bỏ hẳn item
     `.string(path: "Tuist.swift", ...)` khỏi `NewProject.swift` (manifest), thay bằng bước dọn
     tay sau khi scaffold xong (ghi đè Tuist.swift về bản sạch `Tuist(project: .tuist())`) — xem
     README mục "Cách dùng" bước 8.
- Đã xác nhận chạy thật thành công: `tuist install`, `tuist clean plugins`, `tuist scaffold list`
  (thấy đúng template `NewProject`), `tuist scaffold NewProject --name RubikLarPetrus
  --development-team 32483KQ8R6` render đúng `Project.swift`/`Workspace.swift` (tên, bundleId,
  DEVELOPMENT_TEAM đều đúng) — trước khi gặp lỗi Tuist.swift ở trên (nay đã sửa).
- Chưa xác nhận: `tuist generate` + build thật trên Xcode (chờ bạn chạy nốt sau khi retest).

## Fix bug hệ thống ở .directory (2026-09-18, sau khi tuist generate lỗi thật)
`tuist generate` báo: thư mục `Targets/RubikLarPetrusNetwork/Sources` không tồn tại — điều tra ra
`.directory(path:sourcePath:)` copy sourcePath NHƯ 1 THƯ MỤC CON tên = basename(sourcePath), nằm
BÊN TRONG path (path = thư mục cha), không phải "path = chính thư mục đích" như giả định ban đầu.
Ví dụ thực tế đã thấy: `.directory(path: "Targets/Common", sourcePath: "Sources/Common")` tạo ra
`Targets/Common/Common/**` (thừa 1 cấp), tương tự cho UICore, Network, Tuist/Templates/{Module,
ChildModule}, `{{name}}/Sources/Home`, và cả `generate_*.sh` (bị gom vào 1 thư mục `GenerateScripts/`
thay vì nằm phẳng ở root).

Đã sửa toàn bộ trong `NewProject.swift`:
- Common/UICore/Tuist-Templates/Home: đổi `path` thành thư mục CHA (vd `"Targets"` thay vì
  `"Targets/Common"`) — giữ nguyên `.directory`, không mất quyền thực thi vì các thư mục này không
  có file cần +x.
- `{{name}}Network`: KHÔNG dùng `.directory` được nữa vì basename thư mục bundle sẵn ("Network")
  không thể đổi tên động theo `{{ name }}Network` — chuyển sang liệt kê trực tiếp file
  `Sources/Network.swift` qua `.file`, và thêm `.string(...Resources/.gitkeep...)` để Resources
  (rỗng) vẫn tồn tại (Project.swift có khai báo `resources` glob cho target này).
- `generate_*.sh`: chuyển 4 file sang `.file` để nằm phẳng ở root (đúng convention AdapfitV2) thay
  vì bị `.directory` gom vào thư mục con — đánh đổi: `.file` không giữ được bit thực thi gốc, cần
  `chmod +x` tay 1 lần sau scaffold (đã thêm README bước 9).
- Phát hiện thêm 1 thiếu sót: `RubikLarPetrusTests` (target test) cần `\(name)/Tests/**` tồn tại —
  AdapfitV2 gốc có sẵn 1 file test rỗng do Xcode sinh, đã port sang `Stencils/AppTests.stencil` +
  thêm item `.file(path: "\(name)/Tests/\(name)Tests.swift", ...)`.

Đã xoá cây file cũ trong `RubikLarPetrus/` (Project.swift, Workspace.swift, Tuist/, Targets/,
RubikLarPetrus/, GenerateScripts/) để chạy lại `tuist scaffold` sạch từ đầu — giữ nguyên
`Tuist.swift` (path tuyệt đối đã đúng, không cần sửa lại).

Chưa xác nhận: `tuist scaffold` sau fix này chạy hết toàn bộ item không lỗi, và `tuist generate` +
build Xcode thật (đang chờ bạn chạy lại).

## Bổ sung AppIcon default (2026-09-18, theo yêu cầu "template cần có icon default")
AdapfitV2 gốc có sẵn `AppIcon.appiconset` với icon thật (hình quả tạ + mũi tên tăng trưởng, màu
teal) — đã xem trực tiếp file `1024.png`, xác nhận đây là branding riêng của app fitness Adapfit,
không mang theo vào template base theo đúng nguyên tắc loại bỏ nghiệp vụ riêng.

Đã tạo icon placeholder trung tính (nền xanh lam đậm + 2 vòng tròn lồng nhau màu trắng, không có
chữ/logo cụ thể nào) bằng script Python, generate đủ 37 kích thước + `Contents.json` y hệt cấu
trúc/idiom của AdapfitV2 gốc (iphone/ipad/mac/watch/ios-marketing/watch-marketing — giữ đúng
"giống cấu trúc" dù nội dung ảnh khác). Bundle tại
`Templates/NewProject/Sources/AppIcon/AppIcon.appiconset/`, gắn vào manifest qua
`.directory(path: "\(name)/Resources/Assets.xcassets", sourcePath: "Sources/AppIcon/AppIcon.appiconset")`
— tên thư mục "AppIcon.appiconset" cố định (không phụ thuộc `{{ name }}`) nên dùng `.directory`
bình thường được, không vướng bug basename như các target động khác.

Chưa xác nhận: `tuist generate` + mở Xcode có hiển thị đúng icon placeholder này không (đang chờ
bạn chạy lại sau khi xoá cây `RubikLarPetrus` cũ và scaffold lại).

## Thêm .gitignore (2026-09-18, theo yêu cầu người dùng)
Đã thêm `.gitignore` (macOS + Xcode + Tuist derived/`Tuist/.build`) do người dùng cung cấp, vào cả:
- Project `RubikLarPetrus` đã gen sẵn (ghi trực tiếp).
- Template: bundle tại `Sources/gitignore-template.txt`, gắn vào manifest qua
  `.file(path: ".gitignore", templatePath: "Sources/gitignore-template.txt")` — item đầu tiên
  trong danh sách items để dễ thấy.

Cũng phát hiện + xử lý 1 vấn đề thực tế: người dùng di chuyển cả `RubikLarPetrus` và `BruProjectKit`
từ `Downloads/AdapfitV2/` sang `Downloads/Projects/` (2 thư mục vẫn là sibling, plugin path tuyệt
đối trong Tuist.swift không còn liên quan vì Tuist.swift đã được dọn về bản sạch — không có plugin
— từ bước 8 trước đó). Lỗi gặp phải: `tuist generate` báo "Couldn't find xcframework" tại ĐƯỜNG DẪN
CŨ — do `Tuist/.build` (cache SwiftPM resolve Lottie) lưu absolute path lúc build, không tự cập
nhật khi thư mục bị di chuyển. Đã xoá `Tuist/.build` + `Derived` + `.xcodeproj`/`.xcworkspace` cũ
tại vị trí mới, ghi chú lại trong README mục "Nếu di chuyển thư mục project sang vị trí khác".

## Fix lỗi Signing "requires a development team" (2026-10-30, phát hiện ở HanziFlash)
Nguyên nhân: khi 1 target (ví dụ app) khai `settings: .settings(base: [...])` mà không có `configurations:`,
Tuist tạo thêm config `Debug` và `Release` mặc định CHỈ cho target đó. 2 config này không thừa hưởng
`DEVELOPMENT_TEAM`/`CODE_SIGN_STYLE` từ settings cấp project → Xcode hiện 2 nhóm Signing, nhóm
"Debug and Release" có Team = None và báo lỗi. Chọn Team bằng tay chỉ tạm thời vì `.xcodeproj` bị sinh lại.
Cách đúng: `configurations: []` (template đã có helper `targetSettings(_:)` trong Project.stencil).
Quy tắc: mọi settings riêng của target phải đi qua `targetSettings([...])`, không viết `.settings(base:)` trần.
Sau khi sửa manifest phải chạy lại `tuist generate` (đóng Xcode trước) mới thấy hiệu lực.
