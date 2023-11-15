// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "dabadoo",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .executable(
            name: "dabadoo",
            targets: ["dabadoo"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.0.6"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "dabadoo",
            dependencies: ["Yams"]
        ),
        .testTarget(
            name: "dabadooTests",
            dependencies: ["dabadoo"]
        ),
    ]
)
