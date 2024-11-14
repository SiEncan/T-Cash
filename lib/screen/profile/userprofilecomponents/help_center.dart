import 'package:flutter/material.dart';
import 'package:fintar/screen/profile/userprofilecomponents/helpcenter/acc_secure.dart';
import 'package:fintar/screen/profile/userprofilecomponents/helpcenter/pay_secure.dart';
import 'package:fintar/screen/profile/userprofilecomponents/helpcenter/technical_issue.dart';
import 'package:fintar/screen/profile/userprofilecomponents/helpcenter/about_tcash.dart';

class HelpCenter extends StatelessWidget {
  const HelpCenter({super.key});

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
            _buildHelpItem('Account & Security', '', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AccountSecure()));
            }),
            _buildHelpItem('Payments & Transactions', '', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PaymentSecure()));
            }),
            _buildHelpItem('Technical Issues', '', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TechnicalIssue()));
            }),
            _buildHelpItem('About T-Cash', '', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AboutTCash()));
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpItem(String title, String trailing, VoidCallback onTap) {
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
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (trailing.isNotEmpty)
              Text(
                trailing,
                style: TextStyle(color: Colors.grey[600]),
              ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
