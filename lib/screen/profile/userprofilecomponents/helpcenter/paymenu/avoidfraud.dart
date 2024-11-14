import 'package:flutter/material.dart';

class AvoidFraudPage extends StatelessWidget {
  const AvoidFraudPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Avoid Fraud',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    'Stay Safe from Fraud',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Follow these tips to keep your T-Cash account secure and avoid fraud.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            _buildTipSection('Never Share Your OTP or PIN',
                'T-Cash will never ask for your OTP or PIN. Do not share these codes with anyone.'),
            _buildTipSection('Beware of Phishing Scams',
                'Do not click on suspicious links or provide information on websites you do not trust.'),
            _buildTipSection('Use Strong Passwords',
                'Create a strong password for your account, and avoid using easily guessable information like your birthday.'),
            _buildTipSection('Verify T-Cash Communications',
                'Ensure any communication claiming to be from T-Cash is genuine. T-Cash will never ask for sensitive information over email or SMS.'),
            _buildTipSection('Keep Your App Updated',
                'Always update the T-Cash app to ensure you have the latest security features.'),
            _buildTipSection('Monitor Account Activity',
                'Regularly check your transaction history to spot any unauthorized activity.'),
          ],
        ),
      ),
    );
  }

  Widget _buildTipSection(String title, String description) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            description,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
