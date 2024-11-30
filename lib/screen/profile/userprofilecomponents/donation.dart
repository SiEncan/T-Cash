import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintar/services/auth_services.dart';
import 'package:fintar/services/saldo_services.dart';
import 'package:fintar/services/transaction_services.dart';
import 'package:fintar/widgets/custom_dialog.dart';
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
  String _userId = '';
  final SaldoService saldoService = SaldoService();
  final authService = AuthService();
  final TransactionService transactionService = TransactionService();

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  @override
  void dispose() {
    _donationController.clear();
    super.dispose();
  }

  Future<void> _fetchUserInfo() async {
    String userId = authService.getUserId();
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    setState(() {
      _balance = (userDoc['saldo']);
      _userId = userId;
      _isLoading = false;
    });
  }

  // Konfirmasi donasi
  Future<void> _confirmDonation() async {
    int? donationAmount = int.tryParse(_donationController.text);

    if (donationAmount == null || donationAmount <= 0) {
      return showCustomDialog(
        context: context,
        imagePath: 'img/failed.png',
        message: 'Please enter a valid amount.',
        height: 100,
        buttonColor: Colors.red,
      );
    }

    bool isSaldoSufficient =
        await saldoService.reduceSaldo(_userId, donationAmount);

    if (isSaldoSufficient) {
      await transactionService.saveTransaction(_userId, 'Transfer out',
          amount: donationAmount, note: '-', partyName: 'Donation Hub');

      Navigator.pop(context);

      showCustomDialog(
        context: context,
        imagePath: 'img/success.png',
        message:
            'Thank you for your donation, your support means a lot and helps us make a meaningful impact!',
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
  }

  // Menampilkan pesan
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
          ? const Center(
              child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ))
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
