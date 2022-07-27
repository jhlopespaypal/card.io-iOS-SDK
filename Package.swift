// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "card.io-iOS-SDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "card.io-iOS-SDK",
            targets: [
                "CardIOSDK",
            ]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CardIOSDK",
            dependencies: [
                "CardIO",
                "libCardIO",
                "libopencv_core",
                "libopencv_imgproc",
            ]
        ),
        .binaryTarget(
            name: "CardIO",
            path: "./Sources/Build/CardIO.xcframework"
        ),
        .binaryTarget(
            name: "libCardIO",
            path: "./Sources/Build/libCardIO.xcframework"
        ),
        .binaryTarget(
            name: "libopencv_core",
            path: "./Sources/Build/libopencv_core.xcframework"
        ),
        .binaryTarget(
            name: "libopencv_imgproc",
            path: "./Sources/Build/libopencv_imgproc.xcframework"
        ),
    ]
)
