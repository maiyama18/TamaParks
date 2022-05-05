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
    dependencies: [
        .package(url: "https://github.com/siteline/SwiftUI-Introspect.git", exact: "0.1.4"),
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                "ListFeature",
                "MapFeature",
                "Resources",
            ]
        ),
        .target(
            name: "ListFeature",
            dependencies: [
                "DetailScreen",
                "UICore",
                "Repositories",
                "Persistence",
                "Resources",
            ]
        ),
        .target(
            name: "MapFeature",
            dependencies: [
                "DetailScreen",
                "UICore",
                "Location",
                "Repositories",
                "Persistence",
            ]
        ),
        .target(
            name: "DetailScreen",
            dependencies: [
                "UICore",
                "Repositories",
                "Persistence",
            ]
        ),
        .target(
            name: "UICore",
            dependencies: [
                "Resources",
                .product(name: "Introspect", package: "SwiftUI-Introspect"),
            ]
        ),
        .target(
            name: "Location",
            dependencies: []
        ),
        .target(
            name: "Repositories",
            dependencies: [
                "Persistence",
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
