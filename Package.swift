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
            url: "https://github.com/AppsFlyerSDK/appsflyer-apple-rpc/releases/download/1.0.4/AppsFlyerRPC-static.xcframework.zip",
            checksum: "b36d62e897674183b0b78b2af74a81770debba76bde8366221ad08e0455adb3f"
        )
    ]
)

