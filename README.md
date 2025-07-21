![Logo](https://github.com/AyushMaji/gscankit/blob/main/assets/gscankit_banner.png?raw=true)

<h1 align="left">GScanKit – Powerful Barcode & QR Code Scanner SDK <a target="_blank" href="https://www.linkedin.com/in/ayushmaji/"></a><img src="https://raw.githubusercontent.com/AyushMaji/amicons/refs/heads/main/assets/amination/Hi.gif" width="30px"></h1></h1>

GScanKit is an AI-powered Flutter SDK for blazing-fast barcode and QR code scanning.
It supports fully customizable overlays, Apple-style border animations, and smart scanning from camera or gallery.
Easily scan multiple barcodes, switch cameras, toggle flash, and customize every UI element — AppBar, BottomSheet, FloatingBar, and more.
Includes full-screen scanner, animated scan line, and seamless integration — all with Flutter-native performance.
<br/><br/>

## Features

- **Full-Screen Scanner:** Seamless `full-screen live camera` with ultra-fast barcode & QR code detection.
- **AI-Powered Accuracy:** Fast and smart barcode & QR detection using `ML-backed` technology.
- **Multi-Code Support:** Detects and processes multiple barcodes and QR codes at once.
- **Apple-Style Animations:** Pulse border and scanning line `animation` inspired by `Apple’s scanner UX`.
- **Custom Overlay UI:** Complete control over scanner UI – colors, shapes, borders, blur, size, and style.
- **Flash & Camera Toggle:** Built-in flashlight toggle and instant `front/back camera` switching.
- **Gallery Image Scan:** Instantly scan barcodes and QR codes from user-selected `gallery images`.
- **Overlay Component Control:** Customize `app bar`, `floating bar`, `bottom sheets`, and more.
- **Developer-Friendly API:** Clean architecture, flexible callbacks, and easy Flutter integration.

<br/>
<br/>

<table>
  <tr>
    <td align="center">
      <img src="https://github.com/AyushMaji/gscankit/blob/main/assets/1.PNG?raw=true" width="100%"/>
      <br/>
      <code>Default Scanner</code>
    </td>
    <td align="center">
      <img src="https://github.com/AyushMaji/gscankit/blob/main/assets/2.PNG?raw=true" width="100%"/>
      <br/>
      <code>Custom AppBar + FloatingBar</code>
    </td>
    <td align="center">
      <img src="https://github.com/AyushMaji/gscankit/blob/main/assets/3.png?raw=true" width="100%"/>
      <br/>
      <code>Fullscreen Live Camera</code>
    </td>
</table>

<br/>

## Platform Support

| Android | iOS | macOS | Web |
| :-----: | :-: | :---: | :-: |
|   ✅    | ✅  |  ✅   | ✅  |

<br />

## Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  gscankit: ^latest_version # Replace with the latest version
```

Then run:

```bash
flutter pub get
```

## Platform Setup

Make sure you have completed the platform-specific setup for the `mobile_scanner` package. This usually involves adding camera usage descriptions to your `Info.plist` on iOS.

### iOS Permissions

Ensure these permissions are in your (`ios/Runner/Info.plist`)\*\*:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to scan barcodes.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo library access to scan barcodes from images.</string>
```

For detailed platform setup, please refer to the [official mobile_scanner documentation](https://pub.dev/packages/mobile_scanner#platform-specific-setup).

### Android Permissions

Ensure these permissions are in your `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
```

For Android 13+, consider using `READ_MEDIA_IMAGES` instead of `READ_EXTERNAL_STORAGE`.

---

## Basic Usage
Launch the default GscanKit scanner with minimal setup.  
Use the `onDetect` callback to handle scanned barcode results.

```dart
import 'package:gscankit/gscankit.dart';
import 'package:flutter/material.dart';

ElevatedButton(
  onPressed: () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GscanKit(
          onDetect: (BarcodeCapture capture) {
            // Handle detected barcode(s) here
          },
        ),
      ),
    );
  },
  child: const Text('Default Scanner'),
);
```
## ✅ GScanKit Configuration Options
Customize the behavior and appearance of the scanner using various configuration parameters.  
You can pass these options to the `GscanKit` widget to tailor it for your app's needs.


| Parameter                  | Type                        | Description                                                                 |
|---------------------------|-----------------------------|-----------------------------------------------------------------------------|
| `controller`              | `MobileScannerController?`  | Optional. Use to access and control the scanner programmatically.           |
| `validator`               | `bool Function(BarcodeCapture)?` | Optional. Validates scanned barcode. Return `true` to accept, `false` to ignore. |
| `onDetect`                | `void Function(BarcodeCapture)?` | Required. Called when a barcode is detected.                                |
| `onDetectError`           | `void Function(Object, StackTrace)?` | Optional. Called when an error occurs during scanning.                      |
| `errorBuilder`            | `Widget?`                   | Optional. Build custom UI when scanner fails to start.                      |
| `fit`                     | `BoxFit`                    | Optional. Camera preview fit (e.g. `BoxFit.cover`). Default is `cover`.     |
| `useAppLifecycleState`    | `bool`                      | Optional. Auto-pause camera on app pause. Default is `true`.                |
| `setPortraitOrientation`  | `bool`                      | Optional. Locks screen to portrait. Default is `true`.                      |
| `extendBodyBehindAppBar` | `bool`                      | Optional. Allows scanner view behind app bar. Default is `true`.            |
| `appBar`                  | `Widget?`                   | Optional. Custom AppBar widget.                                             |
| `bottomSheetBuilder`      | `Widget?`                   | Optional. Bottom sheet widget under scanner view.                           |
| `floatingOption`          | `List<Widget>?`             | Optional. Add floating buttons/widgets (e.g., torch, gallery).              |
| `placeholderBuilder`      | `Widget?`                   | Optional. Placeholder widget while initializing camera.                     |
| `scanWindow`              | `Rect?`                     | Optional. Limit scanning to specific region of screen.                      |
| `scanWindowUpdateThreshold` | `double`                  | Optional. Minimum size change to trigger scan window update. Default `0.0`. |
| `gscanOverlayConfig`      | `GscanOverlayConfig`        | Optional. Controls overlay style like border, animation, radius, blur.      |
| `customOverlayBuilder`    | `Widget?`                   | Optional. Fully override default overlay UI.                                |
| `onDispose`               | `void Function()?`          | Optional. Callback when scanner widget is disposed.                         |


## 🎨 Overlay Styling
Customize the appearance and behavior of the scanner with flexible options.  
You can tweak overlay styles, animation effects, scan border visibility, and more  
to match your app's branding or UX needs. Below is a full list of configurable fields:

```dart
GscanKit(
  controller: controller, // MobileScannerController instance
  onDetect: (BarcodeCapture capture) {
    // Handle scanned result
  },
  floatingOption: [], // Add custom floating widgets if needed
  gscanOverlayConfig: GscanOverlayConfig(
    scannerScanArea: ScannerScanArea.center, // Focus scan area in center
    scannerBorder: ScannerBorder.visible, // Enable visible border
    scannerBorderPulseEffect: ScannerBorderPulseEffect.enabled, // Apple-style border pulse
    borderColor: Colors.white, // Customize border color
    borderRadius: 24.0, // Rounded border edges
    scannerLineAnimationColor: Colors.green, // Scanning line color
    scannerOverlayBackground: ScannerOverlayBackground.blur, // Blurred camera overlay
    scannerLineAnimation: ScannerLineAnimation.enabled, // Enable line animation
  ),
)

```
## ✅ Overlay Styling Options
Customize the visual appearance of the scanner overlay to match your brand or design preference.

| Name                        | Type                       | Description & Default |
|-----------------------------|----------------------------|------------------------|
| `scannerScanArea`           | `ScannerScanArea`          | Area of scanner focus: full or center. Default: `ScannerScanArea.center` |
| `scannerOverlayBackground`  | `ScannerOverlayBackground` | Background effect outside scan window. Default: `ScannerOverlayBackground.blur` |
| `scannerOverlayBackgroundColor` | `Color`                | Tint color for overlay background. Default: `CupertinoColors.systemFill` |
| `scannerBorder`             | `ScannerBorder`            | Controls whether scan border is visible. Default: `ScannerBorder.visible` |
| `borderColor`               | `Color`                    | Color of the scan border.  Default: `CupertinoColors.white` |
| `borderRadius`              | `double`                   | Border corner radius (entire box).  Default: `24.0` |
| `cornerRadius`              | `double`                   | Radius of individual corners.  Default: `24.0` |
| `cornerLength`              | `double`                   | Length of corner indicators.  Default: `60.0` |
| `scannerBorderPulseEffect`  | `ScannerBorderPulseEffect` | Apple-style border pulse animation. Default: `ScannerBorderPulseEffect.enabled` |
| `scannerLineAnimation`      | `ScannerLineAnimation`     | Enables the animated scanning line. Default: `ScannerLineAnimation.enabled` |
| `scannerLineAnimationColor` | `Color`                    | Color of the scanning line. Default: `CupertinoColors.systemRed` |
| `scannerLineanimationDuration` | `Duration`              | Speed of scanning line animation. Default: `Duration(milliseconds: 1500)` |
| `lineThickness`             | `double`                   | Thickness of scanning line.  Default: `4.0` |
| `curve`                     | `Cubic?`                   | Curve of the animation (optional).
| `animation`                 | `Animation<double>?`       | Provide custom animation controller.
| `background`                | `Widget?`                  | Optional custom background widget.
| `successColor`              | `Color`                    | Border color on successful scan. Default: `CupertinoColors.systemGreen` |
| `errorColor`                | `Color`                    | Border color on error scan. Default: `CupertinoColors.systemRed` |
| `animateOnSuccess`          | `bool`                     | Whether to animate on successful scan. Default: `true` |
| `animateOnError`            | `bool`                     | Whether to animate on failed scan. Default: `true` |


---

### Gallery Button Options

```dart
GalleryButton(
  controller: controller, // Pass your MobileScannerController
  icon: Icon(CupertinoIcons.photo, size: 18), // Custom icon
  isSuccess: ValueNotifier<bool?>(null), // To handle scan result status
),
```

## 🛠 Dependencies

This package is a polished wrapper over [`mobile_scanner`](https://pub.dev/packages/mobile_scanner). It simplifies usage and adds visual polish.

For deep control or if you're troubleshooting:

- Manually control the camera lifecycle
- Tune detection speed and frame throttling
- Configure advanced platform-specific behaviors

See the [mobile_scanner docs](https://pub.dev/packages/mobile_scanner) for more details.

## 🆘 Troubleshooting

- **Black Screen / Scanner not opening**: Ensure permissions are granted and declared correctly.
- **Wrong detection**: Ensure good lighting, stable hands, and close distance.
- **iOS Pod Issues**: Try `flutter clean`, delete `Podfile.lock`, and run `pod install --repo-update`.

---

## 📄 License

MIT License. See [LICENSE](LICENSE) for details.

<br />
<code><img height="50" src="https://github.com/AyushMaji/gscankit/blob/main/assets/logo.png?raw=true"></code>
<br /><br />
<br />

> Copyright © **[Ayush Maji](https://github.com/AyushMaji)**. Licensed under the _[MIT LICENSE](https://github.com/AyushMaji/amicons/blob/main/LICENSE)_
>
> >
