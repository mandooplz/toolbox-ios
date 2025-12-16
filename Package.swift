// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ToolBoxiOS",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "ToolBoxiOS",
            targets: ["ToolBoxiOS"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/kakao/kakao-ios-sdk.git", branch: "master")
    ],
    targets: [
        .target(
            name: "ToolBoxiOS",
            dependencies: [
                // 2. 필요한 모듈 명시 (User, Auth, Common)
                .product(name: "KakaoSDK", package: "kakao-ios-sdk"),
            ]
        ),
        .testTarget(
            name: "ToolBoxiOSTests",
            dependencies: ["ToolBoxiOS"]
        ),
    ]
)
