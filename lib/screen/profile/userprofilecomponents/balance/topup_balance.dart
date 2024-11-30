import 'dart:math';
import 'package:fintar/services/saldo_services.dart';
import 'package:fintar/services/transaction_services.dart';
import 'package:fintar/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';

class TopUpBalance extends StatefulWidget {
  final String userId;

  const TopUpBalance({super.key, required this.userId});

  @override
  TopUpBalanceState createState() => TopUpBalanceState();
}

class TopUpBalanceState extends State<TopUpBalance> {
  final SaldoService saldoService = SaldoService();
  final TransactionService transactionService = TransactionService();

  final List<int> _amountOptions = [50000, 100000, 150000, 200000];
  int? _selectedAmount;
  String? _virtualAccountNumber;
  final TextEditingController _amountController = TextEditingController();

  String generateVirtualAccountNumber() {
    final random = Random();
    return '3901 ${random.nextInt(9999).toString().padLeft(4, '0')} '
        '${random.nextInt(9999).toString().padLeft(4, '0')} '
        '${random.nextInt(9999).toString().padLeft(4, '0')}';
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Virtual Account Top-Up',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_selectedAmount == null) ...[
                const Text(
                  'Select or Enter Top-Up Amount',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _amountOptions.map((amount) {
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedAmount = amount;
                          _virtualAccountNumber =
                              generateVirtualAccountNumber();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Rp${amount.toString()}'),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Or Enter Custom Amount:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter amount',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onSubmitted: (value) {
                    final amount = int.tryParse(value);
                    if (amount != null && amount > 0) {
                      setState(() {
                        _selectedAmount = amount;
                        _virtualAccountNumber = generateVirtualAccountNumber();
                      });
                    }
                  },
                ),
              ],
              if (_selectedAmount != null) ...[
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 0.7,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'BCA Virtual Account Number',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _virtualAccountNumber!,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Please transfer Rp$_selectedAmount to the Virtual Account above.',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await saldoService.addSaldo(
                          widget.userId, _selectedAmount!);
                      await transactionService.saveTransaction(
                        widget.userId,
                        'Top-Up',
                        amount: _selectedAmount,
                        description: 'BCA Virtual Account',
                      );
                      Navigator.pop(context);

                      showCustomDialog(
                        context: context,
                        imagePath: 'img/success.png',
                        message:
                            'Top-up completed! Your balance has been updated.',
                        height: 100,
                        buttonColor: Colors.green,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      'Done Transfer',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
