import 'package:flutter/material.dart';

class NetworkIssuesPage extends StatelessWidget {
  const NetworkIssuesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Network Issues',
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
                    'Troubleshooting Network Issues',
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
            _buildSection(
              'Check Internet Connection',
              'Ensure that your device is connected to a stable internet network. Try switching between Wi-Fi and mobile data to see if the issue persists.',
            ),
            _buildSection(
              'Restart Your Device',
              'Restarting your device can help refresh the network connection, which may resolve temporary issues with connectivity.',
            ),
            _buildSection(
              'Reset Network Settings',
              'If issues persist, reset your network settings. Go to your device settings to reset Wi-Fi, mobile data, and Bluetooth settings.',
            ),
            _buildSection(
              'Check App Permissions',
              'Ensure that the app has permission to access the internet on your device. Go to your device’s app settings and enable network permissions for the app.',
            ),
            _buildSection(
              'Contact Your Internet Provider',
              'If network issues persist across all apps and devices, consider reaching out to your internet provider to verify if there are any issues on their end.',
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
