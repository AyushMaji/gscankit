// lib/src/scanner_border_painter.dart
import 'package:flutter/material.dart';
import 'package:gscankit/src/overlay/overlay.dart';

/// A custom painter for drawing the border of the scan window.
/// REFACTORED: Merged ScannerBorderPainter and ScannerCornerPainter into one.
/// This painter can now draw corners, a full border, or nothing.
class ScannerCornerPainter extends CustomPainter {
  ScannerCornerPainter({
    required this.scanWindow,
    this.borderColor = Colors.green,
    this.cornerRadius = 16.0,
    this.borderRadius = 16.0,
    this.borderType = ScannerBorder.visible,
    this.cornerLength = 30.0,
  });

  final Rect scanWindow;
  final Color borderColor;
  final double cornerRadius;
  final double borderRadius;
  final ScannerBorder borderType;
  final double cornerLength;

  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;

    final RRect rrect = RRect.fromRectAndRadius(
      scanWindow,
      Radius.circular(borderRadius),
    );

    switch (borderType) {
      case ScannerBorder.visible:
        final path = Path()
          // Top-left corner
          ..moveTo(rrect.left, rrect.top + cornerLength)
          ..lineTo(rrect.left, rrect.top + cornerRadius)
          ..arcToPoint(
            Offset(rrect.left + cornerRadius, rrect.top),
            radius: Radius.circular(cornerRadius),
            clockwise: true,
          )
          ..lineTo(rrect.left + cornerLength, rrect.top)
          // Top-right corner
          ..moveTo(rrect.right - cornerLength, rrect.top)
          ..lineTo(rrect.right - cornerRadius, rrect.top)
          ..arcToPoint(
            Offset(rrect.right, rrect.top + cornerRadius),
            radius: Radius.circular(cornerRadius),
            clockwise: true,
          )
          ..lineTo(rrect.right, rrect.top + cornerLength)
          // Bottom-left corner
          ..moveTo(rrect.left, rrect.bottom - cornerLength)
          ..lineTo(rrect.left, rrect.bottom - cornerRadius)
          ..arcToPoint(
            Offset(rrect.left + cornerRadius, rrect.bottom),
            radius: Radius.circular(cornerRadius),
            clockwise: false,
          )
          ..lineTo(rrect.left + cornerLength, rrect.bottom)
          // Bottom-right corner
          ..moveTo(rrect.right - cornerLength, rrect.bottom)
          ..lineTo(rrect.right - cornerRadius, rrect.bottom)
          ..arcToPoint(
            Offset(rrect.right, rrect.bottom - cornerRadius),
            radius: Radius.circular(cornerRadius),
            clockwise: false,
          )
          ..lineTo(rrect.right, rrect.bottom - cornerLength);

        canvas.drawPath(path, borderPaint);
        break;
      case ScannerBorder.none:
        break;
    }
  }

  @override
  bool shouldRepaint(covariant ScannerCornerPainter oldDelegate) {
    return scanWindow != oldDelegate.scanWindow ||
        borderColor != oldDelegate.borderColor ||
        borderType != oldDelegate.borderType;
  }
}
