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
            checksum: "f68ff7e90551adc530701fe957b8a00f89e6e6cf0e452627c73ebf2e0db10a68"
        )
    ]
)

