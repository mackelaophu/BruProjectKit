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
        .file(path: "Workspace.swift", templatePath: "Stencils/Workspace.stencil"),
        .string(
            path: "Tuist.swift",
            contents: """
            import ProjectDescription

            let tuist = Tuist(project: .tuist())
            """
        ),
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
        .directory(path: "Targets/Common", sourcePath: "Sources/Common"),
        // AdapfitImage.swift gốc đã bị loại khỏi thư mục Common được bundle sẵn (Sources/Common) —
        // sinh riêng ở đây để đổi tên file theo {{ name }}Image.swift (đã chốt, xem NOTES.md).
        .file(path: "Targets/Common/Sources/\(nameAttribute)Image.swift", templatePath: "Stencils/AppImage.stencil"),
        .directory(path: "Targets/UICore", sourcePath: "Sources/UICore"),
        .directory(path: "Targets/\(nameAttribute)Network", sourcePath: "Sources/Network"),
        // SocketService bản "trần" (đã bỏ phần OTTHandler/OTTItem/OTTType riêng của OTT) — chỉ
        // thật sự có nội dung khi includeRealtimeSocket = true, xem ghi chú trong stencil.
        .file(path: "Targets/\(nameAttribute)Network/Sources/SocketService.swift", templatePath: "Stencils/SocketService.stencil"),

        // MARK: Cơ chế scaffold module con — mang nguyên convention hiện có của AdapfitV2
        .directory(path: "Tuist/Templates/Module", sourcePath: "Sources/TuistTemplates/Module"),
        .directory(path: "Tuist/Templates/ChildModule", sourcePath: "Sources/TuistTemplates/ChildModule"),
        .directory(path: ".", sourcePath: "Sources/GenerateScripts"),

        // MARK: Main app skeleton
        .file(path: "\(nameAttribute)/Sources/\(nameAttribute)App.swift", templatePath: "Stencils/App.stencil"),
        .file(path: "\(nameAttribute)/Sources/AppDelegate.swift", templatePath: "Stencils/AppDelegate.stencil"),
        .file(path: "\(nameAttribute)/Sources/AppRouter.swift", templatePath: "Stencils/AppRouter.stencil"),
        .file(path: "\(nameAttribute)/Sources/AppConfig.swift", templatePath: "Stencils/AppConfig.stencil"),
        .file(path: "\(nameAttribute)/\(nameAttribute).entitlements", templatePath: "Stencils/App.entitlements"),

        // MARK: Feature mẫu Home — copy nguyên vẹn, HomeView.swift đã đổi thành bản trống (không còn
        // Chart/Exercises/Team/Settings) để project mới build được ngay.
        .directory(path: "\(nameAttribute)/Sources/Home", sourcePath: "Sources/Home"),

        // MARK: Resource rỗng
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
