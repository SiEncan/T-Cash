import 'package:flutter/material.dart';
import 'package:fintar/screen/profile/userprofilecomponents/helpcenter/technicalmenu/networkissue.dart';
import 'package:fintar/screen/profile/userprofilecomponents/helpcenter/technicalmenu/appcrashissue.dart';
import 'package:fintar/screen/profile/userprofilecomponents/helpcenter/technicalmenu/loginissue.dart';

class TechnicalIssue extends StatelessWidget {
  TechnicalIssue({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Help Center',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            _buildAboutItem(
                'Network Issues', 'Troubleshoot connectivity problems', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NetworkIssuesPage()),
              );
            }),
            _buildAboutItem('App Crashes', 'Resolve app crash issues', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppCrashIssuesPage()),
              );
            }),
            _buildAboutItem('Login Problems', 'Fix issues with logging in', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginIssuesPage()),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutItem(String title, String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
              ],
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
