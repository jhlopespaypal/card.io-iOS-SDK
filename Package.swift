// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "CardIOSDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "CardIOSDK",
            targets: ["CardIO"]
        ),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "CardIO",
            path: "./Sources/CardIOSDK/CardIO.xcframework"
        ),
    ]
)
