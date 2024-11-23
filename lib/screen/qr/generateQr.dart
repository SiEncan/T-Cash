import 'package:fintar/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class UserQRCode extends StatelessWidget {
  final authService = AuthService();
  UserQRCode({super.key});

  @override
  Widget build(BuildContext context) {
    String userId = authService.getUserId();
    return Scaffold(
      appBar: AppBar(
        title: const Text("My QR Code"),
      ),
      body: Center(
        child: PrettyQr(
          size: 200.0,
          data: userId,
          errorCorrectLevel: QrErrorCorrectLevel.M,
          roundEdges: true,
        ),
      ),
    );
  }
}
