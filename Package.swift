// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Codability",
    products: [
        .library(name: "Codability", targets: ["Codability"]),
    ],
    targets: [
        .target(name: "Codability"),
        .testTarget(name: "CodabilityTests", dependencies: ["Codability"]),
    ]
)
