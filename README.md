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

---

## 🚀 Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  gscankit: ^latest_version # Replace with the latest version
```

Then run:

```bash
flutter pub get
```

---

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

## 🧪 Basic Usage

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
---
## ✅ GScanKit Configuration Options
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

---

### 🪄  Overlay Styling

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

### ✅ Overlay Styling Configuration

| Name                          | Type                        | Default                                | Description |
|-------------------------------|-----------------------------|----------------------------------------|-------------|
| `scannerScanArea`             | `ScannerScanArea`           | `ScannerScanArea.center`              | Area of scanner focus: full or center. |
| `scannerOverlayBackground`    | `ScannerOverlayBackground`  | `ScannerOverlayBackground.blur`       | Background effect outside scan window. |
| `scannerOverlayBackgroundColor` | `Color`                  | `CupertinoColors.systemFill`          | Tint color for overlay background. |
| `scannerBorder`               | `ScannerBorder`             | `ScannerBorder.visible`               | Controls whether scan border is visible. |
| `borderColor`                 | `Color`                     | `CupertinoColors.white`               | Color of the scan border. |
| `borderRadius`                | `double`                    | `24.0`                                 | Border corner radius (entire box). |
| `cornerRadius`                | `double`                    | `24.0`                                 | Radius of individual corners. |
| `cornerLength`                | `double`                    | `60.0`                                 | Length of corner indicators. |
| `scannerBorderPulseEffect`    | `ScannerBorderPulseEffect`  | `ScannerBorderPulseEffect.enabled`    | Apple-style border pulse animation. |
| `scannerLineAnimation`        | `ScannerLineAnimation`      | `ScannerLineAnimation.enabled`        | Enables the animated scanning line. |
| `scannerLineAnimationColor`   | `Color`                     | `CupertinoColors.systemRed`           | Color of the scanning line. |
| `scannerLineanimationDuration`| `Duration`                  | `Duration(milliseconds: 1500)`        | Speed of scanning line animation. |
| `lineThickness`               | `double`                    | `4.0`                                  | Thickness of scanning line. |
| `curve`                       | `Cubic?`                    | `null`                                 | Curve of the animation (optional). |
| `animation`                   | `Animation<double>?`        | `null`                                 | Provide custom animation controller. |
| `background`                  | `Widget?`                   | `null`                                 | Optional custom background widget. |
| `successColor`                | `Color`                     | `CupertinoColors.systemGreen`         | Border color on successful scan. |
| `errorColor`                  | `Color`                     | `CupertinoColors.systemRed`           | Border color on error scan. |
| `animateOnSuccess`            | `bool`                      | `true`                                 | Whether to animate on successful scan. |
| `animateOnError`              | `bool`                      | `true`                                 | Whether to animate on failed scan. |

---

### Gallery Button Options

```dart
GalleryButton(
  controller: controller, // Pass your MobileScannerController
  icon: Icon(CupertinoIcons.photo, size: 18), // Custom icon
  isSuccess: ValueNotifier<bool?>(null), // To handle scan result status
),
```

---

## 🛠 Under the Hood

This package is a polished wrapper over [`mobile_scanner`](https://pub.dev/packages/mobile_scanner). It simplifies usage and adds visual polish.

For deep control or if you're troubleshooting:

- Manually control the camera lifecycle
- Tune detection speed and frame throttling
- Configure advanced platform-specific behaviors

See the [mobile_scanner docs](https://pub.dev/packages/mobile_scanner) for more details.

---

## 🧩 Dependencies

This package uses:

- `mobile_scanner` for barcode recognition
- `permission_handler` for requesting runtime permissions (optional if handled manually)

---

## 🆘 Troubleshooting

- **Black Screen / Scanner not opening**: Ensure permissions are granted and declared correctly.
- **Wrong detection**: Ensure good lighting, stable hands, and close distance.
- **iOS Pod Issues**: Try `flutter clean`, delete `Podfile.lock`, and run `pod install --repo-update`.

---

## 📄 License

MIT License. See [LICENSE](LICENSE) for details.

<br />
<code><img height="50" src="https://raw.githubusercontent.com/AyushMaji/amicons/refs/heads/main/assets/others/flaticon.png"></code>
<code><img height="50" src="https://raw.githubusercontent.com/AyushMaji/amicons/refs/heads/main/assets/others/iconly.jpg"></code>
<code><img height="50" src="https://raw.githubusercontent.com/AyushMaji/amicons/refs/heads/main/assets/others/lucide.png"></code>
<code><img height="50" src="https://raw.githubusercontent.com/AyushMaji/amicons/refs/heads/main/assets/others/remix.png"></code>
<code><img height="50" src="https://raw.githubusercontent.com/AyushMaji/amicons/refs/heads/main/assets/others/vuesax.png"></code>
<br /><br />
<br />

> Copyright © **[Ayush Maji](https://github.com/AyushMaji)**. Licensed under the _[MIT LICENSE](https://github.com/AyushMaji/amicons/blob/main/LICENSE)_
>
> >
