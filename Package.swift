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
            url: "https://github.com/AppsFlyerSDK/appsflyer-apple-rpc/releases/download/7.1.0/AppsFlyerRPC-static.xcframework.zip",
            checksum: "3462400402208924c333093f207079a128a037d71742f45dc908f415d09a9c08"
        ),
        .binaryTarget(
            name: "AppsFlyerRPCStrict",
            url: "https://github.com/AppsFlyerSDK/appsflyer-apple-rpc/releases/download/7.1.0/AppsFlyerRPC-strict.xcframework.zip",
            checksum: "c9e57dd9e782a16b0c3fa9a3f9ee270de9d229e27e5d7e619b73d2a03eba4bca"
        )
    ]
)

