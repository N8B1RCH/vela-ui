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
            path: "Sources/Vela-UI",
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "Tests",
            dependencies: ["Vela"],
            path: "Tests/VelaTests"
        ),
    ]
)
