Pod::Spec.new do |s|

    s.name             = 'AppsFlyerRPC'
    s.version          = "1.0.1"
    s.summary          = 'AppsFlyer iOS SDK RPC Interface'

    s.description      = <<-DESC
    AppsFlyerRPC provides a unified JSON-based RPC interface for the AppsFlyer iOS SDK,
    designed to simplify integration for mobile plugins (React Native, Flutter, Unity, Cordova).
    It replaces per-plugin native bindings with a consistent, maintainable communication layer.
    DESC

    s.homepage         = 'https://www.appsflyer.com'
    s.license          = { :type => 'Proprietary', :text => 'Copyright 2024 AppsFlyer Ltd. All rights reserved.' }
    s.author           = { 'AppsFlyer' => 'support@appsflyer.com' }
    s.source           = { :git => 'https://github.com/AppsFlyerSDK/appsflyer-apple-rpc.git', :tag => s.version.to_s }
    s.requires_arc     = true
    s.platform         = :ios
    s.ios.deployment_target = '13.0'
    s.swift_version    = '5.9'
    s.default_subspecs = 'Main'

    s.subspec 'Main' do |ss|
        ss.ios.preserve_paths = 'AppsFlyerRPC.xcframework', 'AppsFlyerRPC.modulemap'
        ss.ios.vendored_frameworks = 'AppsFlyerRPC.xcframework'
        ss.ios.resource_bundles = {'AppsFlyerRPC_Privacy' => ['Resources/PrivacyInfo.xcprivacy']}
        ss.dependency 'AppsFlyerFramework', '6.17.8'
    end

end

