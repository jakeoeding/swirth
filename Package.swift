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
    targets: [
        .executableTarget(
            name: "swirth"
        ),
    ]
)
