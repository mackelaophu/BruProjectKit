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
3. Tạo file `Tuist.swift` khai báo plugin — dùng **đường dẫn tuyệt đối** tới `BruProjectKit`
   (Tuist không resolve `..`/đường dẫn tương đối lùi cấp cha trong `.local(path:)` đúng như
   filesystem thông thường, nên bắt buộc dùng path tuyệt đối lúc còn test local):
   ```swift
   import ProjectDescription

   let tuist = Tuist(
     project: .tuist(plugins: [
       .local(path: "/đường/dẫn/tuyệt/đối/tới/BruProjectKit")
     ])
   )
   ```
   (Sau khi push `BruProjectKit` lên GitHub, đổi sang `.git(url: "...", tag: "1.0.0")` — lúc đó
   hết cần lo path tuyệt đối.)
4. `tuist clean plugins` — dọn cache plugin cũ trước khi install. Bước này **quan trọng** nếu
   trước đó bạn từng chạy `tuist install` với path sai/khác — Tuist cache lại kết quả resolve
   plugin, sửa `Tuist.swift` xong mà không clean thì `tuist scaffold list` có thể không thấy
   template dù `tuist install` báo "Success".
5. `tuist install`
6. (khuyến khích) `tuist scaffold list` — kiểm tra template `NewProject` đã xuất hiện trong danh
   sách chưa, trước khi scaffold thật.
7. `tuist scaffold NewProject --name RubikLarPetrus --development-team <TEAM_ID_CỦA_BẠN>`
   (thêm `--include-firebase true` / `--include-realtime-socket true` nếu muốn bật)
8. **Dọn lại `Tuist.swift`** — template **không** tự sinh `Tuist.swift` (xem mục "Vì sao không
   tự động" bên dưới), nên sau khi scaffold xong, file này vẫn là bản có khai báo plugin. Ghi đè
   nó về bản sạch giống hệt `Tuist.swift` gốc của AdapfitV2 bằng lệnh:
   ```
   cat > Tuist.swift <<'EOF'
   import ProjectDescription

   let tuist = Tuist(project: .tuist())
   EOF
   ```
9. **Cấp lại quyền thực thi cho 4 script `generate_*.sh`** — cùng lý do kỹ thuật như bước 8
   (Tuist ghi lại nội dung file qua template nên không giữ được bit `+x` gốc):
   ```
   chmod +x generate_module.sh generate_child_module.sh generate_main_feature.sh generate_main_child_feature.sh
   ```
10. `tuist generate` rồi mở `.xcworkspace`, build thử target `RubikLarPetrus`.

### Vì sao bước 8 phải làm tay, template không tự sinh Tuist.swift

Tuist **không cho phép** một scaffold template ghi đè lên file đã tồn tại sẵn trong thư mục đích
(lỗi thực tế gặp phải: `File already exists: Can't rename '.tmp-xxx' to 'Tuist.swift' ... File
exists`). Mà `Tuist.swift` (khai báo plugin) buộc phải có sẵn từ bước 3 để `tuist install`/
`tuist scaffold` chạy được ngay từ đầu — nên nó luôn "đã tồn tại" khi scaffold chạy tới, không
thể để scaffold tự tạo lại. Đây là giới hạn của Tuist, không phải lỗi ở template này.

### Vì sao script `generate_*.sh` mất quyền thực thi sau khi scaffold, và vì sao `Targets/*Network`
### không dùng `.directory` như `Common`/`UICore`

`Template.Item.directory(path:sourcePath:)` copy **nguyên** thư mục nguồn (giữ cả quyền thực thi)
nhưng lồng nó vào bên trong `path` theo tên chính nó — tức `path` đóng vai trò thư mục **cha**,
không phải chính thư mục đích như tưởng ban đầu (đã sửa lỗi lồng thư mục thừa 1 cấp này ở
`Common`/`UICore`/`Tuist/Templates/*`). Do target `{{ name }}Network` có tên **động** (phụ thuộc
`name` truyền vào), không thể dùng `.directory` cho nó (thư mục bundle sẵn tên cố định là
`Network`) nên phải liệt kê từng file qua `.file(path:templatePath:)` — cách này ghi lại nội dung
qua Stencil nên **không giữ được bit thực thi** gốc. Cùng lý do đó, 4 script `generate_*.sh` (cần
nằm phẳng ở root project, không lồng trong thư mục con) cũng phải chuyển sang `.file` thay vì
`.directory`, nên cũng mất `+x` — xem bước 9 ở trên để cấp lại.

## Nếu di chuyển thư mục project sang vị trí khác

`Tuist/.build` (cache SwiftPM resolve dependency, ví dụ Lottie) lưu đường dẫn tuyệt đối lúc
build — di chuyển cả thư mục project sang chỗ khác mà không xoá cache này sẽ gặp lỗi kiểu
`Couldn't find xcframework at <đường dẫn cũ>/...`. Trước khi `tuist generate` lại ở vị trí mới:
```
rm -rf Tuist/.build Derived *.xcodeproj *.xcworkspace
tuist install
tuist generate
```
(file `.gitignore` sinh sẵn — xem bên dưới — đã loại trừ các thư mục này khỏi git, nhưng chúng
vẫn tồn tại trên đĩa nên phải tự xoá tay khi di chuyển.)

## Việc còn lại / rủi ro đã biết

- Đã build-test thành công phần khung sinh project (`tuist install` + `tuist scaffold list` +
  `tuist scaffold NewProject` chạy được trên máy thật) — còn `tuist generate`/build Xcode thật
  thì bạn cần tự xác nhận nốt.
- Tuist không hỗ trợ loại bỏ hẳn 1 file theo điều kiện — khi `includeFirebase`/
  `includeRealtimeSocket` tắt, file liên quan vẫn được tạo ra nhưng rỗng (xem
  `Stencils/SocketService.stencil`) — vô hại nhưng hơi "rác" trong cây thư mục, có thể chấp
  nhận được cho bản đầu.
- `Sources/Network/Sources/Network.swift`: dòng comment ví dụ đã đổi `com.bru.adapfit` thành
  `your.bundle.id` — không phải code chạy, chỉ là ví dụ trong comment.
- `Tuist.swift` sau khi scaffold cần dọn tay theo bước 8 ở trên (không tự động được, xem lý do).
