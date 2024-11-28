import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintar/screen/qr/transferPage.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:math' show pi;

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  QRScannerState createState() => QRScannerState();
}

class QRScannerState extends State<QRScanner> {
  MobileScannerController cameraController = MobileScannerController();
  bool isScanned = false;
  bool isValidating = false;
  bool isShowingError = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    cameraController.stop();
    super.dispose();
  }

  Future<bool> validateUID(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('Error validating UID: $e');
      return false;
    }
  }

  void showErrorMessage(BuildContext context, String message) {
    if (!isShowingError) {
      isShowingError = true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Scan Ulang',
            textColor: Colors.white,
            onPressed: () {},
          ),
          onVisible: () {
            Future.delayed(const Duration(seconds: 2), () {
              resetScanner();
            });
          },
        ),
      );
    }
  }

  void resetScanner() {
    if (mounted) {
      setState(() {
        isScanned = false;
        isValidating = false;
        isShowingError = false;
      });
    }
  }

  Widget _buildCornerBox() {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.red, width: 4),
          top: BorderSide(color: Colors.red, width: 4),
        ),
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return Stack(
      children: [
        CustomPaint(
          painter: ScannerOverlayPainter(),
          child: const SizedBox(
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Center(
          child: SizedBox(
            width: 250,
            height: 250,
            child: Stack(
              children: [
                _buildCornerBox(),
                Positioned(
                  right: 0,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationZ(pi / 2),
                    child: _buildCornerBox(),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationZ(-pi / 2),
                    child: _buildCornerBox(),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationZ(pi),
                    child: _buildCornerBox(),
                  ),
                ),
                if (isValidating)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 8),
                          Text(
                            'Validating QR Code...',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) async {
              if (!isScanned && !isValidating && !isShowingError) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  final String? uid = barcode.rawValue;
                  debugPrint('Barcode found: $uid');

                  if (uid != null) {
                    setState(() {
                      isScanned = true;
                      isValidating = true;
                    });

                    final isValid = await validateUID(uid);

                    if (isValid) {
                      cameraController.stop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransferPage(uid: uid),
                        ),
                      );
                    } else {
                      setState(() {
                        isValidating = false;
                      });
                      showErrorMessage(
                          context, 'QR Code tidak valid. Silahkan scan ulang.');
                    }
                  }
                }
              }
            },
          ),
          _buildScannerOverlay(),
        ],
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double scanAreaSize = 250;
    final double left = (size.width - scanAreaSize) / 2;
    final double top = (size.height - scanAreaSize) / 2;

    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, top, scanAreaSize, scanAreaSize),
          const Radius.circular(12),
        ),
      );

    final finalPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    canvas.drawPath(
      finalPath,
      Paint()
        ..color = Colors.black.withOpacity(0.5)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
