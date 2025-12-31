// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "AppsFlyerRPC",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "AppsFlyerRPC",
            targets: ["AppsFlyerRPC"])
    ],
    targets: [
        .binaryTarget(
            name: "AppsFlyerRPC",
            url: "https://github.com/AppsFlyerSDK/appsflyer-apple-rpc/releases/download/1.0.3/AppsFlyerRPC-static.xcframework.zip",
            checksum: "549ee2fe63d9e1b22b2c8a260d474b7d064539a0da7221ecc3cd0d5e55a2a6aa"
        )
    ]
)

