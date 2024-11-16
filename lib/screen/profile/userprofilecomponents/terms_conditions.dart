import 'package:flutter/material.dart';

class TermsConditions extends StatelessWidget {
  const TermsConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Terms & Conditions',
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'TERMS & CONDITIONS OF T-CASH',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '(Updated 11th November, 2024)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'User must read these Terms and Conditions carefully and contact T-Cash if you have any questions.\n\n'
              'These Terms and Conditions constitute your access to and use of T-Cash app, website, content, features, and payment services provided by T-Cash. By accessing or using T-Cash, you agree to be bound by these Terms and Conditions (“Terms and Conditions”) and the Privacy Policy available on a separate page.',
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 30),
            _buildSection([
              _buildSettingItem(
                'I. DEFINITION',
                '1) T-Cash Application is a platform provided by Taruma Financial Services to facilitate various financial transactions and digital payments for users.\n\n'
                    '2) T-Cash means the electronic wallet services that allow users to make payments, transfers, and other digital financial activities through their mobile devices.',
              ),
              _buildSettingItem(
                'II. USER OBLIGATIONS',
                '1) Users must provide accurate and up-to-date information during the registration process and maintain the confidentiality of their account credentials.\n\n'
                    '2) Users agree to use T-Cash only for lawful and legitimate purposes. Any use of T-Cash for fraudulent or illegal activities is strictly prohibited.',
              ),
              _buildSettingItem(
                'III. TRANSACTION FEES AND CHARGES',
                '1) Certain transactions may incur fees, which will be displayed at the time of transaction. Users agree to pay any applicable fees for using T-Cash services.\n\n'
                    '2) T-Cash reserves the right to modify the fees and charges associated with its services from time to time.',
              ),
              _buildSettingItem(
                'IV. PRIVACY AND DATA SECURITY',
                '1) T-Cash values user privacy and is committed to protecting personal data. Users can review the Privacy Policy to understand how their information is collected, used, and protected.\n\n'
                    '2) Users are responsible for maintaining the security of their T-Cash accounts and should not share login information with others.',
              ),
              _buildSettingItem(
                'V. LIMITATION OF LIABILITY',
                '1) T-Cash is not liable for any losses or damages arising from unauthorized access to user accounts due to user negligence.\n\n'
                    '2) T-Cash is not responsible for any issues or delays caused by third-party service providers that may affect transactions.',
              ),
              _buildSettingItem(
                'VI. MODIFICATIONS TO TERMS AND CONDITIONS',
                '1) T-Cash reserves the right to modify these Terms and Conditions at any time. Users will be notified of changes, and continued use of T-Cash indicates acceptance of the updated terms.',
              ),
              _buildSettingItem(
                'VII. CONTACT US',
                'If you have any questions regarding these Terms and Conditions, please contact T-Cash support at tcash@gmail.com.',
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingItem(String title, String value,
      {bool showArrow = false, Widget? leading, bool isBlue = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
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
            value,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
