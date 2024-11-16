import 'package:flutter/material.dart';

class SafetyTipsPage extends StatelessWidget {
  const SafetyTipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Safety Tips',
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
                    'Safety Tips For Using T-Cash',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            _buildTipSection(
              'Keep Your PIN and Password Confidential',
              'Never share your PIN or password with anyone. Make sure your PIN and password are difficult to guess, avoiding easily accessible personal information like your birthdate.',
            ),
            _buildTipSection('Enable Two-Factor Authentication (2FA)',
                'If T-Cash offers two-factor authentication, make sure to enable it to add an extra layer of security to your account.'),
            _buildTipSection('Use Trusted Devices Only',
                'Only access T-Cash on devices you trust. Avoid using public or shared devices to log into your T-Cash account.'),
            _buildTipSection('Keep Your App Updated',
                'Always update the T-Cash app to the latest version to ensure you have the latest security features and improvements.'),
            _buildTipSection('Be Aware of Phishing Links and Emails',
                'Do not click on suspicious links asking for personal information. T-Cash will not request personal information like your PIN or OTP via email or SMS.'),
            _buildTipSection('Review Transactions Regularly',
                'Regularly check your transactions to ensure there are no unauthorized activities.'),
            SizedBox(height: 30),
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
