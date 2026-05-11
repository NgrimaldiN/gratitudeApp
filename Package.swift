// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "GratitudeApp",
    platforms: [
        .iOS(.v17),
        .macOS(.v15),
    ],
    products: [
        .library(
            name: "GratitudeCore",
            targets: ["GratitudeCore"]
        ),
    ],
    targets: [
        .target(
            name: "GratitudeCore"
        ),
        .testTarget(
            name: "GratitudeCoreTests",
            dependencies: ["GratitudeCore"]
        ),
    ]
)
