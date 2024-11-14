import 'package:flutter/material.dart';
import 'package:fintar/screen/profile/userprofilecomponents/helpcenter/paymenu/safety_tips.dart';
import 'package:fintar/screen/profile/userprofilecomponents/helpcenter/paymenu/twofactor.dart';
import 'package:fintar/screen/profile/userprofilecomponents/helpcenter/paymenu/avoidfraud.dart';
import 'package:fintar/screen/profile/userprofilecomponents/helpcenter/paymenu/payfailed.dart';
import 'package:fintar/screen/profile/userprofilecomponents/helpcenter/paymenu/cardsecurity.dart';

class PaymentSecure extends StatelessWidget {
  const PaymentSecure({super.key});

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
                'Safety Tips for Making Payments', 'Protect your transactions',
                () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SafetyTipsPage()),
              );
            }),
            _buildAboutItem('Two-Factor Authentication (2FA)',
                'Add an extra layer of security', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TwoFAPage()),
              );
            }),
            _buildAboutItem(
                'Avoiding Online Fraud', 'Recognize and avoid scams', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AvoidFraudPage()),
              );
            }),
            _buildAboutItem('What to Do If a Payment Fails',
                'Solutions for failed payments', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaymentFailedPage()),
              );
            }),
            _buildAboutItem('How to Keep Credit Card Information Secure',
                'Tips for protecting card info', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CardSecurityPage()),
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
