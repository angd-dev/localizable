# Localizable

Macros-based Swift library for type-safe localization without stringly-typed keys.

## Overview

Localizable allows you to define localization keys using enums, and automatically generates static constants and functions for accessing localized strings. This makes your code type-safe, easy to read, and avoids errors from hardcoded keys.

## Installation

To add Localizable to your project, use Swift Package Manager (SPM).

### Adding to an Xcode Project

1. Open your project in Xcode.
2. Navigate to the `File` menu and select `Add Package Dependencies`.
3. Enter the repository URL: `https://github.com/angd-dev/localizable.git`.
4. Choose the version to install (e.g. `1.0.0`).
5. Add the library to your target module.

### Adding to Package.swift

If you are using Swift Package Manager with a Package.swift file, add the dependency like this:

```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "YourProject",
    dependencies: [
        .package(url: "https://github.com/angd-dev/localizable.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "YourTarget",
            dependencies: [
                .product(name: "Localizable", package: "localizable")
            ]
        )
    ]
)
```

## Usage

Define your localization keys inside a nested enum marked with @Localizable. The macro will generate static properties and methods for you.

```swift
import Localizable

extension String {
    @Localizable enum Login {
        private enum Strings {
            case welcome
            case title(String)
            case message(msg1: String, msg2: Int)
        }
    }
}

let text1 = String.Login.welcome
let text2 = String.Login.title("Some text")
let text3 = String.Login.message(msg1: "Hello", msg2: 42)
```

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
