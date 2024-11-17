import 'package:fintar/screen/auth/passcode_create.dart';
import 'package:fintar/screen/auth/passcode_input.dart';
import 'package:fintar/services/auth_services.dart';
import 'package:fintar/services/passcode_checker.dart';
import 'package:fintar/services/saldo_services.dart';
import 'package:fintar/services/transaction_services.dart';
import 'package:fintar/widgets/custom_dialog.dart';
import 'package:fintar/widgets/custom_page_transition.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class PlnGridWidget extends StatelessWidget {
  final String customerName;
  final String meterNumber;

  PlnGridWidget({
    super.key,
    required this.customerName,
    required this.meterNumber,
  });

  final NumberFormat numberFormat = NumberFormat('#,###', 'id_ID');
  final List<int> tokenAmounts = [20, 50, 100, 200, 500, 1000];
  final passcodeChecker = PasscodeChecker();
  final authService = AuthService();
  final SaldoService _saldoService = SaldoService();
  final TransactionService _transactionService = TransactionService();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tokenAmounts.length + 1, // tambah 1 untuk "CHOOSE TOKEN"
      itemBuilder: (context, index) {
        if (index == 0) {
          // text ini item pertama
          return Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text(
              'CHOOSE TOKEN',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          );
        }
        final int nominal = tokenAmounts[index - 1];
        final int price = nominal * 1000 + 1500;
        String formattedPrice = numberFormat.format(price);

        String tokenDisplay;
        if (nominal < 1000) {
          tokenDisplay = '$nominal.000';
        } else {
          tokenDisplay = '1.000.000';
        }

        return Card(
          color: Colors.white,
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
            title: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (nominal < 1000)
                        ? RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '$nominal',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                WidgetSpan(
                                  child: Transform.translate(
                                    offset: const Offset(2, -2),
                                    child: const Text(
                                      'k',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: '1',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                WidgetSpan(
                                  child: Transform.translate(
                                    offset: const Offset(2, -2),
                                    child: const Text(
                                      'Mil',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(height: 32),
                    Text(
                      'Rp $formattedPrice',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue[500],
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                const Spacer(),
                Image.asset(
                  'img/Logo_PLN.png',
                  height: 80,
                  width: 80,
                ),
              ],
            ),
            onTap: () {
              showModal(context, customerName, meterNumber, tokenDisplay,
                  formattedPrice);
            },
          ),
        );
      },
    );
  }

  Future<dynamic> showModal(BuildContext context, String customerName,
      String meterNumber, String tokenDisplay, String price) {
    return showModalBottomSheet(
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
                            // Receiver Name
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
                            // Phone Number
                            Text(
                              'Meter Number:',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              meterNumber,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 57, 57, 57),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Divider(height: 30, color: Colors.grey),
                            // Purchase Detail
                            Text(
                              'Purchase Detail',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            Image.asset(
                              'img/Logo_PLN.png',
                              width: 80,
                              height: 110,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Token PLN $tokenDisplay',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Divider(height: 30, color: Colors.grey),
                            // Payment Detail
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
                                  'Price:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '  Rp$price',
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
                                  const TextSpan(
                                    text: 'Terms and Conditions',
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 12),
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
                          confirmButton(context, price, tokenDisplay),
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

  Expanded confirmButton(
      BuildContext context, String price, String tokenDisplay) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () async {
          bool isPasscodeExist = await passcodeChecker.checkIfPasscodeExists();
          if (!isPasscodeExist) {
            Navigator.of(context).push(createRoute(CreatePasscode(), 0, 1));
            return;
          }
          String userId = authService.getUserId();
          int hargaFormatted = int.parse(price.replaceAll('.', ''));

          bool isPasscodeTrue = await PasscodeModal.showPasscodeModal(context);
          if (!isPasscodeTrue) {
            return;
          }

          bool isSaldoSufficient =
              await _saldoService.reduceSaldo(userId, hargaFormatted);

          if (isSaldoSufficient) {
            await _transactionService.saveTransaction(
                userId, hargaFormatted, 'Payment', 'Token PLN $tokenDisplay');

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
