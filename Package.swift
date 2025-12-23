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
            url: "https://github.com/AppsFlyerSDK/appsflyer-apple-rpc/releases/download/1.0.2/AppsFlyerRPC-static.xcframework.zip",
            checksum: "05bde3bb5419927792328d4770281af651c10af6e5c3897eb576b775f32fb492"
        )
    ]
)

