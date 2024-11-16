import 'package:flutter/material.dart';

class AboutTcashMenu extends StatelessWidget {
  const AboutTcashMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'About T-Cash',
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
                    'About T-Cash',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Learn more about T-Cash, its benefits, and how it works.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            _buildSection(
              'What is T-Cash?',
              'T-Cash is a secure, digital wallet solution that allows users to make quick and easy transactions. With T-Cash, you can pay for goods and services, transfer money to friends and family, and even manage your finances, all from one convenient platform.',
            ),
            _buildSection(
              'Benefits of Using T-Cash',
              'T-Cash offers a variety of benefits, including fast transactions, high security, easy account management, and a user-friendly interface. By using T-Cash, you can also enjoy exclusive discounts, cashback offers, and a seamless payment experience.',
            ),
            _buildSection(
              'How T-Cash Works',
              'To start using T-Cash, download the app, create an account, and link your bank or card. Once set up, you can load funds into your T-Cash account and start making secure payments and transfers immediately.',
            ),
            _buildSection(
              'Security Features',
              'T-Cash prioritizes the security of your transactions with multiple layers of protection, including biometric login, two-factor authentication, and encryption for data transfer. This ensures that all your financial data remains private and secure.',
            ),
            _buildSection(
              'Customer Support',
              'T-Cash provides dedicated customer support to assist you with any issues. You can reach out to our support team through the app, by phone, or email for any inquiries or technical assistance.',
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String description) {
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            description,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
