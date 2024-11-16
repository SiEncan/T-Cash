import 'package:flutter/material.dart';

class AppCrashIssuesPage extends StatelessWidget {
  const AppCrashIssuesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'App Crash Issues',
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
                    'Troubleshooting App Crashes',
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
              'Update the App',
              'Ensure that you are using the latest version of the app. Older versions might have bugs that could cause crashes. Check for updates in the app store and install the latest version.',
            ),
            _buildSection(
              'Clear App Cache',
              'Temporary files and data might cause the app to crash. Go to your device settings, find the app, and clear the cache to free up space and improve performance.',
            ),
            _buildSection(
              'Free Up Device Storage',
              'Low device storage can affect app performance and cause crashes. Check your device storage and clear unnecessary files to create more space.',
            ),
            _buildSection(
              'Restart Your Device',
              'Sometimes a simple device restart can resolve app crashes. Restart your phone or tablet, then try opening the app again.',
            ),
            _buildSection(
              'Check for OS Compatibility',
              'Ensure that your device operating system is compatible with the app. If your OS is outdated, consider updating it to improve app compatibility.',
            ),
            _buildSection(
              'Reinstall the App',
              'If issues persist, uninstall the app and reinstall it. This can remove corrupted data and files that might be causing crashes.',
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
