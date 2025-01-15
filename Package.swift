// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-frontmatter-parsing",
    platforms: [
      .iOS(.v13),
      .macOS(.v12),
      .tvOS(.v13),
      .watchOS(.v6),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FrontmatterParsing",
            targets: ["FrontmatterParsing"]),
    ],
    dependencies: [
        .package(url: "https://github.com/woodymelling/swift-parsing", from: "0.1.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FrontmatterParsing",
            dependencies: [
                .product(name: "Parsing", package: "swift-parsing"),
                .product(name: "Yams", package: "yams")
            ]
        ),
    ]
)
