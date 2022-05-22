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
        .package(url: "https://github.com/maiyama18/SwiftUtils.git", exact: "0.1.0"),
        .package(url: "https://github.com/maiyama18/ImageViewer.git", branch: "main"),
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
                "Repositories",
                "Persistence",
                .product(name: "SwiftUtils", package: "SwiftUtils"),
            ]
        ),
        .target(
            name: "DetailScreen",
            dependencies: [
                "UICore",
                "Repositories",
                "Persistence",
                "Resources",
                .product(name: "SwiftUtils", package: "SwiftUtils"),
                .product(name: "ImageViewer", package: "ImageViewer"),
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
            name: "Repositories",
            dependencies: [
                "Entities",
                "Persistence",
                .product(name: "SwiftUtils", package: "SwiftUtils"),
            ]
        ),
        .target(
            name: "Entities",
            dependencies: [
                "Persistence",
                "Resources",
            ]
        ),
        .target(
            name: "Persistence",
            dependencies: [
                .product(name: "SwiftUtils", package: "SwiftUtils"),
            ]
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
