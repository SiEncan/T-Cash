import 'package:fintar/screen/auth/passcode_create.dart';
import 'package:fintar/screen/auth/passcode_input.dart';
import 'package:fintar/screen/profile/userprofilecomponents/terms_conditions.dart';
import 'package:fintar/services/auth_services.dart';
import 'package:fintar/services/passcode_checker.dart';
import 'package:fintar/services/saldo_services.dart';
import 'package:fintar/services/transaction_services.dart';
import 'package:fintar/widgets/custom_dialog.dart';
import 'package:fintar/widgets/custom_page_transition.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class TransactionDetailsModal extends StatelessWidget {
  final String customerName;
  final String serviceName;
  final String? serviceImage;
  final String? recipientInfo;
  final String? expiryDate;
  final IconData? icon;
  final int amount;

  final authService = AuthService();
  final passcodeChecker = PasscodeChecker();
  final SaldoService saldoService = SaldoService();
  final TransactionService transactionService = TransactionService();

  TransactionDetailsModal({
    super.key,
    required this.customerName,
    required this.serviceName,
    this.recipientInfo,
    this.serviceImage,
    this.icon,
    this.expiryDate,
    required this.amount,
  });

  String _formatAmount(dynamic amount) {
    String text = amount is int ? amount.toString() : amount.toString();

    if (text.isEmpty) return '';
    final number = int.parse(text.replaceAll(RegExp(r'[^0-9]'), ''));

    return 'Rp${number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  String generateVoucherId() {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return List.generate(
        12, (index) => characters[random.nextInt(characters.length)]).join();
  }

  @override
  Widget build(BuildContext context) {
    // The body should return a widget here.
    return GestureDetector(
      onTap: () {
        // Show the modal when the widget is tapped
        showCustomModal(context);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.transparent,
        child: const Text(
          "Tap to Show Transaction Modal",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  // Method for showing the modal
  Future<void> showCustomModal(BuildContext context) async {
    // Then call the modal
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 105),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Transaction Details",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const Divider(height: 30, color: Colors.grey),
                            Text(
                              'Customer Name',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              customerName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              serviceName.contains('PLN')
                                  ? 'Meter Number'
                                  : serviceName.contains('Pulsa') ||
                                          serviceName.contains('Top-Up')
                                      ? 'Phone Number'
                                      : (serviceName.contains('iCloud') ||
                                              serviceName.contains('Apple'))
                                          ? 'ICloud E-Mail'
                                          : 'Expiry Date',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              (expiryDate?.isNotEmpty == true
                                      ? expiryDate
                                      : recipientInfo) ??
                                  '-',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 57, 57, 57),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Divider(height: 30, color: Colors.grey),
                            Text(
                              'Purchase Detail',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            (serviceName.contains('Top-Up'))
                                ? ClipOval(
                                    child: Image.asset(
                                      serviceImage!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : (serviceName.contains('PLN'))
                                    ? Image.asset(
                                        serviceImage!,
                                        width: 80,
                                        height: 110,
                                      )
                                    : (serviceName.contains('Pulsa'))
                                        ? Image.asset(
                                            serviceImage!,
                                            width: 120,
                                            height: 60,
                                          )
                                        : (serviceName.contains('iCloud') ||
                                                serviceName.contains('Apple'))
                                            ? Icon(icon,
                                                color: Colors.black, size: 50)
                                            : ClipOval(
                                                child: Image.asset(
                                                  serviceImage!,
                                                  width: 80,
                                                  height: 80,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                            const SizedBox(height: 10),
                            Text(
                              serviceName,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Divider(height: 30, color: Colors.grey),
                            Text(
                              'Payment Detail',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  'Price: ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  _formatAmount(amount),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 15,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(78, 50, 50, 50),
                        blurRadius: 8,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        'All your transactions are secure and fast. By continuing, you agree to the ',
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 12),
                                  ),
                                  TextSpan(
                                    text: 'Terms and Conditions',
                                    style: const TextStyle(
                                        color: Colors.green, fontSize: 12),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context).push(createRoute(
                                            const TermsConditions(), 0, 1));
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          cancelButton(context),
                          const SizedBox(width: 12),
                          confirmButton(context),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Expanded confirmButton(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () async {
          bool isPasscodeExist = await passcodeChecker.checkIfPasscodeExists();
          if (!isPasscodeExist) {
            Navigator.of(context).push(createRoute(CreatePasscode(), 0, 1));
            return;
          }

          if (recipientInfo?.trim() == '') {
            Navigator.pop(context);

            return showCustomDialog(
              context: context,
              imagePath: 'img/failed.png',
              message: serviceName.contains('Pulsa') ||
                      serviceName.contains('Top-Up')
                  ? 'Please fill out phone number.'
                  : serviceName.contains('PLN')
                      ? 'Please fill out meter number'
                      : 'Please fill out ICloud E-Mail.',
              height: 100,
              buttonColor: Colors.red,
            );
          }

          String userId = authService.getUserId();

          bool isPasscodeTrue = await PasscodeModal.showPasscodeModal(context);
          if (!isPasscodeTrue) {
            return;
          }

          bool isSaldoSufficient =
              await saldoService.reduceSaldo(userId, amount);

          if (isSaldoSufficient) {
            String voucherId = '';
            if (serviceName.contains('Voucher')) {
              voucherId = generateVoucherId();
            }
            await transactionService.saveTransaction(
              userId,
              'Payment',
              amount: amount,
              description: serviceName,
              additionalInfo: serviceName.contains('Pulsa') ||
                      serviceName.contains('Top-Up')
                  ? 'Nomor Tujuan: $recipientInfo'
                  : serviceName.contains('PLN')
                      ? 'Meter Number: $recipientInfo'
                      : serviceName.contains('Voucher')
                          ? 'Voucher ID: $voucherId'
                          : 'iCloud E-Mail: $recipientInfo',
            );

            Navigator.pop(context);

            showCustomDialog(
              context: context,
              imagePath: 'img/success.png',
              message: 'Payment confirmed! Your purchase is being processed.',
              height: 100,
              buttonColor: Colors.green,
            );
          } else {
            Navigator.pop(context);

            showCustomDialog(
              context: context,
              imagePath: 'img/failed.png',
              message: 'Insufficient balance. Please top-up your account.',
              height: 100,
              buttonColor: Colors.red,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.blueAccent,
        ),
        child: const Text(
          "Confirm Payment",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Expanded cancelButton(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: Colors.grey[400]!),
        ),
        child: const Text(
          "Cancel",
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
