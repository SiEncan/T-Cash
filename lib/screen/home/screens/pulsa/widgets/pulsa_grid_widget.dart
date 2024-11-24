import 'package:fintar/screen/auth/passcode_create.dart';
import 'package:fintar/screen/profile/userprofilecomponents/terms_conditions.dart';
import 'package:fintar/services/passcode_checker.dart';
import 'package:fintar/widgets/custom_dialog.dart';
import 'package:fintar/widgets/custom_page_transition.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fintar/screen/home/screens/pulsa/widgets/pulsa_card_widget.dart';
import 'package:fintar/services/auth_services.dart';
import 'package:fintar/services/saldo_services.dart';
import 'package:fintar/services/transaction_services.dart';
import 'package:fintar/screen/auth/passcode_input.dart';

// ignore: must_be_immutable
class PulsaGrid extends StatelessWidget {
  String selectedProviderParam;
  String phoneNumber;
  String receiverName;

  PulsaGrid(
      {super.key,
      required this.selectedProviderParam,
      required this.phoneNumber,
      required this.receiverName});

  final passcodeChecker = PasscodeChecker();
  final authService = AuthService();
  final SaldoService saldoService = SaldoService();
  final TransactionService transactionService = TransactionService();

  final List<String> jumlahPulsa = [
    '5k',
    '10k',
    '15k',
    '20k',
    '25k',
    '30k',
    '40k',
    '50k',
    '60k',
    '70k',
    '80k',
    '90k',
    '100k'
  ];

  late List<String> hargaPulsa; // declare list harga pulsa

  @override
  Widget build(BuildContext context) {
    //  harga pulsa berdasarkan selected provider
    if (selectedProviderParam == 'IM3') {
      hargaPulsa = [
        '7.000',
        '12.000',
        '17.000',
        '21.000',
        '26.000',
        '31.000',
        '41.000',
        '51.000',
        '61.000',
        '71.000',
        '81.000',
        '91.000',
        '101.000'
      ];
    } else if (selectedProviderParam == 'Telkomsel') {
      hargaPulsa = [
        '8.000',
        '13.000',
        '18.000',
        '22.000',
        '28.000',
        '32.500',
        '42.500',
        '52.500',
        '62.500',
        '72.500',
        '82.500',
        '92.500',
        '102.500'
      ];
    } else if (selectedProviderParam == 'XL') {
      hargaPulsa = [
        '7.500',
        '12.500',
        '17.500',
        '21.500',
        '26.500',
        '31.500',
        '41.500',
        '51.500',
        '61.500',
        '71.500',
        '81.500',
        '91.500',
        '101.500'
      ];
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 3 / 2,
      ),
      itemCount: jumlahPulsa.length,
      itemBuilder: (context, index) {
        return InkWell(
          child: PulsaCard(
            jumlahPulsa: jumlahPulsa[index],
            hargaPulsa: 'Rp${hargaPulsa[index]}',
          ),
          onTap: () {
            showModal(context, index);
          },
        );
      },
    );
  }

  Future<dynamic> showModal(BuildContext context, int index) {
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
                              'Receiver Name',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              receiverName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Phone Number
                            Text(
                              'Phone Number',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              phoneNumber,
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
                              'img/$selectedProviderParam.png',
                              width: 120,
                              height: 60,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Pulsa: ${jumlahPulsa[index].replaceAll('k', '.000')}',
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
                                  '  Rp${hargaPulsa[index]}',
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
                          confirmButton(index, context),
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

  Expanded confirmButton(int index, BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () async {
          bool isPasscodeExist = await passcodeChecker.checkIfPasscodeExists();
          if (!isPasscodeExist) {
            Navigator.of(context).push(createRoute(CreatePasscode(), 0, 1));
            return;
          }
          String userId = authService.getUserId();
          int hargaFormatted = int.parse(hargaPulsa[index].replaceAll('.', ''));

          if (phoneNumber.trim() == '') {
            Navigator.pop(context);

            return showCustomDialog(
              context: context,
              imagePath: 'img/failed.png',
              message: 'Please fill out phone number.',
              height: 100,
              buttonColor: Colors.red,
            );
          }

          bool isPasscodeTrue = await PasscodeModal.showPasscodeModal(context);
          if (!isPasscodeTrue) {
            return;
          }

          bool isSaldoSufficient =
              await saldoService.reduceSaldo(userId, hargaFormatted);

          if (isSaldoSufficient) {
            await transactionService.saveTransaction(userId, 'Payment',
                amount: hargaFormatted,
                description:
                    'Pulsa $selectedProviderParam ${jumlahPulsa[index].replaceAll('k', '.000')}',
                additionalInfo: 'Nomor Tujuan: $phoneNumber');

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
