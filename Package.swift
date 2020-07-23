// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "SwoopUI",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
		.executable(name: "SwoopUIDemo", targets: ["SwoopUIDemo"]),
        .library(name: "SwoopUI", targets: ["SwoopUI"]),
    ],
    dependencies: [
		.package(url: "https://github.com/KittyMac/Flynn.git", .branch("master")),
    ],
    targets: [
        .target(
            name: "SwoopUIDemo",
            dependencies: [
                "SwoopUI",
                "Flynn"
            ]
        ),
        .target(
            name: "SwoopUI",
            dependencies: [ 
				"Flynn",
				"Yoga"
			]),
        .target(
            name: "Yoga",
            dependencies: [ ]),
        .testTarget(
            name: "SwoopUITests",
            dependencies: [ "SwoopUI" ]),
    ],
	cxxLanguageStandard: .gnucxx14
)
