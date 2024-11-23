import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BankTransferPage extends StatefulWidget {
  @override
  _BankTransferPageState createState() => _BankTransferPageState();
}

class _BankTransferPageState extends State<BankTransferPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  String? savedAccountNumber;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAccountNumber();
  }

  Future<void> _fetchAccountNumber() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          savedAccountNumber = doc.data()?['noRek'] as String?;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching account number: $e');
    }
  }

  Future<void> _saveAccountNumber(String accountNumber) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'noRek': accountNumber,
          'saldo': 0, // Default saldo
          'income': 0, // Default income
        }, SetOptions(merge: true));
        setState(() {
          savedAccountNumber = accountNumber;
        });
      }
    } catch (e) {
      print('Error saving account number: $e');
    }
  }

  Future<void> _updateBalance(int topUpAmount) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final snapshot = await transaction.get(userDoc);

          if (snapshot.exists) {
            final currentBalance = snapshot.data()?['saldo'] ?? 0;
            final currentIncome = snapshot.data()?['income'] ?? 0;

            transaction.update(userDoc, {
              'saldo': currentBalance + topUpAmount,
              'income': currentIncome + topUpAmount,
            });
          } else {
            throw Exception("User document does not exist.");
          }
        });

        // Tambahkan ke riwayat transaksi
        await _addTransactionHistory('income', 'Top-Up Bank', topUpAmount);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Top-up successful! Balance updated.')),
        );
      }
    } catch (e) {
      print('Error updating balance: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update balance.')),
      );
    }
  }

  Future<void> _addTransactionHistory(
      String type, String description, int amount) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        // Tambahkan transaksi ke subkoleksi "transactions"
        await userDoc.collection('transactions').add({
          'type': type,
          'description': description,
          'amount': amount,
          'date': DateTime.now().toIso8601String(),
        });

        print('Transaction added successfully: $type, $description, $amount');
      } else {
        throw Exception('User is not authenticated.');
      }
    } catch (e) {
      print('Error adding transaction history: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Failed to save transaction history. Please try again.'),
        ),
      );
    }
  }

  void _showConfirmationModal() {
    final accountNumber = _accountNumberController.text.trim();
    final amount = int.tryParse(_amountController.text) ?? 0;

    if (savedAccountNumber == null && accountNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an account number.')),
      );
      return;
    }

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount.')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Confirm Top Up',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text('Amount: Rp${_amountController.text}'),
              Text('Account Number: ${savedAccountNumber ?? accountNumber}'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop(); // Tutup modal
                  if (savedAccountNumber == null) {
                    await _saveAccountNumber(accountNumber); // Simpan no rek
                  }
                  await _updateBalance(amount); // Perbarui saldo
                },
                child: const Text('Confirm'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Bank Transfer',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Top-Up Amount',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter amount',
              ),
            ),
            const SizedBox(height: 20),
            if (savedAccountNumber == null) ...[
              const Text(
                'Enter Account Number',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _accountNumberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter account number',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final accountNumber = _accountNumberController.text.trim();
                  if (accountNumber.isNotEmpty) {
                    _saveAccountNumber(accountNumber);
                  }
                },
                child: const Text('Save Account Number'),
              ),
            ] else ...[
              Text(
                'Saved Account Number: $savedAccountNumber',
                style: const TextStyle(fontSize: 16),
              ),
            ],
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (_amountController.text.isNotEmpty) {
                  _showConfirmationModal();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter an amount.')),
                  );
                }
              },
              child: const Text('Confirm'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
