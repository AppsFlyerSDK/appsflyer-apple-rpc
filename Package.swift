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
            url: "https://github.com/AppsFlyerSDK/appsflyer-apple-rpc/releases/download/7.0.4/AppsFlyerRPC-static.xcframework.zip",
            checksum: "ec94e21f38b2e0521d3d6d7f451c78f9bc1a0e69eb3f3d0cd399eae6607256cd"
        ),
        .binaryTarget(
            name: "AppsFlyerRPCStrict",
            url: "https://github.com/AppsFlyerSDK/appsflyer-apple-rpc/releases/download/7.0.4/AppsFlyerRPC-strict.xcframework.zip",
            checksum: "775b4830f2f904ff9b25fadc69553afe2354da5713f163d070d4273355a1e440"
        )
    ]
)

