import 'package:cloud_firestore/cloud_firestore.dart';
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

class BottomSheetContent extends StatefulWidget {
  final String itemName;
  final int price;
  final IconData icon;

  const BottomSheetContent({
    super.key,
    required this.itemName,
    required this.price,
    required this.icon,
  });

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  final TextEditingController _emailController = TextEditingController();
  final authService = AuthService();
  final passcodeChecker = PasscodeChecker();
  final SaldoService saldoService = SaldoService();
  final TransactionService transactionService = TransactionService();
  String customerName = '';

  @override
  void initState() {
    super.initState();
    _getCustomerInfo();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _getCustomerInfo() async {
    String userId = authService.getUserId();

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          customerName = userDoc['fullName'];
        });
      } else {
        debugPrint('User not found in Firestore');
      }
    } catch (e) {
      debugPrint('Error fetching user info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.itemName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _formatAmount(widget.price),
            style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'Enter your ICloud E-Mail',
              prefixIcon: const Icon(
                Icons.email,
                color: Colors.black,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  width: 2,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                String email = _emailController.text.trim();
                if (email.isNotEmpty && email.contains('@')) {
                  Navigator.pop(context);
                  showModal(context, _emailController.text, widget.itemName,
                      widget.price);
                } else {
                  showCustomDialog(
                    context: context,
                    imagePath: 'img/failed.png',
                    message: 'Please enter a valid email.',
                    height: 100,
                    buttonColor: Colors.red,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Proceed to Transaction',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(dynamic amount) {
    String text = amount is int ? amount.toString() : amount.toString();

    if (text.isEmpty) return '';
    final number = int.parse(text.replaceAll(RegExp(r'[^0-9]'), ''));

    return 'Rp${number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  Future<dynamic> showModal(
      BuildContext context, String email, String itemName, int price) {
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
                              'ICloud E-Mail:',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              email,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 57, 57, 57),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Divider(height: 30, color: Colors.grey),
                            // Purchase Detail
                            Text(
                              'Purchase Detail',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            Icon(widget.icon, color: Colors.black, size: 50),
                            const SizedBox(height: 10),
                            Text(
                              itemName,
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
                                  'Price: ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  _formatAmount(price),
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
                          confirmButton(context, itemName, email, price),
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
      BuildContext context, String itemName, String email, int price) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () async {
          bool isPasscodeExist = await passcodeChecker.checkIfPasscodeExists();
          if (!isPasscodeExist) {
            Navigator.of(context).push(createRoute(CreatePasscode(), 0, 1));
            return;
          }
          String userId = authService.getUserId();

          bool isPasscodeTrue = await PasscodeModal.showPasscodeModal(context);
          if (!isPasscodeTrue) {
            return;
          }

          bool isSaldoSufficient =
              await saldoService.reduceSaldo(userId, price);

          if (isSaldoSufficient) {
            await transactionService.saveTransaction(userId, 'Payment',
                amount: price,
                description: itemName,
                additionalInfo: 'ICloud E-Mail: $email');

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
