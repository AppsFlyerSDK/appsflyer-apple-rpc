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
            checksum: "d8d70a75f97d0633e56ef7ae00d4254d3e88c00a9e809d05d2f7be63b010d528"
        ),
        .binaryTarget(
            name: "AppsFlyerRPCStrict",
            url: "https://github.com/AppsFlyerSDK/appsflyer-apple-rpc/releases/download/7.0.4/AppsFlyerRPC-strict.xcframework.zip",
            checksum: "64b539712ab312a4cc3f0caa7a8be43dcbb4773b47e1dbb657c75054930db264"
        )
    ]
)

