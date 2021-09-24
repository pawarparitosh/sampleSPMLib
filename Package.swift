// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SampleAnalyticsPackage",
    platforms: [
           .iOS(.v14),
       ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SampleAnalyticsPackage",
            targets: ["SampleAnalyticsPackage"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
//         .package(url: "https://github.com/CocoaPods/Specs/tree/master/Specs/5/5/6/Heap.git", from: "7.5.1")
//        .package(url: "https://github.com/developerinsider/SPMDeveloperInsider", from: "1.0.4")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SampleAnalyticsPackage",
            dependencies: []),
        .testTarget(
            name: "SampleAnalyticsPackageTests",
            dependencies: ["SampleAnalyticsPackage"]),
    ]
)
