# BruProjectKit

Tuist Plugin chứa template `NewProject` — sinh 1 project iOS mới với bộ khung Tuist
multi-module giống AdapfitV2 (Common + UICore + `{{ name }}Network` + cơ chế AppRouter +
feature mẫu `Home`), không mang theo các module nghiệp vụ riêng của Adapfit
(Login/Chart/NFC/QR/Exercises/Team/Settings/OTT/BehaviorKit).

⚠️ **Lưu ý quan trọng:** repo này được dựng và ghép nối bởi Claude (cả trong sandbox cloud lẫn
qua shell Linux giới hạn trên máy bạn) — **chưa được `tuist install` / `tuist scaffold` /
`tuist generate` / build thử lần nào**, vì môi trường mình chạy lệnh không có Xcode và
không có mạng để tải Tuist CLI. Bạn cần tự chạy các bước ở mục "Cách dùng" bên dưới trên
Terminal thật của máy bạn để xác nhận mọi thứ hoạt động — rất có thể sẽ có lỗi cú pháp
Stencil nhỏ (dấu phẩy thừa/thiếu khi `{% if %}` tắt) cần sửa tay ở lần chạy đầu.

## Cấu trúc

```
BruProjectKit/
├── Plugin.swift                      # khai báo plugin
└── Templates/NewProject/
    ├── NewProject.swift              # manifest: attributes + danh sách item sinh ra
    ├── Stencils/                     # các file có {{ }} / {% if %} cần render
    └── Sources/                      # copy nguyên vẹn, không render (Common/UICore/Network/Home/...)
```

## Attributes

| Attribute | Bắt buộc | Mặc định | Ý nghĩa |
| --- | --- | --- | --- |
| `name` | có | — | Tên project mới, vd `RubikLarPetrus` |
| `organizationName` | không | `Bru` | `Project(organizationName:)` |
| `bundleIdPrefix` | không | `com.bru` | Tiền tố bundle id cho mọi target |
| `developmentTeam` | không | rỗng | Nếu rỗng, bỏ key `DEVELOPMENT_TEAM` |
| `includeFirebase` | không | `false` | Bật/tắt Firebase Core+Messaging + push notification |
| `includeRealtimeSocket` | không | `false` | Bật/tắt `SocketService` (WebSocket, bản đã bỏ phần OTT) |

## Cách dùng (chạy trên Terminal thật của máy bạn, có Xcode + Tuist)

1. Cài Tuist (nếu chưa có), ví dụ qua mise: `mise use -g tuist@4.118.0`
2. Tạo thư mục project mới, hoàn toàn trống:
   ```
   mkdir RubikLarPetrus && cd RubikLarPetrus
   ```
3. Tạo file `Tuist.swift` khai báo plugin — dùng local path lúc đang test:
   ```swift
   import ProjectDescription

   let tuist = Tuist(
     project: .tuist(plugins: [
       .local(path: "../BruProjectKit")
     ])
   )
   ```
   (đường dẫn tương đối trỏ về thư mục `BruProjectKit` bạn vừa nhận — đổi cho khớp vị trí thật.
   Sau khi push `BruProjectKit` lên GitHub, đổi sang `.git(url: "...", tag: "1.0.0")`.)
4. `tuist install`
5. `tuist scaffold NewProject --name RubikLarPetrus --development-team <TEAM_ID_CỦA_BẠN>`
   (thêm `--include-firebase true` / `--include-realtime-socket true` nếu muốn bật)
6. `tuist generate` rồi mở `.xcworkspace`, build thử target `RubikLarPetrus`.

## Việc còn lại / rủi ro đã biết

- Chưa build-test thật (xem cảnh báo ở trên).
- Tuist không hỗ trợ loại bỏ hẳn 1 file theo điều kiện — khi `includeFirebase`/
  `includeRealtimeSocket` tắt, file liên quan vẫn được tạo ra nhưng rỗng (xem
  `Stencils/SocketService.stencil`) — vô hại nhưng hơi "rác" trong cây thư mục, có thể chấp
  nhận được cho bản đầu.
- `Sources/Network/Sources/Network.swift`: dòng comment ví dụ đã đổi `com.bru.adapfit` thành
  `your.bundle.id` — không phải code chạy, chỉ là ví dụ trong comment.
