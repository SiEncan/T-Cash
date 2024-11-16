import 'package:flutter/material.dart';

class WhatisTcash extends StatelessWidget {
  const WhatisTcash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'What is T-Cash',
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
                    'What is T-Cash?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Learn about T-Cash and how it can benefit you in managing transactions.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            _buildSection(
              'Introduction to T-Cash',
              'T-Cash is a digital wallet solution that enables users to make secure, fast, and convenient payments directly from their mobile devices. Whether you’re paying at a store, transferring money to friends, or managing expenses, T-Cash simplifies your financial transactions.',
            ),
            _buildSection(
              'How T-Cash Works',
              'T-Cash works by linking your bank account or card to the app, allowing you to make payments directly without physical cash. You can transfer money, pay bills, or make purchases with just a few taps on your smartphone.',
            ),
            _buildSection(
              'Key Features',
              'T-Cash offers features such as instant transactions, security with advanced encryption, transaction alerts, and easy integration with other services. It is designed to make financial management easier and more secure for users.',
            ),
            _buildSection(
              'Who Can Use T-Cash?',
              'Anyone with a compatible mobile device can use T-Cash by downloading the app, registering, and linking a payment method. It is suitable for individuals who want a fast and secure way to handle their daily transactions.',
            ),
            _buildSection(
              'Why Choose T-Cash?',
              'T-Cash offers convenience, security, and exclusive benefits, such as discounts and cashback at selected merchants. It is the perfect choice for those looking to streamline their financial transactions and manage their spending effectively.',
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
