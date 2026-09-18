import ProjectDescription

// MARK: - Attributes
// name: bắt buộc — dùng cho Project/Workspace name, tên folder app, tên target Network ({{ name }}Network)
//       và tên file ({{ name }}Image.swift, {{ name }}App.swift...).
let nameAttribute: Template.Attribute = .required("name")

// organizationName / bundleIdPrefix: mặc định giữ theo AdapfitV2 ("Bru" / "com.bru") — đổi được khi cần.
let organizationNameAttribute: Template.Attribute = .optional("organizationName", default: "Bru")
let bundleIdPrefixAttribute: Template.Attribute = .optional("bundleIdPrefix", default: "com.bru")

// developmentTeam: để rỗng làm placeholder — mỗi lần scaffold tự điền qua tham số --development-team.
let developmentTeamAttribute: Template.Attribute = .optional("developmentTeam", default: "")

// includeFirebase / includeRealtimeSocket: bật/tắt phần cấu hình vốn gắn với nghiệp vụ Adapfit
// (push notification qua Firebase, kết nối realtime qua SocketService) — mặc định tắt cho base template.
let includeFirebaseAttribute: Template.Attribute = .optional("includeFirebase", default: .boolean(false))
let includeRealtimeSocketAttribute: Template.Attribute = .optional("includeRealtimeSocket", default: .boolean(false))

let template = Template(
    description: "Tạo project iOS mới với bộ khung Tuist multi-module giống AdapfitV2 (Common + UICore + {{ name }}Network + cơ chế AppRouter), không kèm feature nghiệp vụ riêng của Adapfit.",
    attributes: [
        nameAttribute,
        organizationNameAttribute,
        bundleIdPrefixAttribute,
        developmentTeamAttribute,
        includeFirebaseAttribute,
        includeRealtimeSocketAttribute
    ],
    items: [
        // MARK: Cấu hình gốc Tuist
        .file(path: "Project.swift", templatePath: "Stencils/Project.stencil"),
        // Tuist.swift KHÔNG được sinh ở đây: thư mục đích buộc phải có sẵn Tuist.swift (khai báo
        // plugin BruProjectKit) TRƯỚC khi `tuist install`/`tuist scaffold` chạy được — Tuist không
        // cho phép template ghi đè file đã tồn tại (renamex_np "File exists"). Nên Tuist.swift giữ
        // nguyên bản có khai báo plugin sau khi scaffold; xem README.md để lấy lệnh dọn về bản sạch.
        .file(path: "Workspace.swift", templatePath: "Stencils/Workspace.stencil"),
        .file(path: "Tuist/Package.swift", templatePath: "Stencils/Package.stencil"),
        .string(
            path: "Tuist/Configs/Shared.xcconfig",
            contents: """
            // Cấu hình chung cho toàn bộ app
            APP_VERSION = 1.0.0
            APP_BUILD_NUMBER = 1
            SWIFT_VERSION = 6.0

            // Cấu hình Base URL mặc định (có thể bị ghi đè ở môi trường cụ thể)
            API_BASE_URL = https:\\/\\/api.default.com
            """
        ),
        .file(path: "Tuist/Configs/SIT.xcconfig", templatePath: "Stencils/SIT.xcconfig.stencil"),
        .file(path: "Tuist/Configs/PROD.xcconfig", templatePath: "Stencils/PROD.xcconfig.stencil"),

        // MARK: Module dùng chung — copy nguyên vẹn từ AdapfitV2, không templating bên trong
        // LƯU Ý cơ chế .directory(path:sourcePath:): Tuist copy sourcePath NHƯ MỘT THƯ MỤC CON có
        // tên = basename(sourcePath) nằm bên trong path (path đóng vai trò thư mục CHA), tức là
        // .directory(path: "Targets/Common", sourcePath: "Sources/Common") sẽ tạo ra
        // "Targets/Common/Common/**" (thừa 1 cấp) chứ không phải "Targets/Common/**" như tưởng —
        // đã phát hiện qua lỗi `tuist generate` thật. Vì vậy path ở đây phải là thư mục CHA
        // ("Targets"), không phải chính thư mục đích.
        .directory(path: "Targets", sourcePath: "Sources/Common"),
        // AdapfitImage.swift gốc đã bị loại khỏi thư mục Common được bundle sẵn (Sources/Common) —
        // sinh riêng ở đây để đổi tên file theo {{ name }}Image.swift (đã chốt, xem NOTES.md).
        .file(path: "Targets/Common/Sources/\(nameAttribute)Image.swift", templatePath: "Stencils/AppImage.stencil"),
        .directory(path: "Targets", sourcePath: "Sources/UICore"),
        // Target Network có tên động ({{ name }}Network) nên KHÔNG dùng .directory được (basename
        // thư mục bundle sẵn là "Network", không thể đổi thành tên động lúc scaffold) — liệt kê
        // trực tiếp từng file thay vì copy cả thư mục. Sources/Network chỉ có đúng 1 file thật là
        // Network.swift (Resources/Tests/Previews rỗng, không có file nào — xem NOTES.md); vẫn cần
        // tạo sẵn thư mục Resources rỗng vì Project.swift khai báo resources glob cho target này,
        // Tuist sẽ báo lỗi "directory does not exist" khi generate nếu thư mục đó không tồn tại.
        .file(path: "Targets/\(nameAttribute)Network/Sources/Network.swift", templatePath: "Sources/Network/Sources/Network.swift"),
        .string(path: "Targets/\(nameAttribute)Network/Resources/.gitkeep", contents: ""),
        // SocketService bản "trần" (đã bỏ phần OTTHandler/OTTItem/OTTType riêng của OTT) — chỉ
        // thật sự có nội dung khi includeRealtimeSocket = true, xem ghi chú trong stencil.
        .file(path: "Targets/\(nameAttribute)Network/Sources/SocketService.swift", templatePath: "Stencils/SocketService.stencil"),

        // MARK: Cơ chế scaffold module con — mang nguyên convention hiện có của AdapfitV2
        // (cùng lý do path=thư mục cha như ở trên)
        .directory(path: "Tuist/Templates", sourcePath: "Sources/TuistTemplates/Module"),
        .directory(path: "Tuist/Templates", sourcePath: "Sources/TuistTemplates/ChildModule"),
        // generate_*.sh: liệt kê từng file (không dùng .directory) để giữ đúng vị trí gốc — nằm
        // thẳng ở root project, không lồng trong thư mục con nào (giống convention AdapfitV2).
        // .file ghi lại nội dung file (qua Stencil) nên KHÔNG giữ được bit thực thi (+x) gốc —
        // cần chạy `chmod +x generate_*.sh` 1 lần sau khi scaffold xong (đã thêm vào README.md).
        .file(path: "generate_module.sh", templatePath: "Sources/GenerateScripts/generate_module.sh"),
        .file(path: "generate_child_module.sh", templatePath: "Sources/GenerateScripts/generate_child_module.sh"),
        .file(path: "generate_main_feature.sh", templatePath: "Sources/GenerateScripts/generate_main_feature.sh"),
        .file(path: "generate_main_child_feature.sh", templatePath: "Sources/GenerateScripts/generate_main_child_feature.sh"),

        // MARK: Main app skeleton
        .file(path: "\(nameAttribute)/Sources/\(nameAttribute)App.swift", templatePath: "Stencils/App.stencil"),
        .file(path: "\(nameAttribute)/Sources/AppDelegate.swift", templatePath: "Stencils/AppDelegate.stencil"),
        .file(path: "\(nameAttribute)/Sources/AppRouter.swift", templatePath: "Stencils/AppRouter.stencil"),
        .file(path: "\(nameAttribute)/Sources/AppConfig.swift", templatePath: "Stencils/AppConfig.stencil"),
        .file(path: "\(nameAttribute)/\(nameAttribute).entitlements", templatePath: "Stencils/App.entitlements"),
        // RubikLarPetrusTests (Project.stencil) cần "\(name)/Tests/**" tồn tại — AdapfitV2 gốc có
        // sẵn 1 file test rỗng mặc định do Xcode sinh ra, port lại tương ứng ở đây.
        .file(path: "\(nameAttribute)/Tests/\(nameAttribute)Tests.swift", templatePath: "Stencils/AppTests.stencil"),

        // MARK: Feature mẫu Home — copy nguyên vẹn, HomeView.swift đã đổi thành bản trống (không còn
        // Chart/Exercises/Team/Settings) để project mới build được ngay.
        // (cùng lý do path=thư mục cha: "\(nameAttribute)/Sources", không phải ".../Sources/Home")
        .directory(path: "\(nameAttribute)/Sources", sourcePath: "Sources/Home"),

        // MARK: Resource
        .string(
            path: "\(nameAttribute)/Resources/Assets.xcassets/Contents.json",
            contents: """
            {
              "info" : {
                "author" : "xcode",
                "version" : 1
              }
            }
            """
        ),
        // AppIcon placeholder chung (không mang branding/nghiệp vụ Adapfit — đã kiểm tra icon gốc
        // của AdapfitV2 là hình quả tạ + mũi tên, đặc thù riêng cho app fitness nên KHÔNG mang theo).
        // Icon đặt tên cố định "AppIcon.appiconset" (không phụ thuộc {{ name }}) nên dùng được
        // .directory bình thường — path là thư mục cha "Assets.xcassets", đúng quy tắc đã sửa ở trên.
        .directory(path: "\(nameAttribute)/Resources/Assets.xcassets", sourcePath: "Sources/AppIcon/AppIcon.appiconset"),
        .string(
            path: "\(nameAttribute)/Resources/Localizes/en.lproj/Localizable.strings",
            contents: "// English Localized Strings\n"
        ),
        .string(
            path: "\(nameAttribute)/Resources/Localizes/vi.lproj/Localizable.strings",
            contents: "// Vietnamese Localized Strings\n"
        )
    ]
)
