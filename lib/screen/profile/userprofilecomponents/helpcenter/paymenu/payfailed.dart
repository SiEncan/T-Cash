import 'package:flutter/material.dart';

class PaymentFailedPage extends StatelessWidget {
  const PaymentFailedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Payment Failed',
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
                    'Payment Failed Guided',
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
            _buildTipSection('Check Your Payment Details',
                'Double-check that all payment information, including card number, expiration date, and CVV, is entered correctly.'),
            _buildTipSection('Verify Sufficient Balance',
                'Ensure that your account has enough funds for the transaction. Insufficient balance is a common reason for payment failures.'),
            _buildTipSection('Use a Supported Payment Method',
                'Make sure the payment method you\'re using is supported by T-Cash. Some cards or accounts may not be compatible.'),
            _buildTipSection('Check for Network Issues',
                'Payment processing might fail due to poor internet connection. Confirm that your device is connected to a stable network and try again.'),
            _buildTipSection('Contact Your Bank',
                'Sometimes banks may block transactions for security reasons. If you suspect this, reach out to your bank or card issuer to confirm.'),
            _buildTipSection('Retry After a Few Minutes',
                'Sometimes, payment gateways experience temporary downtime. Wait a few minutes and try the payment again.'),
            _buildTipSection('Contact Support',
                'If the issue persists, consider reaching out to T-Cash support for further assistance.'),
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
