// swift-tools-version:4.2

import PackageDescription

let package = Package(
  name: "Homework",
  products: [
    // Products define the executables and libraries produced by a package, and make them visible to other packages.
    .library(
      name: "Homework",
      targets: ["Homework"]),
  ],
  dependencies: [
    .package(url: "https://github.com/damdamo/SwiftKanren.git", .branch("master")),
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages which this package depends on.
    .target(
      name: "Homework",
      dependencies: ["SwiftKanren"]),
    .testTarget(
      name: "HomeworkTests",
      dependencies: ["Homework"]),
    ]
)
