import 'package:fintar/screen/qr/transferPage.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanner extends StatefulWidget {
  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  MobileScannerController cameraController = MobileScannerController();
  bool isScanned = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    cameraController.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) async {
          if (!isScanned) {
            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              final String? uid = barcode.rawValue;
              debugPrint('Barcode found: $uid');

              if (uid != null) {
                setState(() {
                  isScanned = true;
                });

                cameraController.stop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransferPage(uid: uid),
                  ),
                );
              }
            }
          }
        },
      ),
    );
  }
}
