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
            targets: ["AppsFlyerRPC"]),
        .library(
            name: "AppsFlyerRPCStrict",
            targets: ["AppsFlyerRPCStrict"])
    ],
    targets: [
        .binaryTarget(
            name: "AppsFlyerRPC",
            url: "https://github.com/AppsFlyerSDK/appsflyer-apple-rpc/releases/download/7.0.41/AppsFlyerRPC-static.xcframework.zip",
            checksum: "4c44d2454f065cb5ca9d740d7fd403ec0c47961eb8bf6532da5dda9d82a96709"
        ),
        .binaryTarget(
            name: "AppsFlyerRPCStrict",
            url: "https://github.com/AppsFlyerSDK/appsflyer-apple-rpc/releases/download/7.0.41/AppsFlyerRPC-strict.xcframework.zip",
            checksum: "6c2c306641bdb39ccb5a65883282f38d1abb13bb2aeb05c48e40babf74830d33"
        )
    ]
)

