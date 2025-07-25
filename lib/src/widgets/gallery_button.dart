// lib/src/gallery_button.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

// NEW: Using an enum for button type is safer and more readable than a string.

/// A button that allows the user to pick an image from the gallery
/// and analyze it for barcodes.
class GalleryButton extends StatelessWidget {
  final void Function(String?)? onImagePick;
  final void Function(BarcodeCapture)? onDetect;
  final bool Function(BarcodeCapture)? validator;
  final MobileScannerController controller;
  final ValueNotifier<bool?> isSuccess;
  final String text;
  final Icon? icon;
  final Widget? child;

  const GalleryButton({
    super.key,
    this.onImagePick,
    this.onDetect,
    this.validator,
    required this.controller,
    required this.isSuccess,
    this.text = 'Upload from gallery',
    this.icon,
    this.child,
  });

  /// REFACTORED: The logic for picking and analyzing the image is now cleaner.
  Future<void> _pickAndAnalyzeImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    onImagePick?.call(image?.path);

    if (image == null) return;

    final BarcodeCapture? barcodes = await controller.analyzeImage(image.path);

    if (barcodes != null) {
      bool isValid = true;
      if (validator != null) {
        isValid = validator!(barcodes);
      }

      isSuccess.value = isValid;
      HapticFeedback.lightImpact();

      if (isValid) {
        onDetect?.call(barcodes);
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.heavyImpact();
      }
    } else {
      isSuccess.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return child != null
        ? GestureDetector(onTap: _pickAndAnalyzeImage, child: child)
        : IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: CupertinoColors.systemGrey6,
              foregroundColor: CupertinoColors.darkBackgroundGray,
            ),
            icon: icon ?? Icon(CupertinoIcons.photo),
            onPressed: _pickAndAnalyzeImage,
          );
  }
}
