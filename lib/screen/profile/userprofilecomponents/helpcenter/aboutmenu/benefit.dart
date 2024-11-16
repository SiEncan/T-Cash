import 'package:flutter/material.dart';

class Benefit extends StatelessWidget {
  const Benefit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Benefits of T-Cash',
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
                    'Benefits of T-Cash',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Discover the advantages of using T-Cash for your transactions.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            _buildSection(
              'Quick and Easy Transactions',
              'With T-Cash, you can complete transactions in seconds. No more waiting in line or dealing with physical cash. Pay for your purchases or transfer money instantly from your mobile device.',
            ),
            _buildSection(
              'Enhanced Security',
              'T-Cash ensures your transactions are secure with advanced encryption technology. Enjoy peace of mind knowing your financial information is protected every step of the way.',
            ),
            _buildSection(
              'Exclusive Discounts and Offers',
              'As a T-Cash user, you get access to exclusive discounts and cashback offers on selected merchants and services, helping you save money on your everyday transactions.',
            ),
            _buildSection(
              'Easy Expense Tracking',
              'Keep track of your spending easily with T-Cash. The app provides a detailed history of all transactions, so you can manage your finances and budget more effectively.',
            ),
            _buildSection(
              'Seamless Integration',
              'Link your T-Cash account to other financial services or apps for a seamless experience. Manage all your payments and transfers from one place without any hassle.',
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
