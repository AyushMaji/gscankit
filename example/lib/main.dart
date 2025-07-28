import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gscankit/gscankit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isBottomSheetOpen = false;
  MobileScannerController controller = MobileScannerController(
    returnImage: true,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gscan kit"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GscanKit(
                        controller: controller,
                        onDetect: (BarcodeCapture capture) {},
                      ),
                    ),
                  );
                },
                child: const Text('Default Scanner'),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GscanKit(
                        controller: controller,
                        onDetect: (BarcodeCapture capture) {},
                        gscanOverlayConfig: GscanOverlayConfig(
                          scannerScanArea: ScannerScanArea.full,
                        ),
                        floatingOption: [
                          ValueListenableBuilder(
                            valueListenable: controller,
                            builder: (context, state, child) {
                              final isTorchOn =
                                  state.torchState == TorchState.on;
                              return TorchToggleButton(
                                isTorchOn: isTorchOn,
                                onPressed: () => controller.toggleTorch(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: const Text('Full Page Scanner'),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GscanKit(
                        controller: controller,
                        onDetect: (BarcodeCapture capture) {},
                        floatingOption: [
                          IconButton.filled(
                            style: IconButton.styleFrom(
                              backgroundColor: CupertinoColors.systemGrey6,
                              foregroundColor:
                                  CupertinoColors.darkBackgroundGray,
                            ),
                            icon: Icon(CupertinoIcons.camera_rotate),
                            onPressed: () => controller.switchCamera(),
                          ),
                          ValueListenableBuilder(
                            valueListenable: controller,
                            builder: (context, state, child) {
                              final isTorchOn =
                                  state.torchState == TorchState.on;
                              return TorchToggleButton(
                                isTorchOn: isTorchOn,
                                onPressed: () => controller.toggleTorch(),
                              );
                            },
                          ),
                          GalleryButton(
                            controller: controller,
                            icon: Icon(CupertinoIcons.photo, size: 18),
                            isSuccess: ValueNotifier<bool?>(null),
                          ),
                        ],
                        gscanOverlayConfig: GscanOverlayConfig(
                          scannerScanArea: ScannerScanArea.center,
                          scannerBorder: ScannerBorder.visible,
                          scannerBorderPulseEffect:
                              ScannerBorderPulseEffect.enabled,
                          borderColor: Colors.white,
                          borderRadius: 24.0,
                          scannerLineAnimationColor: Colors.green,
                          scannerOverlayBackground:
                              ScannerOverlayBackground.blur,
                          scannerLineAnimation: ScannerLineAnimation.enabled,
                        ),
                      ),
                    ),
                  );
                },
                child: const Text('Scanner with '),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GscanKit(
                        onInitstate: () {},
                        appBar: (context, controller) {
                          return AppBar(
                            title: Text("Gscan"),
                            leading: Icon(Icons.arrow_back_ios),
                            backgroundColor: Colors.transparent,
                            actions: [
                              IconButton.filled(
                                style: IconButton.styleFrom(
                                  backgroundColor: CupertinoColors.systemGrey6,
                                  foregroundColor:
                                      CupertinoColors.darkBackgroundGray,
                                ),
                                icon: Icon(CupertinoIcons.camera_rotate),
                                onPressed: () => controller.switchCamera(),
                              ),
                              ValueListenableBuilder(
                                valueListenable: controller,
                                builder: (context, state, child) {
                                  final isTorchOn =
                                      state.torchState == TorchState.on;
                                  return TorchToggleButton(
                                    isTorchOn: isTorchOn,
                                    onPressed: () => controller.toggleTorch(),
                                  );
                                },
                              ),
                              SizedBox(width: 10),
                            ],
                          );
                        },
                        controller: controller,
                        onDetect: (BarcodeCapture capture) {
                          if (isBottomSheetOpen) return;
                          if (capture.barcodes == []) return;
                          isBottomSheetOpen = true;
                          setState(() {});
                          try {
                            parseBarcodeFromCapture(capture).then((file) {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Detected Barcodes",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        SizedBox(height: 10),
                                        ...capture.barcodes.map((barcode) {
                                          return ListTile(
                                            title: Text(
                                              file!["type"] ?? "Unknown",
                                            ),
                                            subtitle: Text(
                                              file!["value"] ?? "Unknown",
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  );
                                },
                              );
                              isBottomSheetOpen = false;
                              setState(() {});
                            });
                          } catch (e) {
                            log('');
                          }
                          setState(() {});
                          // // write buttom sheet
                        },
                        floatingOption: [
                          GalleryButton(
                            controller: controller,
                            isSuccess: ValueNotifier<bool?>(null),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors
                                    .grey
                                    .shade200, // Change to your preferred color
                                borderRadius: BorderRadius.circular(
                                  30,
                                ), // Makes it rounded
                              ),
                              width: 120,
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.photo, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    "Upload",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        gscanOverlayConfig: GscanOverlayConfig(
                          scannerOverlayBackground:
                              ScannerOverlayBackground.blur,
                          scannerBorderPulseEffect:
                              ScannerBorderPulseEffect.none,
                        ),
                      ),
                    ),
                  );
                },
                child: const Text('Scanner with Appbar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A reusable torch toggle button using a custom asset icon.
class TorchToggleButton extends StatelessWidget {
  final bool isTorchOn;
  final VoidCallback onPressed;
  const TorchToggleButton({
    super.key,
    required this.isTorchOn,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      style: IconButton.styleFrom(
        backgroundColor: isTorchOn ? Colors.black : Colors.white,
        foregroundColor: isTorchOn ? Colors.white : Colors.black,
      ),
      icon: Image.asset(
        'assets/torch.png',
        width: 40,
        height: 40,
        color: isTorchOn ? Colors.white : Colors.black,
      ),
      onPressed: onPressed,
    );
  }
}
