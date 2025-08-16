// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "Localizable",
    platforms: [
        .macOS(.v12), .iOS(.v15), .tvOS(.v15), .watchOS(.v8), .macCatalyst(.v13), .visionOS(.v1)
    ],
    products: [
        .library(name: "Localizable", targets: ["Localizable"]),
        .executable(name: "LocalizableClient", targets: ["LocalizableClient"])
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0")
    ],
    targets: [
        .macro(
            name: "LocalizableMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(name: "Localizable", dependencies: ["LocalizableMacros"]),
        .executableTarget(name: "LocalizableClient", dependencies: ["Localizable"])
    ]
)
