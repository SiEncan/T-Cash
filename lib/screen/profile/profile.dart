// profile.dart
import 'package:flutter/material.dart';
import 'package:fintar/screen/profile/userprofilecomponents/user_profile.dart';
import 'package:fintar/screen/profile/userprofilecomponents/balance.dart';
import 'package:fintar/screen/profile/userprofilecomponents/family_acc.dart';
import 'package:fintar/screen/profile/userprofilecomponents/tcash_cicil.dart';
import 'package:fintar/screen/profile/userprofilecomponents/income_page.dart';
import 'package:fintar/screen/profile/userprofilecomponents/expense_page.dart';
import 'package:fintar/screen/profile/userprofilecomponents/mybills_page.dart';
import 'package:fintar/screen/profile/userprofilecomponents/promocode.dart';
import 'package:fintar/screen/profile/userprofilecomponents/help_center.dart';
import 'package:fintar/screen/profile/userprofilecomponents/terms_conditions.dart';
import 'package:fintar/screen/profile/userprofilecomponents/privacy_notice.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Menjadikan AppBar penuh hingga atas
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 120),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Feature Grid
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildFeatureItem(
                          Icons.account_balance,
                          'Balance',
                          'Rp1.000.000',
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BalancePage()),
                            );
                          },
                        ),
                        const SizedBox(width: 30),
                        _buildFeatureItem(
                          Icons.family_restroom,
                          'Family Acc',
                          'Let\'s Activate!',
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FamilyAccPage()),
                            );
                          },
                        ),
                        const SizedBox(width: 30),
                        _buildFeatureItem(
                          Icons.repeat,
                          'T-Cash Cicil',
                          'Start Now',
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TcashCicilPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Income/Expense Row
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTransactionItem(
                          Icons.arrow_downward,
                          'Income',
                          'Rp60.000',
                          Colors.green,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => IncomePage()),
                            );
                          },
                        ),
                        const SizedBox(width: 40),
                        _buildTransactionItem(
                          Icons.arrow_upward,
                          'Expense',
                          'Rp45.000',
                          Colors.orange,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ExpensePage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  // Additional Menu Items - Box 1
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildMenuItem('My Bills', '1 Bill', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyBillsPage()),
                          );
                        }),
                        _buildMenuItem('Enter Promo Code', '', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PromoCodePage()),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Additional Menu Items - Box 2
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildMenuItem('Profile Settings', '', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserProfile()),
                          );
                        }),
                        _buildMenuItem('Help Center', '', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HelpCenter()),
                          );
                        }),
                        _buildMenuItem('Terms & Conditions', '', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TermsConditions()),
                          );
                        }),
                        _buildMenuItem('Privacy Notice', '', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PrivacyNotice()),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Container biru dengan profile info
          Container(
            padding: const EdgeInsets.only(top: 30),
            height: 120,
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: _buildProfileInfo(),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      color: Colors.blue, // Mengatur latar belakang menjadi biru
      padding: const EdgeInsets.all(
          16), // Menambahkan padding agar konten lebih nyaman
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserProfile()),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SEBASTIAN WIJAYANTO',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors
                            .white), // Ubah teks menjadi putih agar kontras dengan latar belakang biru
                  ),
                  Text(
                    '0852 **** 1234',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14), // Ubah teks menjadi putih
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors
                    .white, // Memberi warna putih agar kontras dengan latar belakang biru
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: const [
                  Icon(Icons.verified_user, size: 16, color: Colors.blue),
                  SizedBox(width: 4),
                  Text(
                    'MY QR',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
      IconData icon, String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(IconData icon, String title, String amount,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Text(
                amount,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, String trailing, VoidCallback onTap) {
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
