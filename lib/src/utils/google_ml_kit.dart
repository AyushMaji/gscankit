import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:path_provider/path_provider.dart';

Future<Map<String, dynamic>?> parseBarcodeFromCapture(
  BarcodeCapture capture,
) async {
  if (capture.barcodes.isEmpty || capture.image == null) {
    return null;
  }

  File? file;
  try {
    // Save Uint8List as temp file
    file = await convertUint8ListToFile(capture.image!, "dammi.png");

    // Convert file to InputImage
    final inputImage = InputImage.fromFile(file);
    final barcodeScanner = BarcodeScanner();

    // Process image
    final barcodes = await barcodeScanner.processImage(inputImage);
    await barcodeScanner.close();

    // Prepare result map
    final Map<String, dynamic> result = {};

    for (final barcode in barcodes) {
      result['type'] = barcode.type.name;
      result['value'] = barcode.displayValue;
      log('Type: ${barcode.type}');
      log('Value: ${barcode.displayValue}');
    }

    return result.isNotEmpty ? result : null;
  } catch (e) {
    log('Error parsing barcode: $e');
    return null;
  } finally {
    if (file != null && await file.exists()) {
      await file.delete();
      log('Temporary file deleted: ${file.path}');
    }
  }
}

Future<File> convertUint8ListToFile(Uint8List data, String filename) async {
  final dir = await getTemporaryDirectory();
  final filePath = '${dir.path}/$filename';
  final file = File(filePath);
  return await file.writeAsBytes(data);
}
