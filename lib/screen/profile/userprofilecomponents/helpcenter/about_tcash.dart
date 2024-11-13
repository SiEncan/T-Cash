import 'package:flutter/material.dart';
import 'package:fintar/screen/profile/userprofilecomponents/terms_conditions.dart';
import 'package:fintar/screen/profile/userprofilecomponents/helpcenter/aboutmenu/benefit.dart';
import 'package:fintar/screen/profile/userprofilecomponents/helpcenter/accsecure/about_tcashmenu.dart';
import 'package:fintar/screen/profile/userprofilecomponents/helpcenter/aboutmenu/whatis_tcash.dart';

class AboutTCash extends StatelessWidget {
  const AboutTCash({super.key});

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
            _buildAboutItem('What are benefits of T-Cash', '', () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Benefit()));
            }),
            _buildAboutItem('About T-Cash', '', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AboutTcashMenu()));
            }),
            _buildAboutItem('What is T-Cash', '', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WhatisTcash()));
            }),
            _buildAboutItem('Terms & Conditions', '', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TermsConditions()));
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutItem(String title, String subtitle, VoidCallback onTap) {
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
