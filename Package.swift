// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RxHeadPageKit",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(name: "RxHeadPageKit", targets: ["RxHeadPageKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/bugkingK/HeadPageKit", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0"))
    ],
    targets: [
        .target(name: "RxHeadPageKit", dependencies: ["HeadPageKit", "RxSwift", .product(name: "RxCocoa", package: "RxSwift")]),
        .testTarget(name: "RxHeadPageKitTests", dependencies: ["RxHeadPageKit"]),
    ],
    swiftLanguageVersions: [.v5]
)
