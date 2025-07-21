import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gscankit/gscancore.dart';

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
  MobileScannerController controller = MobileScannerController(
    returnImage: true,
  );
  bool isTorchOn = false;
  @override
  void initState() {
    isTorchOn = controller.value.torchState == TorchState.on;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => GscanKit(
                      controller: controller,
                      // appBar: (p0, p1) {
                      //   return AppBar(backgroundColor: Colors.transparent);
                      // },
                      onDetect: (BarcodeCapture capture) {},
                      // bottomSheetBuilder: (context, controller) {
                      //   return Container(height: 90, color: Colors.amber);
                      // },
                      // floatingOption: [
                      //   IconButton.filled(
                      //     style: IconButton.styleFrom(
                      //       backgroundColor: CupertinoColors.systemGrey6,
                      //       foregroundColor: CupertinoColors.darkBackgroundGray,
                      //     ),
                      //     icon: Icon(CupertinoIcons.camera_rotate),
                      //     onPressed: () => controller.switchCamera(),
                      //   ),
                      //   IconButton.filled(
                      //     style: IconButton.styleFrom(
                      //       backgroundColor: isTorchOn
                      //           ? CupertinoColors.activeOrange
                      //           : CupertinoColors.systemGrey6,
                      //       foregroundColor: CupertinoColors.darkBackgroundGray,
                      //     ),
                      //     icon: Icon(
                      //       isTorchOn
                      //           ? CupertinoIcons.light_max
                      //           : CupertinoIcons.light_min,
                      //     ),
                      //     onPressed: () {
                      //       controller.toggleTorch();
                      //       setState(() {});
                      //     },
                      //   ),
                      // ],
                    ),
                  ),
                );
              },
              child: const Text('Open Scanner'),
            ),
          ],
        ),
      ),
    );
  }
}
