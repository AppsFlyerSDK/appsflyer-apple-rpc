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
            url: "https://github.com/AppsFlyerSDK/appsflyer-apple-rpc/releases/download/7.0.12/AppsFlyerRPC-static.xcframework.zip",
            checksum: "14484bce262c2bea03cb4fb0ca85818560dd72831915246f5cc2686eb196f87f"
        ),
        .binaryTarget(
            name: "AppsFlyerRPCStrict",
            url: "https://github.com/AppsFlyerSDK/appsflyer-apple-rpc/releases/download/7.0.12/AppsFlyerRPC-strict.xcframework.zip",
            checksum: "916d920ce1cea66e86633dd4aaac1ab004a36c8d8090930ee0eda86d552fd203"
        )
    ]
)

