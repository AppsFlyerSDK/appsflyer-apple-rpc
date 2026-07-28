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
            url: "https://github.com/AppsFlyerSDK/appsflyer-apple-rpc/releases/download/7.0.1/AppsFlyerRPC-static.xcframework.zip",
            checksum: "da3223c384c84cbf2754a877a6d92c3bdf1109ba0371e912db9e09c3eb2e024e"
        ),
        .binaryTarget(
            name: "AppsFlyerRPCStrict",
            path: "Strict/AppsFlyerRPC.xcframework"
        )
    ]
)

