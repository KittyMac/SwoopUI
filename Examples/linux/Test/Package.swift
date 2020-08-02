// swift-tools-version:5.2

// Requires libgtk
// sudo apt-get install libsdl2-dev

import PackageDescription

let package = Package(
    name: "Test",
    products: [
		
    ],
    dependencies: [
        .package(name: "SDL2", url: "https://github.com/ctreffs/SwiftSDL2.git", from: "1.1.0"),
        .package(name: "SwoopUI", path: "../../../"),
    ],
    targets: [
		.target(
            name: "Test",
			dependencies: ["SDL2", "SwoopUI"]
			),
        .testTarget(
            name: "TestTests",
            dependencies: ["Test"]
			)
    ]
)
