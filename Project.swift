import ProjectDescription

let projectName = "Rouzzle"
let organizationName = "Garden"

let appSettings: Settings = .settings(
    base: [
        "MARKETING_VERSION": "1.0",
        "CURRENT_PROJECT_VERSION": "1"
    ],
    configurations: [
        .debug(name: "Debug", xcconfig: "Configs/Secrets.xcconfig"),
        .release(name: "Release", xcconfig: "Configs/Secrets.xcconfig")
    ]
)

let resources: ResourceFileElements = ["Resources/**"]

// MARK: - Project

let project = Project(
    name: projectName,
    organizationName: organizationName,
    packages: [
        .remote(url: "https://github.com/hmlongco/Factory.git", requirement: .upToNextMajor(from: "2.5.1")),
        .remote(url: "https://github.com/onevcat/Kingfisher.git", requirement: .upToNextMajor(from: "7.0.0"))
    ],
    settings: appSettings,
    targets: [
        // App
        .target(
            name: "Rouzzle",
            destinations: .iOS,
            product: .app,
            bundleId: "com.Garden.Rouzzle",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(
                    with: [
                        "UILaunchScreen": [
                            "UIColorName": "",
                            "UIImageName": "",
                        ],
                        "UIAppFonts": [
                            "Pretendard-Black.otf",
                            "Pretendard-Bold.otf",
                            "Pretendard-ExtraBold.otf",
                            "Pretendard-ExtraLight.otf",
                            "Pretendard-Light.otf",
                            "Pretendard-Medium.otf",
                            "Pretendard-Regular.otf",
                            "Pretendard-SemiBold.otf",
                            "Pretendard-Thin.otf",
                            "Halo Dek.otf"
                        ],
                        "API_KEY": "$(API_KEY)",
                        "CRYPTOPANIC_API_KEY": "$(CRYPTOPANIC_API_KEY)",
                        "GEMINI_API_KEY": "$(GEMINI_API_KEY)"
                    ]
                ),
            sources: [
                "Targets/Sources/App/**",
                "Targets/Sources/Presentation/**",
                "Targets/Sources/Shared/**"
            ],
            resources: resources,
            dependencies: [
                .target(name: "Domain"),
                .target(name: "Data"),
                .package(product: "Factory"),
                .package(product: "Kingfisher")
            ]
        ),
        .target(
            name: "Entity",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(organizationName).Entity",
            deploymentTargets: .iOS("17.0"),
            sources: [
                "Targets/Sources/Entity/**",
                "Targets/Sources/Shared/Extensions/String+Extension.swift"
            ],
            dependencies: []
        ),
        // Domain
        .target(
            name: "Domain",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(organizationName).Domain",
            deploymentTargets: .iOS("17.0"),
            sources: [
                "Targets/Sources/Domain/Repository/**",
                "Targets/Sources/Domain/UseCase/**"
            ],
            dependencies: [
                .target(name: "Entity")
            ]
        ),
        // Data
        .target(
            name: "Data",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(organizationName).Data",
            deploymentTargets: .iOS("17.0"),
            sources: ["Targets/Sources/Data/**"],
            dependencies: [
                .target(name: "Domain"),
                .target(name: "Entity")
            ]
        ),
    ]
)
