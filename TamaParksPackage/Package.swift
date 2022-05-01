// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TamaParksPackage",
    defaultLocalization: "ja",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "App",
            targets: ["App"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "App",
            dependencies: [
                "Resources",
            ]
        ),
        .target(
            name: "Persistence",
            dependencies: []
        ),
        .target(
            name: "Resources",
            dependencies: [],
            resources: [
                .process("Localizable.strings"),
            ]
        ),
    ]
)
