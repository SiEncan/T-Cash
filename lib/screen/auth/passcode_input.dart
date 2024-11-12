import 'package:fintar/services/passcode_checker.dart';
import 'package:fintar/widgets/modal.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PasscodeModal extends StatelessWidget {
  PasscodeModal({super.key});
  final passcodeChecker = PasscodeChecker();

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
            autoFocus: true,
            showCursor: false,
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
                  await passcodeChecker.verifyPasscode(context, value);
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
                        Icons.close_outlined,
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

  static Future<bool> showPasscodeModal(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return PasscodeModal();
      },
    );
    return result ?? false; // Return passcode verification result
  }
}
