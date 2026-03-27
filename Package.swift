// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Swirth",
    products: [
        .executable(
            name: "swirth",
            targets: ["swirth"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            exact: "1.7.1"
        )
    ],
    targets: [
        .executableTarget(
            name: "swirth",
            dependencies: [
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"
                )
            ]
        ),
    ]
)
