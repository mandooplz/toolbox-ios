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
    targets: [
        .target(
            name: "ToolBoxiOS"
        ),
        .testTarget(
            name: "ToolBoxiOSTests",
            dependencies: ["ToolBoxiOS"]
        ),
    ]
)
