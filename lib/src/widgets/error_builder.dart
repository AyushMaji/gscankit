// lib/src/error_builder.dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// A widget that displays an error message when the camera fails to start.
/// REFACTORED: Now accepts an error object to provide more context.
class ErrorBuilder extends StatelessWidget {
  const ErrorBuilder({
    super.key,
    required this.error,
  });

  /// The exception that occurred.
  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.no_photography_outlined,
              size: 68,
              color: colorScheme.onSurface,
            ),
            const SizedBox(height: 12),
            Text(
              "Could not start the camera",
              style:
                  textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
            ),
            const SizedBox(height: 8),
            // NEW: Display the specific error message from the scanner.
            Text(
              error.errorDetails?.message ?? 'An unknown error occurred.',
              textAlign: TextAlign.center,
              style:
                  textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}
