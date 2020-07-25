// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "Path",
    products: [
        .library(
            name: "Path",
            targets: ["Path"]),
    ],
    targets: [
        .target(
            name: "Path",
            dependencies: []),
        .testTarget(
            name: "PathTests",
            dependencies: ["Path"]),
    ]
)
