// lib/src/overlay_clipper.dart
import 'package:flutter/material.dart';

/// A custom clipper that creates a "cutout" effect for the scanner overlay.
/// REFACTORED: This now uses a Rect directly instead of hardcoded percentages.
class OverlayClipper extends CustomClipper<Path> {
  OverlayClipper({required this.scanWindow, this.borderRadius = 16.0});

  final Rect scanWindow;
  final double borderRadius;

  @override
  Path getClip(Size size) {
    // Create a rounded rectangle for the transparent scan window area.
    final RRect roundedRect = RRect.fromRectAndRadius(
      scanWindow,
      Radius.circular(borderRadius),
    );

    // Create a path for the entire screen and then cut out the rounded rectangle.
    return Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(roundedRect)
      ..fillType = PathFillType.evenOdd; // This creates the cutout effect.
  }

  @override
  bool shouldReclip(covariant OverlayClipper oldClipper) {
    // Reclip if the scan window or border radius changes.
    return scanWindow != oldClipper.scanWindow ||
        borderRadius != oldClipper.borderRadius;
  }
}
