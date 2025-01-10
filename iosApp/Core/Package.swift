// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Core",
            targets: ["Helper", "Theme"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.13.0"),
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", exact: "0.57.0"),
        .package(url: "https://github.com/SwiftGen/SwiftGenPlugin", from: "6.6.2"),
        .package(url: "https://github.com/pointfreeco/swift-tagged", from: "0.10.0")
    ],
    targets: [
        .target(
            name: "Helper",
            dependencies: [
                .tca,
                .tagged
            ],
            plugins: [
                .lint
            ]),
        .target(
            name: "Theme",
            resources: [
                .process("Resources"),
                .process("swiftgen.yml"),
            ],
            plugins: [
                .lint,
                .swiftGen
            ]),
    ]
)

extension Target.Dependency: @unchecked Sendable {
    static let tca: Target.Dependency = .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
    static let tagged: Target.Dependency = .product(name: "Tagged", package: "swift-tagged")
}

extension Target.PluginUsage: @unchecked Sendable {
    static let swiftGen: Target.PluginUsage = .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin")
    static let lint: Target.PluginUsage = .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
}
