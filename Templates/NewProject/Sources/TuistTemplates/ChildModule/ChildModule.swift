import ProjectDescription

let nameAttribute: Template.Attribute = .required("name")
let parentModuleAttribute: Template.Attribute = .required("parentModule")

let template = Template(
    description: "Template for generating a new module with DI, Route, View, ViewModel, Repository, RootView, and Router.",
    attributes: [
        nameAttribute,
        parentModuleAttribute
    ],
    items: [
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
            path: "Targets/\(nameAttribute)/Sources/\(nameAttribute)Router.swift",
            templatePath: "Router.stencil"
        ),
    ]
)
