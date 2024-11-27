import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintar/widgets/transaction_details_modal.dart';
import 'package:fintar/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransferToServiceScreen extends StatefulWidget {
  final String service;
  final String serviceImage;

  const TransferToServiceScreen(
      {super.key, required this.service, required this.serviceImage});

  @override
  State<TransferToServiceScreen> createState() =>
      _VirtualAccountInputPageState();
}

class _VirtualAccountInputPageState extends State<TransferToServiceScreen> {
  final authService = AuthService();
  String customerName = '';
  String _userId = '';

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  bool _isContinueEnabled = false;

  final FocusNode focusNode = FocusNode();

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
  void initState() {
    super.initState();
    _getSenderInfo();
    amountController.addListener(_validateInput);
    phoneNumberController.addListener(_validateInput);
  }

  @override
  void dispose() {
    amountController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  void _validateInput() {
    setState(() {
      final amount = amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
      final phoneNumber = phoneNumberController.text;
      _isContinueEnabled =
          amount.isNotEmpty && int.parse(amount) > 0 && phoneNumber.isNotEmpty;
    });
  }

  void _setAmount(int amount) {
    setState(() {
      amountController.text = _formatAmount(amount);
    });
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
          customerName = userDoc['fullName'];
          _userId = userId;
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Send to ${widget.service}",
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "SERVICE NAME",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          widget.serviceImage,
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.service,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side:
                                const BorderSide(color: Colors.blue, width: 1),
                          ),
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                        ),
                        child: const Text(
                          "CHANGE",
                          style: TextStyle(color: Colors.blue, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'PHONE NUMBER',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    focusNode: focusNode,
                    controller: phoneNumberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintText: 'Type your phone number here ',
                      hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 12,
                      ),
                    ),
                    buildCounter: (_,
                        {required currentLength,
                        maxLength,
                        required isFocused}) {
                      return null; // Hide character counter
                    },
                    onEditingComplete: () {
                      focusNode.unfocus();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "TOP UP AMOUNT",
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
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
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
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
                    GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 4,
                      ),
                      itemCount: 4,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        List<int> amounts = [25000, 50000, 100000, 200000];
                        return ElevatedButton(
                          onPressed: () => _setAmount(amounts[index]),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: BorderSide(
                                  color: Colors.blue.withOpacity(0.5),
                                  width: 1),
                            ),
                          ),
                          child: Text(
                            _formatAmount(amounts[index]),
                            style: TextStyle(
                                color: Colors.blue[500],
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _isContinueEnabled
                          ? () {
                              final amountReplaced = amountController.text
                                  .replaceAll(RegExp(r'[^0-9]'), '');
                              int amount = int.tryParse(amountReplaced) ?? 0;
                              TransactionDetailsModal(
                                      userId: _userId,
                                      customerName: customerName,
                                      serviceName:
                                          'Top-Up Saldo ${widget.service}',
                                      serviceImage: widget.serviceImage,
                                      recipientInfo:
                                          phoneNumberController.text.trim(),
                                      amount: amount)
                                  .showCustomModal(context);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isContinueEnabled ? Colors.blue : Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'CONTINUE',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
