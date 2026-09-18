import ProjectDescription

let nameAttribute: Template.Attribute = .required("name")

let template = Template(
    description: "Template for generating a new module with DI, Route, View, ViewModel, Repository, RootView, and Router.",
    attributes: [
        nameAttribute
    ],
    items: [
        .file(
            path: "Targets/\(nameAttribute)/Sources/\(nameAttribute)DI.swift",
            templatePath: "DI.stencil"
        ),
        .file(
            path: "Targets/\(nameAttribute)/Sources/\(nameAttribute)ViewModel.swift",
            templatePath: "ViewModel.stencil"
        ),
        .file(
            path: "Targets/\(nameAttribute)/Sources/\(nameAttribute)Repository.swift",
            templatePath: "Repository.stencil"
        ),
        .file(
            path: "Targets/\(nameAttribute)/Sources/\(nameAttribute)View.swift",
            templatePath: "View.stencil"
        ),
        .file(
            path: "Targets/\(nameAttribute)/Sources/\(nameAttribute)RootView.swift",
            templatePath: "RootView.stencil"
        ),
        .file(
            path: "Targets/\(nameAttribute)/Sources/\(nameAttribute)Route.swift",
            templatePath: "Route.stencil"
        ),
        .file(
            path: "Targets/\(nameAttribute)/Sources/\(nameAttribute)Router.swift",
            templatePath: "Router.stencil"
        ),
        .file(
            path: "Targets/\(nameAttribute)/Sources/\(nameAttribute)+NetworkPath.swift",
            templatePath: "NetworkPath.stencil"
        ),
        .string(
            path: "Targets/\(nameAttribute)/Resources/Assets.xcassets/Contents.json",
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
            path: "Targets/\(nameAttribute)/Resources/Localizes/en.lproj/Localizable.strings",
            contents: "// English Localized Strings\n"
        ),
        .string(
            path: "Targets/\(nameAttribute)/Resources/Localizes/vi.lproj/Localizable.strings",
            contents: "// Vietnamese Localized Strings\n"
        ),
        .file(
            path: "Targets/\(nameAttribute)/Tests/\(nameAttribute)Tests.swift",
            templatePath: "Tests.stencil"
        )
    ]
)
