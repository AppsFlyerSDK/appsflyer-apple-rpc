<img src="https://massets.appsflyer.com/wp-content/uploads/2018/06/20092440/static-ziv_1TP.png"  width="400" > 

# AppsFlyerRPC - iOS SDK RPC Interface

[![License: Proprietary](https://img.shields.io/badge/License-Proprietary-blue.svg)](https://github.com/AppsFlyerSDK/appsflyer-apple-rpc/blob/main/LICENSE)

🛠 In order for us to provide optimal support, we would kindly ask you to submit any issues to support@appsflyer.com

> *When submitting an issue please specify your AppsFlyer sign-up (account) email, your app ID, production steps, logs, code snippets and any additional relevant information.*

## Overview

AppsFlyerRPC provides a unified JSON-based RPC (Remote Procedure Call) interface for the AppsFlyer iOS SDK. It serves as a single integration point for all mobile plugins (React Native, Flutter, Unity, Cordova, etc.), replacing per-plugin native bindings with a consistent, maintainable JSON-based communication layer.

```
Plugin (JS/Dart/C#) → JSON Request → AppsFlyerRPC → AppsFlyer iOS SDK
                   ← JSON Response ←
```

## Key Features

- **JSON-based Communication**: Simple request/response format
- **Async/Await Support**: Built-in timeout handling
- **Event System**: SDK callbacks for conversion data and deep links
- **Type-safe Validation**: Parameter validation at the bridge level
- **7 Core SDK Methods**: Essential SDK functionality coverage
- **Objective-C Bridge**: Easy integration for plugin developers

## Requirements

| Component | Version |
|-----------|---------|
| **iOS** | 13.0+ |
| **Xcode** | 15.0+ |
| **Swift** | 5.9+ |
| **AppsFlyer SDK** | 6.0+ |

## Table of Contents

- [Installation](#installation)
  - [CocoaPods](#cocoapods)
  - [Swift Package Manager](#swift-package-manager)
  - [Carthage](#carthage)
- [Quick Start](#quick-start)
- [API Reference](#api-reference)
- [Event System](#event-system)
- [Error Handling](#error-handling)
- [Plugin Integration](#plugin-integration)
- [Architecture](#architecture)
- [Support](#support)

---

## Installation

### <a id="cocoapods">CocoaPods</a>

Add to your `Podfile`:

```ruby
pod 'AppsFlyerRPC'
```

Then run:

```bash
pod install
```

### <a id="swift-package-manager">Swift Package Manager</a>

To integrate AppsFlyerRPC via Swift Package Manager:

1. In Xcode, go to **File > Swift Packages > Add Package Dependency**
2. Enter the repository URL:

```
https://github.com/AppsFlyerSDK/appsflyer-apple-rpc
```

3. Choose the desired version or branch
4. Select your project's target and click **Finish**

### <a id="carthage">Carthage</a>

AppsFlyerRPC supports both **static** and **dynamic** linking via Carthage.

#### Static Linking (Recommended)

Go to the `Carthage` folder in the root of the repository. Open `AppsFlyerRPC-static.json`, click raw, copy and paste the URL of the file to your `Cartfile`:

```
binary "https://raw.githubusercontent.com/AppsFlyerSDK/appsflyer-apple-rpc/main/Carthage/AppsFlyerRPC-static.json" == 1.0.0
```

#### Dynamic Linking

For dynamic linking, use `AppsFlyerRPC-dynamic.json`:

```
binary "https://raw.githubusercontent.com/AppsFlyerSDK/appsflyer-apple-rpc/main/Carthage/AppsFlyerRPC-dynamic.json" == 1.0.0
```

#### Installation

Then open project folder in the terminal and use command:

```bash
carthage update --use-xcframeworks
```

Drag and drop `AppsFlyerRPC.xcframework` binary from `Carthage/Build/iOS` folder.

More reference on Carthage binary artifacts integration [here](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md).

---

## Quick Start

### Basic Usage (Objective-C)

```objc
#import <AppsFlyerRPC/AppsFlyerRPC.h>

// Initialize
NSString *initRequest = @"{\"method\":\"init\",\"params\":{\"devKey\":\"YOUR_KEY\",\"appId\":\"id123456789\"}}";
[[AppsFlyerRPCBridge shared] executeJson:initRequest completion:^(NSString *response) {
    NSLog(@"Init: %@", response);
}];

// Start tracking
NSString *startRequest = @"{\"method\":\"start\",\"params\":{}}";
[[AppsFlyerRPCBridge shared] executeJson:startRequest completion:^(NSString *response) {
    NSLog(@"Start: %@", response);
}];

// Log event
NSString *eventRequest = @"{\"method\":\"logEvent\",\"params\":{\"eventName\":\"purchase\",\"eventValues\":{\"revenue\":9.99}}}";
[[AppsFlyerRPCBridge shared] executeJson:eventRequest completion:^(NSString *response) {
    NSLog(@"Event: %@", response);
}];
```

### Typical Initialization Flow

```json
{"method": "init", "params": {"devKey": "YOUR_KEY", "appId": "id123456789"}}
{"method": "isDebug", "params": {"isDebug": true}}
{"method": "waitForATT", "params": {"timeout": 60}}
{"method": "registerConversionListener", "params": {"isEnabled": true}}
{"method": "registerDeeplinkListener", "params": {"isEnabled": true}}
{"method": "start", "params": {}}
```

---

## API Reference

### Methods Overview

| Method | Required Params | Description |
|--------|-----------------|-------------|
| `init` | `devKey`, `appId` | Initialize SDK |
| `start` | — | Start tracking session |
| `logEvent` | `eventName` | Log in-app event |
| `isDebug` | `isDebug` | Enable/disable debug logging |
| `waitForATT` | `timeout` (optional) | Wait for ATT authorization (iOS only) |
| `registerConversionListener` | `isEnabled` | Enable conversion callbacks |
| `registerDeeplinkListener` | `isEnabled` | Enable deep link callbacks |

### Request/Response Format

**Request:**
```json
{
  "id": "optional-request-id",
  "method": "methodName",
  "params": { }
}
```

**Success Response:**
```json
{
  "id": "optional-request-id",
  "result": {
    "success": true,
    "message": "Description"
  }
}
```

**Error Response:**
```json
{
  "id": "optional-request-id",
  "error": {
    "code": 422,
    "message": "Missing required parameter: paramName"
  }
}
```

For detailed method documentation, parameter descriptions, and examples, please refer to the [full API reference](https://dev.appsflyer.com).

---

## Event System

### Setup Event Handler

```objc
[[AppsFlyerRPCBridge shared] setEventHandler:^(NSString *jsonEvent) {
    // Handle event
    NSLog(@"Event received: %@", jsonEvent);
}];
```

### Event Format

```json
{
  "event": "onConversionDataSuccess",
  "data": { },
  "timestamp": 1701234567890,
  "origin": "ios"
}
```

### Event Types

| Event | Trigger |
|-------|---------|
| `onConversionDataSuccess` | Attribution data received |
| `onConversionDataFail` | Attribution fetch failed |
| `onAppOpenAttribution` | Universal link opened |
| `onAppOpenAttributionFailure` | Universal link failed |
| `onDeepLinkReceived` | Deep link resolved |

---

## Error Handling

### Error Codes

| Code | Description | Resolution |
|------|-------------|------------|
| `400` | Invalid JSON | Check JSON syntax |
| `404` | Unknown method | Use valid method name |
| `422` | Validation error | Check required parameters |
| `500` | Internal error / timeout | Check SDK logs, retry |
| `503` | SDK not initialized | Call `init()` first |

---

## Plugin Integration

### React Native Example

```typescript
const { AppsFlyerRPCBridge } = NativeModules;

async function executeRPC(method: string, params: object): Promise<any> {
  return new Promise((resolve, reject) => {
    const request = JSON.stringify({ method, params });
    AppsFlyerRPCBridge.executeJson(request, (response: string) => {
      const parsed = JSON.parse(response);
      parsed.error ? reject(parsed.error) : resolve(parsed.result);
    });
  });
}

// Usage
await executeRPC('init', { devKey: 'KEY', appId: 'id123' });
await executeRPC('start', {});
await executeRPC('logEvent', { eventName: 'purchase', eventValues: { revenue: 9.99 } });
```

### Flutter Example

```dart
Future<Map<String, dynamic>?> executeRPC(String method, Map<String, dynamic> params) async {
  final request = jsonEncode({'method': method, 'params': params});
  final response = await _channel.invokeMethod('executeJson', request);
  final parsed = jsonDecode(response);
  if (parsed.containsKey('error')) {
    throw Exception('[${parsed['error']['code']}] ${parsed['error']['message']}');
  }
  return parsed['result'];
}
```

---

## Architecture

```
┌─────────────────────────────────────────────────┐
│              Plugin (JS/Dart/C#)                │
└─────────────────────┬───────────────────────────┘
                      │ JSON
┌─────────────────────▼───────────────────────────┐
│           AppsFlyerRPCBridge (ObjC API)         │
│           • executeJson(_:completion:)          │
│           • setEventHandler(_:)                 │
└─────────────────────┬───────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────┐
│              AFRPCClient (Engine)               │
│           • Parse → Validate → Execute          │
└─────────────────────┬───────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────┐
│          AFRPCRequestHandler (SDK Calls)        │
│           • Routes to AppsFlyerLib methods      │
│           • Implements SDK delegates            │
└─────────────────────┬───────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────┐
│              AppsFlyer iOS SDK                  │
└─────────────────────────────────────────────────┘
```

---

## Support

- **Email**: support@appsflyer.com
- **Documentation**: https://dev.appsflyer.com
- **GitHub Issues**: https://github.com/AppsFlyerSDK/appsflyer-apple-rpc/issues

---

## For Maintainers

### Release Process

This repository uses automated workflows to streamline releases. See the comprehensive guide:

📖 **[Workflows Guide](.github/WORKFLOWS.md)** - Complete documentation on the automated release process

**Quick Start**:
```bash
# 1. Create release branch
git checkout -b releases/1.x.x/1.0.x/1.0.0

# 2. Push (triggers automation)
git push origin releases/1.x.x/1.0.x/1.0.0

# 3. Review & merge PR
# 4. Release published automatically!
```

---

## License

Copyright © 2024 AppsFlyer Ltd. All rights reserved.

See [LICENSE](LICENSE) for full terms of use.

