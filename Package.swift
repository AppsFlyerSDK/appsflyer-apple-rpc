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
            url: "https://github.com/AppsFlyerSDK/appsflyer-apple-rpc/releases/download/7.0.13/AppsFlyerRPC-static.xcframework.zip",
            checksum: "e6ab48450c2f2bec204a8f6298e4b5859db6bf8232819b388d741aea59c567d1"
        ),
        .binaryTarget(
            name: "AppsFlyerRPCStrict",
            url: "https://github.com/AppsFlyerSDK/appsflyer-apple-rpc/releases/download/7.0.13/AppsFlyerRPC-strict.xcframework.zip",
            checksum: "27de360d0aaed995fcf33bc220ff5cb24dbbbb5a54ea009cdfda78aca7edc35e"
        )
    ]
)

