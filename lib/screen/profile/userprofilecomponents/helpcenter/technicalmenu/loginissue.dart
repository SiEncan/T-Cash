import 'package:flutter/material.dart';

class LoginIssuesPage extends StatelessWidget {
  const LoginIssuesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Login Issues',
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
                    'Troubleshooting Login Issues',
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
              '1. Forgot Password?',
              'If you cannot remember your password, use the "Forgot Password" option on the login screen. Enter your registered email address, and you will receive instructions on how to reset your password.',
            ),
            _buildSection(
              '2. Check Your Internet Connection',
              'A poor or unstable internet connection can prevent you from logging in. Ensure that you have a stable connection before attempting to log in again.',
            ),
            _buildSection(
              '3. Verify Your Credentials',
              'Make sure that the email address and password you are entering are correct. Double-check for any typos, and ensure that Caps Lock is not enabled.',
            ),
            _buildSection(
              '4. Clear Cache and App Data',
              'Sometimes app issues are caused by corrupted cache or stored data. Try clearing the app cache or reinstalling the app to see if it resolves the login problem.',
            ),
            _buildSection(
              '5. Account Locked or Suspended?',
              'If you have made multiple unsuccessful login attempts, your account may have been temporarily locked for security reasons. Contact customer support for assistance.',
            ),
            _buildSection(
              '6. Two-Factor Authentication Problems',
              'If you have enabled two-factor authentication and are having trouble receiving the code, check your phone number, email address, or authentication app settings. Make sure your device has proper network connectivity.',
            ),
            _buildSection(
              ' 7. Server Outage',
              'Occasionally, the service might experience server issues. Check the status page of the service to confirm if there is a known issue, or try again later.',
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
