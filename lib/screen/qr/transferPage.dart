import 'package:fintar/screen/auth/passcode_create.dart';
import 'package:fintar/screen/auth/passcode_input.dart';
import 'package:fintar/screen/profile/userprofilecomponents/terms_conditions.dart';
import 'package:fintar/services/auth_services.dart';
import 'package:fintar/services/passcode_checker.dart';
import 'package:fintar/services/saldo_services.dart';
import 'package:fintar/services/transaction_services.dart';
import 'package:fintar/widgets/bottom_navigation.dart';
import 'package:fintar/widgets/custom_dialog.dart';
import 'package:fintar/widgets/custom_page_transition.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class TransferPage extends StatefulWidget {
  final String uid;

  const TransferPage({super.key, required this.uid});

  @override
  _TransferPageState createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final authService = AuthService();
  final passcodeChecker = PasscodeChecker();
  final SaldoService saldoService = SaldoService();
  final TransactionService transactionService = TransactionService();

  String targetName = '';
  String targetPhone = '';
  String targetPhoto = '';
  int senderSaldo = 0;
  String senderName = '';
  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  bool _isAmountValid = false;

  @override
  void initState() {
    super.initState();
    _getTargetInfo();
    _getSenderInfo();
    amountController.addListener(_validateAmount);
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void _validateAmount() {
    setState(() {
      final amount = amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
      _isAmountValid = amount.isNotEmpty && int.parse(amount) > 0;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            color: Colors.blue,
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'Send to Friend',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.grey[200],
                            child: targetPhoto.isNotEmpty
                                ? ClipOval(
                                    child: Image.network(
                                      targetPhoto,
                                      width: 56,
                                      height: 56,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return const Center(
                                          child: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.blue),
                                            ),
                                          ),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.person,
                                            color: Colors.grey);
                                      },
                                    ),
                                  )
                                : const Icon(Icons.person, color: Colors.grey),
                          ),
                          title: Text(
                            targetName,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            targetPhone,
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          'SEND AMOUNT',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Rp0',
                            hintStyle: TextStyle(color: Colors.grey[600]),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (value) {
                            final newValue = _formatAmount(value);
                            if (newValue != value) {
                              amountController.value = TextEditingValue(
                                text: newValue,
                                selection: TextSelection.collapsed(
                                    offset: newValue.length),
                              );
                            }
                          },
                        ),

                        const SizedBox(height: 16),

                        TextField(
                          controller: noteController,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                              hintText: 'Write a note "Hi beb ❤️"',
                              hintStyle: TextStyle(color: Colors.grey[600]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    width: 1.5, color: Colors.grey[600]!),
                              )),
                        ),

                        const SizedBox(height: 16),

                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.account_balance_wallet,
                                  color: Colors.blue),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('T-Cash Saldo'),
                                  Text(
                                    _formatAmount(senderSaldo.toString()),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

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
                                          color: Colors.grey[600],
                                          fontSize: 12),
                                    ),
                                    TextSpan(
                                      text: 'Terms and Conditions',
                                      style: const TextStyle(
                                          color: Colors.green, fontSize: 12),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.of(context).push(
                                              createRoute(
                                                  const TermsConditions(),
                                                  0,
                                                  1));
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Pay Button
                        ElevatedButton(
                          onPressed: _isAmountValid
                              ? () {
                                  _sendTransfer();
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            disabledBackgroundColor: Colors.grey[300],
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'SEND ${amountController.text.isEmpty ? "Rp0" : amountController.text}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _isAmountValid
                                  ? Colors.white
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getTargetInfo() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          targetName = data['fullName'] ?? '';
          targetPhone = data['phone'] ?? '';
          targetPhoto = data['profileImageUrl'] ?? '';
        });
      } else {
        debugPrint('User not found in Firestore');
      }
    } catch (e) {
      debugPrint('Error fetching user info: $e');
    }
  }

  Future<void> _getSenderInfo() async {
    String userId = authService.getUserId();

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          senderSaldo = userDoc['saldo'];
          senderName = userDoc['fullName'];
        });
      } else {
        debugPrint('User not found in Firestore');
      }
    } catch (e) {
      debugPrint('Error fetching user info: $e');
    }
  }

  void _sendTransfer() async {
    if (amountController.text.trim() == '') {
      return showCustomDialog(
        context: context,
        imagePath: 'img/failed.png',
        message: 'Please fill out Amount to Transfer.',
        height: 100,
        buttonColor: Colors.red,
      );
    }
    final amountReplaced =
        amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    int amount = int.tryParse(amountReplaced) ?? 0;
    String userId = authService.getUserId();

    bool isPasscodeExist = await passcodeChecker.checkIfPasscodeExists();
    if (!isPasscodeExist) {
      Navigator.of(context).push(createRoute(CreatePasscode(), 0, 1));
      return;
    }

    bool isPasscodeTrue = await PasscodeModal.showPasscodeModal(context);
    if (!isPasscodeTrue) {
      return;
    }

    await saldoService.addSaldo(widget.uid, amount);
    bool isSaldoSufficient = await saldoService.reduceSaldo(userId, amount);
    if (isSaldoSufficient) {
      await transactionService.saveTransaction(
        userId,
        'Transfer out',
        amount: amount,
        note: noteController.text.trim(),
        partyName: targetName,
      );

      await transactionService.saveTransaction(
        widget.uid,
        'Transfer in',
        amount: amount,
        note: noteController.text.trim().isNotEmpty
            ? noteController.text.trim()
            : '-',
        partyName: senderName,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BottomNavigation(),
        ),
      );

      showCustomDialog(
        context: context,
        imagePath: 'img/success.png',
        message: 'Saldo has been Transferred!',
        height: 100,
        buttonColor: Colors.green,
      );
    } else {
      showCustomDialog(
        context: context,
        imagePath: 'img/failed.png',
        message: 'Insufficient balance. Please top-up your account.',
        height: 100,
        buttonColor: Colors.red,
      );
    }
  }
}
