import 'package:fintar/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:fintar/services/auth_services.dart';
import 'package:fintar/widgets/dismissable_dialog.dart';

class PasscodeModal extends StatelessWidget {
  const PasscodeModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Passcode Verification",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Enter your 6-digit passcode.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          PinCodeTextField(
            appContext: context,
            length: 6,
            obscureText: true,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 50,
              fieldWidth: 50,
              activeColor: Colors.blueAccent,
              inactiveColor: Colors.grey[300],
              selectedColor: Colors.blueAccent,
            ),
            animationDuration: const Duration(milliseconds: 300),
            onCompleted: (value) async {
              bool isPasscodeTrue =
                  await _verifyPasscode(context, int.parse(value));
              if (isPasscodeTrue) {
                showDismissableDialog(
                    context: context,
                    imagePath: 'img/success.png',
                    message: 'Verification Complete',
                    height: 70,
                    buttonColor: Colors.green,
                    duration: 100,
                    returnValue: true);

                // Tunggu beberapa saat sebelum menutup modal Passcode
                await Future.delayed(const Duration(seconds: 2));

                Navigator.pop(context); // Lanjutkan transaksi
              } else {
                // Tampilkan dialog kesalahan
                showDismissableDialog(
                    context: context,
                    imagePath: 'img/failed.png',
                    message: 'Wrong Passcode',
                    height: 70,
                    buttonColor: Colors.green,
                    duration: 100,
                    returnValue: false);

                await Future.delayed(const Duration(seconds: 2));
                Navigator.pop(context); // Batalkan transaksi
              }
            },
          )
        ],
      ),
    );
  }

  Future<bool> _verifyPasscode(
      BuildContext context, int enteredPasscode) async {
    final authService = AuthService();
    final userId = authService.getUserId();
    final passcodeRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    try {
      final docSnapshot = await passcodeRef.get();
      if (docSnapshot.exists) {
        final storedPasscode = docSnapshot.data()?['passcode'];
        if (storedPasscode == enteredPasscode) {
          // Passcode benar
          return true;
        } else {
          return false;
        }
      } else {
        // User tidak ditemukan
        return false;
      }
    } catch (e) {
      print("Terjadi kesalahan saat mengambil passcode: $e");
      return false;
    }
  }

  // Fungsi untuk menampilkan modal
  static Future<bool> showPasscodeModal(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return const PasscodeModal(); // Panggil widget modal
      },
    );
    return result ?? false; // hasil return passcode sesuai/tidak
  }
}
