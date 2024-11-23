import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Tambahkan package untuk formatting angka

class DonationHub extends StatefulWidget {
  const DonationHub({super.key});

  @override
  State<DonationHub> createState() => _DonationHubState();
}

class _DonationHubState extends State<DonationHub> {
  int _balance = 0; // Saldo default sebelum diambil dari Firebase
  final TextEditingController _donationController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBalance();
  }

  // Ambil saldo dari Firebase
  Future<void> _fetchBalance() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        _showMessage('User not logged in.');
        return;
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          _balance = (userDoc['saldo'] ?? 0) as int; // Pastikan tipe int
          _isLoading = false;
        });
      } else {
        _showMessage('User document does not exist.');
      }
    } catch (e) {
      _showMessage('Failed to fetch balance: $e');
    }
  }

  // Perbarui saldo dan tambahkan ke expense
  Future<void> _updateBalance(int donationAmount) async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        _showMessage('User not logged in.');
        return;
      }

      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(userDoc);

        if (!snapshot.exists) {
          throw Exception('User document does not exist.');
        }

        final data = snapshot.data() as Map<String, dynamic>;
        int currentBalance = (data['saldo'] ?? 0) as int;
        int currentExpense =
            data['expense'] != null ? (data['expense'] as int) : 0;

        if (currentBalance >= donationAmount) {
          int newBalance = currentBalance - donationAmount;
          int newExpense = currentExpense + donationAmount;

          // Update saldo dan expense
          transaction.update(userDoc, {
            'saldo': newBalance,
            'expense': newExpense,
          });

          setState(() {
            _balance = newBalance;
          });
        } else {
          throw Exception('Insufficient balance.');
        }
      });

      // Tambahkan ke riwayat transaksi
      await _addTransactionHistory('expense', 'Donation', donationAmount);

      _showMessage('Thank you for your donation!');
    } catch (e) {
      _showMessage('Failed to update balance: $e');
    }
  }

  Future<void> _addTransactionHistory(
      String type, String description, int amount) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        await userDoc.collection('transactions').add({
          'type': type, // "expense" untuk donasi
          'description': description, // "Donation"
          'amount': amount,
          'date': DateTime.now().toIso8601String(), // Simpan timestamp
        });
      }
    } catch (e) {
      print('Error adding transaction history: $e');
    }
  }

  // Konfirmasi donasi
  void _confirmDonation() {
    int? donationAmount = int.tryParse(_donationController.text);

    if (donationAmount == null || donationAmount <= 0) {
      _showMessage('Please enter a valid amount.');
    } else if (donationAmount > _balance) {
      _showMessage('Insufficient balance!');
    } else {
      _updateBalance(donationAmount);
      _donationController.clear();
    }
  }

  // Menampilkan pesan
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Donation Hub',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Balance: ${numberFormat.format(_balance)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _donationController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Enter donation amount',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _confirmDonation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Confirm Donation'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
