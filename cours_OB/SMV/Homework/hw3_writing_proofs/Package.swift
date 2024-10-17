// swift-tools-version:4.2

import PackageDescription

let package = Package(
  name: "TP3",
  products: [
    // Products define the executables and libraries produced by a package, and make them visible to other packages.
    .library(
      name: "TP3",
      targets: ["TP3"]),
  ],
  dependencies: [
    .package(url: "https://github.com/damdamo/SwiftKanren.git", .branch("master")),
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages which this package depends on.
    .target(
      name: "TP3",
      dependencies: ["SwiftKanren"]),
    .testTarget(
      name: "TP3Tests",
      dependencies: ["TP3"]),
    ]
)
