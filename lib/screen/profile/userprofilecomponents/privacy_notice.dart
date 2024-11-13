import 'package:flutter/material.dart';

class PrivacyNotice extends StatelessWidget {
  const PrivacyNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Privacy Notice',
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
              'PRIVACY NOTICE OF T-CASH USER',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '(Updated 11th November, 2024)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'This Privacy Notice explains how T-Cash collects, uses, shares, and protects information about you. Please read this Privacy Notice carefully to understand our practices regarding your data.',
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 30),
            _buildSection([
              _buildSettingItem(
                '1. Collection of Information',
                'We collect information that you provide directly to us, such as when you register, make a transaction, or contact customer support. This may include personal details like name, email, phone number, and financial information like bank details or payment history.',
              ),
              _buildSettingItem(
                '2. Information We Collect Automatically',
                'When you use T-Cash, we automatically collect certain information about your device and activity. This includes IP address, device type, operating system, location information, and usage data. We use this information to improve the performance and security of T-Cash.',
              ),
              _buildSettingItem(
                '3. Use of Information',
                'T-Cash uses the information we collect to provide and improve our services, personalize your experience, process transactions, and communicate with you. Additionally, we may use your data for security purposes, fraud prevention, and compliance with legal obligations.',
              ),
              _buildSettingItem(
                '4. Sharing of Information',
                'We may share your information with third parties who perform services on our behalf, such as payment processors, identity verification services, and data analytics providers. We require these third parties to protect your data in compliance with our privacy policies and applicable laws.',
              ),
              _buildSettingItem(
                '5. Data Security',
                'We implement a variety of security measures to safeguard your information. However, please be aware that no data transmission over the Internet is completely secure. We cannot guarantee the security of any information you transmit to us and you do so at your own risk.',
              ),
              _buildSettingItem(
                '6. Data Retention',
                'T-Cash will retain your information for as long as necessary to fulfill the purposes outlined in this Privacy Notice, or as required by law. Once your information is no longer needed, we will securely delete or anonymize it.',
              ),
              _buildSettingItem(
                '7. Your Rights',
                'Depending on your jurisdiction, you may have rights regarding your personal data, such as the right to access, correct, delete, or restrict processing of your data. You may also have the right to object to processing and to data portability.',
              ),
              _buildSettingItem(
                '8. Children\'s Privacy',
                'T-Cash does not knowingly collect or solicit personal information from children under the age of 13. If we become aware that we have collected personal information from a child under 13, we will take steps to delete that information promptly.',
              ),
              _buildSettingItem(
                '9. Changes to This Privacy Notice',
                'We may update this Privacy Notice from time to time. If we make significant changes, we will notify you by posting a prominent notice in the app or contacting you directly. Your continued use of T-Cash after any changes indicates your acceptance of the updated terms.',
              ),
              _buildSettingItem(
                '10. Contact Us',
                'If you have questions about this Privacy Notice or wish to exercise your rights, please contact us at support@tcash.com.',
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
