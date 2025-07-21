// lib/src/scanner_line_painter.dart
import 'package:flutter/material.dart';

/// A custom painter for the animated scanning line.
class ScanningLinePainter extends CustomPainter {
  ScanningLinePainter({
    required this.animationValue,
    required this.scanWindow,
    this.animationColor = Colors.red,
    this.lineThickness = 4.0,
    // NEW: Added borderRadius to enable clipping.
    this.borderRadius = 16.0,
  });

  final double animationValue;
  final Rect scanWindow;
  final Color animationColor;
  final double lineThickness;
  // NEW: Property to hold the border radius for the clipping mask.
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    // NEW: Create a rounded rectangle path for the scan window area.
    final clipRRect = RRect.fromRectAndRadius(
      scanWindow,
      Radius.circular(borderRadius),
    );

    // NEW: Apply the clipping path. Any drawing operations that occur
    // after this will be confined to the area of this rounded rectangle.
    canvas.clipRRect(clipRRect);

    // Calculate the vertical position of the scanning line within the scan window.
    final lineY = scanWindow.top + (animationValue * scanWindow.height);

    final lineRect = Rect.fromLTWH(
      scanWindow.left,
      lineY - lineThickness / 2,
      scanWindow.width,
      lineThickness,
    );

    // Create a gradient for the scanning line for a "glow" effect.
    final linePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          animationColor.withValues(alpha: 0.0),
          animationColor,
          animationColor.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(lineRect);

    canvas.drawRect(lineRect, linePaint);
  }

  @override
  bool shouldRepaint(covariant ScanningLinePainter oldDelegate) {
    // UPDATED: Repaint if the animation value or border radius changes.
    return animationValue != oldDelegate.animationValue ||
        borderRadius != oldDelegate.borderRadius;
  }
}
