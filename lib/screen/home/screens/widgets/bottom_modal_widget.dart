import 'package:fintar/screen/auth/passcode_create.dart';
import 'package:flutter/material.dart';
import 'package:fintar/services/passcode_checker.dart';
import 'package:fintar/widgets/custom_dialog.dart';
import 'package:fintar/services/auth_services.dart';
import 'package:fintar/services/saldo_services.dart';
import 'package:fintar/services/transaction_services.dart';
import 'package:fintar/screen/auth/passcode_input.dart';

class PulsaModal extends StatefulWidget {
  final int index;
  final double screenHeight;
  final String selectedProviderParam;
  final String phoneNumber;
  final String receiverName;
  final List<String> hargaPulsa;
  final List<String> jumlahPulsa;

  const PulsaModal({
    super.key,
    required this.index,
    required this.screenHeight,
    required this.selectedProviderParam,
    required this.phoneNumber,
    required this.receiverName,
    required this.hargaPulsa,
    required this.jumlahPulsa,
  });

  @override
  _PulsaModalState createState() => _PulsaModalState();
}

class _PulsaModalState extends State<PulsaModal> {
  final passcodeChecker = PasscodeChecker();
  final authService = AuthService();
  final SaldoService _saldoService = SaldoService();
  final TransactionService _transactionService = TransactionService();

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    bool enableDrag = true;

    scrollController.addListener(() {
      if (scrollController.offset <= 0) {
        print('ha');
        setState(() {
          enableDrag = true;
        });
      } else {
        setState(() {
          enableDrag = false;
        });
      }
    });

    // This logic should now be inside a callback, not in the build method.
    Future<void> _showBottomSheet() async {
      await showModalBottomSheet(
        context: context,
        enableDrag: enableDrag,
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
                              Text('Receiver Name',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600])),
                              const SizedBox(height: 4),
                              Text(widget.receiverName,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                              const SizedBox(height: 16),
                              Text('Phone Number',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600])),
                              const SizedBox(height: 4),
                              Text(widget.phoneNumber,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                              const SizedBox(height: 16),
                              const Divider(height: 30, color: Colors.grey),
                              Text('Purchase Detail',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600])),
                              Image.asset(
                                'img/${widget.selectedProviderParam}.png',
                                width: 120,
                                height: 60,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Pulsa: ${widget.jumlahPulsa[widget.index].replaceAll('k', '.000')}',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 10),
                              const Divider(height: 30, color: Colors.grey),
                              Text('Payment Detail',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600])),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text('Price:',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w500)),
                                  Text('  Rp${widget.hargaPulsa[widget.index]}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500)),
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
                          borderRadius: BorderRadius.circular(10)),
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
                            const Icon(Icons.check_circle_outline,
                                color: Colors.green, size: 16),
                            const SizedBox(width: 4),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            'All your transactions are secure and fast. By continuing, you agree to the ',
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12)),
                                    const TextSpan(
                                        text: 'Terms and Conditions',
                                        style: TextStyle(
                                            color: Colors.green, fontSize: 12)),
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
                            confirmButton(widget.index, context),
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

    return GestureDetector(
      onTap: _showBottomSheet, // Trigger the modal bottom sheet on tap
      child: Container(
        color: Colors.transparent,
        child: Icon(Icons.add), // Example: You can change this widget
      ),
    );
  }

  Expanded confirmButton(int index, BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () async {
          bool isPasscodeExist = await passcodeChecker.checkIfPasscodeExists();
          if (!isPasscodeExist) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CreatePasscode()));
            return;
          }

          String userId = authService.getUserId();
          int hargaFormatted =
              int.parse(widget.hargaPulsa[index].replaceAll('.', ''));

          if (widget.phoneNumber.trim() == '') {
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
              await _saldoService.reduceSaldo(userId, hargaFormatted);

          if (isSaldoSufficient) {
            await _transactionService.saveTransaction(
                userId,
                hargaFormatted,
                'Payment',
                'Pulsa ${widget.selectedProviderParam} ${widget.jumlahPulsa[index].replaceAll('k', '.000')}');
            Navigator.pop(context);
            showCustomDialog(
                context: context,
                imagePath: 'img/success.png',
                message: 'Payment confirmed! Your purchase is being processed.',
                height: 100,
                buttonColor: Colors.green);
          } else {
            Navigator.pop(context);
            showCustomDialog(
                context: context,
                imagePath: 'img/failed.png',
                message: 'Insufficient balance. Please top-up your account.',
                height: 100,
                buttonColor: Colors.red);
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, padding: const EdgeInsets.all(12)),
        child: const Text(
          'Pay Now',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Expanded cancelButton(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            padding: const EdgeInsets.all(12)),
        child: const Text(
          'Cancel',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
