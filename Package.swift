// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "Swirth",
    platforms: [.macOS(.v13)],
    products: [
        .library(
            name: "SwirthCore",
            targets: ["SwirthCore"]
        ),
        .executable(
            name: "swirth",
            targets: ["SwirthCLI"],
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            exact: "1.7.1"
        ),
        .package(
            url: "https://github.com/swiftlang/swift-subprocess.git",
            exact: "0.4.0"
        ),
    ],
    targets: [
        .target(
            name: "SwirthCore"
        ),
        .executableTarget(
            name: "SwirthCLI",
            dependencies: [
                .target(
                    name: "SwirthCore"
                ),
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"
                ),
                .product(
                    name: "Subprocess",
                    package: "swift-subprocess"
                ),
            ]
        ),
        .testTarget(
            name: "SwirthCoreTests",
            dependencies: ["SwirthCore"]
        ),
    ]
)
