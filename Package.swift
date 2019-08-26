// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MenuItemKit",
  products: [
    .library(name: "MenuItemKit", targets: ["MenuItemKit"])
  ],
  targets: [
    .target(name: "ObjCSwizzlings", path: "./MenuItemKit/ObjCSwizzlings"),
    .target(name: "MenuItemKit", dependencies: ["ObjCSwizzlings"], path: "./MenuItemKit/Swift")
  ]
)
