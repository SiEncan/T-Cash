import 'package:flutter/material.dart';

Future<void> showDismissableDialog({
  required BuildContext context,
  required String imagePath,
  required String message,
  required double height,
  required Color buttonColor,
  required int duration,
  required bool returnValue,
}) async {
  await showGeneralDialog(
    context: context,
    barrierDismissible: false, //  dialog tidak tertutup saat ditap di luar
    barrierLabel: "Dialog",
    pageBuilder: (context, animation, secondaryAnimation) {
      return const SizedBox.shrink();
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final scaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        ),
      );

      return ScaleTransition(
        scale: scaleAnimation,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  imagePath,
                  height: height,
                ),
                const SizedBox(height: 20),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
  );

  // Tunggu durasi sebelum menutup dialog
  await Future.delayed(Duration(milliseconds: duration));
  Navigator.pop(context, returnValue); // Menutup dialog setelah durasi selesai
}
