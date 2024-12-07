// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Feature",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Feature",
            targets: ["Root"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.17.0"),
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", exact: "0.57.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .binaryTarget(name: "SharedKit", path: "../../composeApp/build/XCFrameworks/debug/SharedKit.xcframework"),
        .target(
            name: "Root",
            dependencies: [
                .sharedKit,
                .tca],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]),
        .testTarget(
            name: "FeatureTests",
            dependencies: ["Feature"]),
    ]
)

extension Target.Dependency {
    static let sharedKit: Target.Dependency = "SharedKit"
    static let tca: Target.Dependency = .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
}
