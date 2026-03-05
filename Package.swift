// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Vela",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "Vela",
            targets: ["Vela"]
        ),
    ],
    targets: [
        .target(
            name: "Vela",
            path: "Sources/Vela"
        ),
        .testTarget(
            name: "VelaTests",
            dependencies: ["Vela"],
            path: "Tests/VelaTests"
        ),
    ]
)
