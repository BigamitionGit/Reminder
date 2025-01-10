// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Feature",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Feature",
            targets: ["Root"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", exact: "0.57.0"),
        .package(path: "../Core")
    ],
    targets: [
        .binaryTarget(name: "SharedKit", path: "../../ios-shared/build/XCFrameworks/debug/SharedKit.xcframework"),
        .target(
            name: "Root",
            dependencies: [
                .reminder],
            plugins: [
                .lint
            ]),
        .target(
            name: "ReminderFeature",
            dependencies: [
                .sharedKit,
                .core],
            plugins: [
                .lint
            ]),
    ]
)

extension Target.Dependency: @unchecked Sendable {
    static let sharedKit: Target.Dependency = "SharedKit"
    static let reminder: Target.Dependency = "ReminderFeature"
    static let core: Target.Dependency = .product(name: "Core", package: "Core")
}

extension Target.PluginUsage: @unchecked Sendable {
    static let lint: Target.PluginUsage = .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
}
