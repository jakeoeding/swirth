// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Swirth",
    platforms: [.macOS(.v13)],
    products: [
        .executable(
            name: "swirth",
            targets: ["swirth"],
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            exact: "1.7.1"
        ),
        .package(
            url: "https://github.com/swiftlang/swift-subprocess.git",
            exact: "0.4.0"
        )
    ],
    targets: [
        .executableTarget(
            name: "swirth",
            dependencies: [
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"
                ),
                .product(
                    name: "Subprocess",
                    package: "swift-subprocess"
                )
            ]
        ),
    ]
)
