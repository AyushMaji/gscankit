// lib/src/ai_barcode_scanner.dart
import 'dart:async' show Timer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gscankit/gscankit.dart';
import 'package:gscankit/src/overlay/overlay.dart';
import 'package:universal_platform/universal_platform.dart';
import 'widgets/error_builder.dart';

/// The main barcode scanner widget.
class GscanKit extends StatefulWidget {
  /// The controller for the mobile scanner.
  final MobileScannerController? controller;

  /// A function that validates a detected barcode.
  /// Returns `true` if the barcode is valid, `false` otherwise.
  final bool Function(BarcodeCapture)? validator;

  /// The primary callback function that is called when a barcode is detected.
  final void Function(BarcodeCapture)? onDetect;

  /// A callback function that is called when an error occurs during barcode detection.
  final void Function(Object, StackTrace)? onDetectError;

  /// A builder for displaying an error widget when the scanner fails to start.
  /// If null, a default error widget is used.
  final Widget Function(BuildContext, MobileScannerException)? errorBuilder;

  /// Defines how the camera preview will be fitted into the layout.
  final BoxFit fit;

  /// Whether to use the app lifecycle state to pause the camera when the app is paused.
  final bool useAppLifecycleState;

  /// Locks the screen orientation to portrait mode. Defaults to `true`.
  final bool setPortraitOrientation;

  /// Whether the body of the scaffold should extend behind the app bar. Defaults to `true`.
  final bool extendBodyBehindAppBar;

  /// A builder for the `AppBar` of the scanner screen.
  final PreferredSizeWidget? Function(
    BuildContext context,
    MobileScannerController controller,
  )?
  appBar;

  /// A builder for a bottom sheet that is displayed below the camera preview.
  final Widget? Function(
    BuildContext context,
    MobileScannerController controller,
  )?
  bottomSheetBuilder;

  /// floating widget
  final List<Widget>? floatingOption;

  /// A builder for a placeholder widget that is displayed while the camera is initializing.
  /// If null, a black `ColoredBox` is used.
  final Widget Function(BuildContext)? placeholderBuilder;

  /// The rectangular area on the screen where the scanner will focus on detecting barcodes.
  /// If null, a default window will be used.
  /// **REFACTORED:** This is now the single source of truth for the scan window dimensions.
  final Rect? scanWindow;

  /// The threshold for updates to the [scanWindow].
  final double scanWindowUpdateThreshold;

  /// Configuration for the scanner overlay (lines, borders, colors).
  final GscanOverlayConfig gscanOverlayConfig;

  /// A builder for a custom overlay that can be placed on top of the scanner.
  /// This will override the default custom overlay.
  final Widget Function(
    BuildContext,
    BoxConstraints,
    MobileScannerController,
    bool?,
  )?
  customOverlayBuilder;

  /// A callback function that is called when the widget is initialized.
  final void Function()? onInitstate;

  /// A callback function that is called when the widget is disposed.
  final void Function()? onDispose;

  const GscanKit({
    super.key,
    this.fit = BoxFit.cover,
    this.controller,
    this.validator,
    this.onDetect,
    this.onDetectError,
    this.errorBuilder,
    this.useAppLifecycleState = true,
    this.setPortraitOrientation = true,
    this.extendBodyBehindAppBar = true,
    this.appBar,
    this.bottomSheetBuilder,
    this.floatingOption,
    this.placeholderBuilder,
    this.scanWindow,
    this.scanWindowUpdateThreshold = 0.0,
    this.gscanOverlayConfig = const GscanOverlayConfig(),
    this.customOverlayBuilder,
    this.onInitstate,
    this.onDispose,
  });

  @override
  State<GscanKit> createState() => _GscanKitState();
}

class _GscanKitState extends State<GscanKit> {
  final ValueNotifier<bool?> _isSuccess = ValueNotifier<bool?>(null);
  late MobileScannerController _controller;
  // State variable to store the initial zoom scale upon starting a pinch gesture.
  double _baseZoomScale = 0.0;

  // A timer to reset the overlay color after a scan.
  Timer? _colorResetTimer;

  @override
  void initState() {
    super.initState();
    if (widget.setPortraitOrientation) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    _controller =
        widget.controller ?? MobileScannerController(returnImage: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Call the onInitstate callback if provided.
      widget.onInitstate?.call();
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed to prevent memory leaks.
    _colorResetTimer?.cancel();

    if (widget.controller == null) {
      _controller.dispose();
    }
    // Restore preferred orientations if they were set
    if (widget.setPortraitOrientation) {
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    }
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Unsupported platforms return a message.
    if (UniversalPlatform.isWindows || UniversalPlatform.isLinux) {
      return Scaffold(
        appBar: widget.appBar?.call(context, _controller),
        body: Center(
          child: SelectableText.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      'This platform(${UniversalPlatform.operatingSystem}) is not supported.\nPlease visit ',
                ),
                TextSpan(
                  text:
                      'https://pub.dev/packages/mobile_scanner#platform-support',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                TextSpan(text: ' for more information.'),
              ],
            ),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      );
    }

    // This makes it responsive and correctly positioned on any screen.
    final gscanOverlayConfig = widget.gscanOverlayConfig;
    final isNoRect = gscanOverlayConfig.scannerScanArea == ScannerScanArea.full;
    final screenSize = MediaQuery.sizeOf(context);

    // Default scan window dimensions based on the screen size.
    final defaultScanWindowWidth = isNoRect
        ? screenSize.width
        : screenSize.width * 0.8;
    final defaultScanWindowHeight = isNoRect
        ? screenSize.height
        : screenSize.height * 0.36;
    final defaultScanWindow = Rect.fromCenter(
      center: screenSize.center(Offset.zero),
      width: defaultScanWindowWidth,
      height: defaultScanWindowHeight,
    );

    // NEW: Use the provided scanWindow or the default one.
    final Rect scanWindow = widget.scanWindow ?? defaultScanWindow;

    return Scaffold(
      appBar:
          widget.appBar?.call(context, _controller) ??
          AppBar(backgroundColor: Colors.transparent),
      extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
      bottomSheet: widget.bottomSheetBuilder?.call(context, _controller),
      body: GestureDetector(
        onScaleStart: (details) {
          _baseZoomScale = _controller.value.zoomScale;
          setState(() {});
        },
        onScaleUpdate: (details) {
          // The `details.scale` is a multiplier (e.g., 1.2 for 20% zoom in).
          // We calculate the change (`delta`) from the start of the gesture.
          final double delta = details.scale - 1.0;

          // Add the delta to the base zoom scale.
          final double newZoomScale = _baseZoomScale + delta;

          // Set the new zoom scale, ensuring it's within the valid range [0.0, 1.0].
          _controller.setZoomScale(newZoomScale.clamp(0.0, 1.0));
          setState(() {});
        },
        child: Stack(
          children: [
            MobileScanner(
              key: widget.key,
              controller: _controller,
              onDetect: _onDetect,
              fit: widget.fit,
              scanWindow: scanWindow,
              errorBuilder:
                  widget.errorBuilder ??
                  (context, error) => ErrorBuilder(error: error),
              placeholderBuilder: widget.placeholderBuilder,
              scanWindowUpdateThreshold: widget.scanWindowUpdateThreshold,
              overlayBuilder: (context, overlay) =>
                  ValueListenableBuilder<bool?>(
                    valueListenable: _isSuccess,
                    builder: (context, isSuccess, child) {
                      return widget.customOverlayBuilder?.call(
                            context,
                            overlay,
                            _controller,
                            isSuccess,
                          ) ??
                          ScannerOverlay(
                            scanWindow: scanWindow,
                            config: widget.gscanOverlayConfig,
                            isSuccess: isSuccess,
                          );
                    },
                  ),
              onDetectError:
                  widget.onDetectError ??
                  (error, stackTrace) {
                    debugPrint('Error during barcode detection: $error');
                  },
              useAppLifecycleState: widget.useAppLifecycleState,
            ),
            Align(
              alignment: Alignment.lerp(
                Alignment.bottomCenter,
                Alignment.center,
                0.42,
              )!,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: widget.floatingOption ?? [],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// REFACTORED: Renamed for clarity and improved error handling.
  void _onDetect(BarcodeCapture capture) {
    _colorResetTimer?.cancel();
    try {
      // If no validator is passed, treat as valid by default
      final isValid = widget.validator?.call(capture) ?? true;

      _isSuccess.value = isValid;

      if (isValid) {
        widget.onDetect?.call(capture);
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.heavyImpact();
      }
    } catch (e) {
      _isSuccess.value = false;
      debugPrint('Error during barcode validation: $e');
    }

    _colorResetTimer = Timer(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _isSuccess.value = null;
      }
    });
  }
}
