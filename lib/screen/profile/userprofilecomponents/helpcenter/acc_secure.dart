import 'package:flutter/material.dart';
import 'package:fintar/screen/profile/userprofilecomponents/helpcenter/accsecure/account_secure.dart';
import 'package:fintar/screen/profile/userprofilecomponents/helpcenter/accsecure/payment_secure.dart';
import 'package:fintar/screen/profile/userprofilecomponents/helpcenter/accsecure/technical_issue.dart';
import 'package:fintar/screen/profile/userprofilecomponents/helpcenter/accsecure/about_tcashmenu.dart';

class AccountSecure extends StatelessWidget {
  const AccountSecure({super.key});

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
            _buildSecurityOption('Account & Security', '', () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AccountSecureMenu())); // Ganti ke halaman lain jika ada
            }),
            _buildSecurityOption('Payments & Transactions', '', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PaymentSecure()));
            }),
            _buildSecurityOption('Technical Issues', '', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TechnicalIssue()));
            }),
            _buildSecurityOption('About T-Cash', '', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AboutTcashMenu()));
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityOption(
      String title, String subtitle, VoidCallback onTap) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
