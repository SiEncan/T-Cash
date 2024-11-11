import 'package:fintar/widgets/modal.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:fintar/services/auth_services.dart';

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
                // tunggu modal tertutup baru melanjutkan
                await showModalBottomSheet(
                  context: context,
                  isDismissible: false,
                  enableDrag: false,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) {
                    return AutoCloseBottomSheet(
                      title: "You're All Set!",
                      icon: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 60,
                      ),
                      message: 'You can now complete your transaction.',
                      buttonText: 'OK',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                );

                Navigator.pop(context, true);
              } else {
                // Show error dialog
                await showModalBottomSheet(
                  context: context,
                  isDismissible: false,
                  enableDrag: false,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) {
                    return AutoCloseBottomSheet(
                      title: "Incorrect Passcode!",
                      icon: const Icon(
                        Icons.check_circle,
                        color: Colors.red,
                        size: 60,
                      ),
                      message:
                          'The passcode you entered is incorrect. Please try again.',
                      buttonText: 'OK',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                );

                Navigator.pop(context, false);
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
        return storedPasscode == enteredPasscode;
      } else {
        return false;
      }
    } catch (e) {
      print("Terjadi kesalahan saat mengambil passcode: $e");
      return false;
    }
  }

  static Future<bool> showPasscodeModal(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return const PasscodeModal();
      },
    );
    return result ?? false; // Return passcode verification result
  }
}
