// lib/src/overlay.dart
import 'dart:ui' show ImageFilter;

import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gscankit/src/painters/gscan_border_painter.dart';
import 'package:gscankit/src/painters/gscan_line_painter.dart';
import 'overlay_clipper.dart';

const _kBorderRadius = 24.0;

enum ScannerScanArea { full, center }

enum ScannerBorder { visible, none }

enum ScannerBorderPulseEffect { enabled, none }

enum ScannerOverlayBackground { blur, none }

enum ScannerLineAnimation { enabled, none }

class GscanOverlayConfig {
  final ScannerScanArea scannerScanArea;
  final ScannerOverlayBackground scannerOverlayBackground;
  final Color scannerOverlayBackgroundColor;
  final ScannerBorder scannerBorder;
  final Color borderColor;
  final double borderRadius;
  final double cornerRadius;
  final double cornerLength;
  final ScannerBorderPulseEffect scannerBorderPulseEffect;
  final ScannerLineAnimation scannerLineAnimation;
  final Color scannerLineAnimationColor;
  final Duration scannerLineanimationDuration;
  final double lineThickness;
  final Cubic? curve;
  final Animation<double>? animation;
  final Widget? background;
  final Color successColor;
  final Color errorColor;
  final bool animateOnSuccess;
  final bool animateOnError;

  const GscanOverlayConfig({
    this.scannerScanArea = ScannerScanArea.center,
    this.scannerOverlayBackground = ScannerOverlayBackground.blur,
    this.scannerOverlayBackgroundColor = CupertinoColors.systemFill,
    this.scannerBorder = ScannerBorder.visible,
    this.borderColor = CupertinoColors.white,
    this.borderRadius = _kBorderRadius,
    this.cornerRadius = _kBorderRadius,
    this.cornerLength = 60.0,
    this.scannerBorderPulseEffect = ScannerBorderPulseEffect.enabled,
    this.scannerLineAnimation = ScannerLineAnimation.enabled,
    this.scannerLineAnimationColor = CupertinoColors.systemRed,
    this.scannerLineanimationDuration = const Duration(milliseconds: 1500),
    this.lineThickness = 4,
    this.curve,
    this.background,
    this.animation,
    this.successColor = CupertinoColors.systemGreen,
    this.errorColor = CupertinoColors.systemRed,
    this.animateOnSuccess = true,
    this.animateOnError = true,
  });

  GscanOverlayConfig copyWith({
    ScannerScanArea? scannerScanArea,
    ScannerOverlayBackground? scannerOverlayBackground,
    Color? scannerOverlayBackgroundColor,
    ScannerBorder? scannerBorder,
    Color? borderColor,
    double? borderRadius,
    double? cornerRadius,
    double? cornerLength,
    ScannerBorderPulseEffect? scannerBorderPulseEffect,
    ScannerLineAnimation? scannerLineAnimation,
    Color? scannerLineAnimationColor,
    Duration? scannerLineanimationDuration,
    double? lineThickness,
    Cubic? curve,
    Animation<double>? animation,
    Widget? background,
    Color? successColor,
    Color? errorColor,
    bool? animateOnSuccess,
    bool? animateOnError,
  }) {
    return GscanOverlayConfig(
      scannerLineAnimationColor:
          scannerLineAnimationColor ?? this.scannerLineAnimationColor,
      borderColor: borderColor ?? this.borderColor,
      scannerOverlayBackgroundColor:
          scannerOverlayBackgroundColor ?? this.scannerOverlayBackgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      scannerScanArea: scannerScanArea ?? this.scannerScanArea,
      scannerBorder: scannerBorder ?? this.scannerBorder,
      scannerBorderPulseEffect:
          scannerBorderPulseEffect ?? this.scannerBorderPulseEffect,
      scannerLineAnimation: scannerLineAnimation ?? this.scannerLineAnimation,
      scannerOverlayBackground:
          scannerOverlayBackground ?? this.scannerOverlayBackground,
      curve: curve ?? this.curve,
      background: background ?? this.background,
      lineThickness: lineThickness ?? this.lineThickness,
      animation: animation ?? this.animation,
      scannerLineanimationDuration:
          scannerLineanimationDuration ?? this.scannerLineanimationDuration,
      successColor: successColor ?? this.successColor,
      errorColor: errorColor ?? this.errorColor,
      animateOnSuccess: animateOnSuccess ?? this.animateOnSuccess,
      animateOnError: animateOnError ?? this.animateOnError,
      cornerLength: cornerLength ?? this.cornerLength,
    );
  }
}

class ScannerOverlay extends StatefulWidget {
  const ScannerOverlay({
    super.key,
    required this.scanWindow,
    this.config = const GscanOverlayConfig(),
    this.isSuccess,
  });

  final Rect scanWindow;
  final GscanOverlayConfig config;
  final bool? isSuccess;

  @override
  State<ScannerOverlay> createState() => _ScannerOverlayState();
}

class _ScannerOverlayState extends State<ScannerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.config.scannerLineanimationDuration,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.config.curve ?? Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getColor(Color defaultColor, Color successColor, Color errorColor) {
    if (widget.config.animateOnSuccess && (widget.isSuccess ?? false)) {
      return successColor;
    }
    if (widget.config.animateOnError &&
        (widget.isSuccess != null && !widget.isSuccess!)) {
      return errorColor;
    }
    return defaultColor;
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;
    final screenSize = MediaQuery.of(context).size;
    final borderColor = _getColor(
      config.borderColor,
      config.successColor,
      config.errorColor,
    );
    final backgroundColor = _getColor(
      config.scannerOverlayBackgroundColor,
      config.successColor.withValues(alpha: 0.2 * 255),
      config.errorColor.withValues(alpha: 0.2 * 255),
    );

    return Stack(
      children: [
        if (config.scannerScanArea == ScannerScanArea.full) ...[
          if (config.scannerLineAnimation == ScannerLineAnimation.enabled)
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                final topPosition = _animation.value * screenSize.height;
                return Positioned(
                  top: topPosition,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 120, // A more visible height for the glowing effect
                    width: screenSize.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          config.scannerLineAnimationColor.withValues(
                            alpha: 0.0,
                          ),
                          config.scannerLineAnimationColor.withValues(
                            alpha: 0.4,
                          ),
                          config.scannerLineAnimationColor.withValues(
                            alpha: 0.0,
                          ),
                        ],
                        stops: const [0.1, 0.5, 0.9],
                      ),
                    ),
                  ),
                );
              },
            ),
        ] else ...[
          if (config.scannerOverlayBackground == ScannerOverlayBackground.blur)
            Positioned.fill(
              child: ClipPath(
                clipper: OverlayClipper(
                  scanWindow: widget.scanWindow,
                  borderRadius: config.borderRadius,
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: config.background ?? Container(color: backgroundColor),
                ),
              ),
            ),

          if (config.scannerBorder == ScannerBorder.visible &&
              config.scannerBorderPulseEffect ==
                  ScannerBorderPulseEffect.enabled)
            Positioned.fill(
                  child: CustomPaint(
                    painter: ScannerCornerPainter(
                      scanWindow: widget.scanWindow,
                      borderRadius: config.borderRadius,
                      cornerRadius: config.cornerRadius,
                      borderColor: borderColor,
                      borderType: config.scannerBorder,
                      cornerLength: config.cornerLength,
                    ),
                  ),
                )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .scale(
                  begin: const Offset(0.95, 0.95),
                  end: const Offset(1.05, 1.05),
                  duration: 1100.ms,
                  curve: Curves.easeInOut,
                ),

          if (config.scannerBorder == ScannerBorder.visible &&
              config.scannerBorderPulseEffect == ScannerBorderPulseEffect.none)
            Positioned.fill(
              child: CustomPaint(
                painter: ScannerCornerPainter(
                  scanWindow: widget.scanWindow,
                  borderRadius: config.borderRadius,
                  cornerRadius: config.cornerRadius,
                  borderColor: borderColor,
                  borderType: config.scannerBorder,
                  cornerLength: config.cornerLength,
                ),
              ),
            ),

          if (config.scannerLineAnimation == ScannerLineAnimation.enabled)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: ScanningLinePainter(
                      animationValue: _animation.value,
                      scanWindow: widget.scanWindow,
                      lineThickness: config.lineThickness,
                      animationColor: config.scannerLineAnimationColor,
                      borderRadius: config.borderRadius,
                    ),
                  );
                },
              ),
            ),
        ],
      ],
    );
  }
}
