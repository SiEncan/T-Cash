// profile.dart
import 'package:fintar/screen/qr/generateQr.dart';
import 'package:fintar/widgets/custom_page_transition.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fintar/screen/profile/userprofilecomponents/user_profile.dart';
import 'package:fintar/screen/profile/userprofilecomponents/balance.dart';
import 'package:fintar/screen/profile/userprofilecomponents/transaction_history.dart';
import 'package:fintar/screen/profile/userprofilecomponents/income_expense_page.dart';
import 'package:fintar/screen/profile/userprofilecomponents/donation.dart';
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
  String profileName = 'Loading...';
  String profilePhone = 'Loading...';
  String profileImageUrl = '';
  int profileBalance = 0;
  int profileIncome = 0;
  int profileExpense = 0;
  String profileUserId = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }

      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      final startOfMonth =
          DateTime(DateTime.now().year, DateTime.now().month, 1);
      final endOfMonth =
          DateTime(DateTime.now().year, DateTime.now().month, 31);

      final incomeSnapshot = await userDoc
          .collection('transactionHistory')
          .where('type', whereIn: ['Top-Up', 'Transfer in'])
          .where('date', isGreaterThanOrEqualTo: startOfMonth)
          .where('date', isLessThanOrEqualTo: endOfMonth)
          .orderBy('date', descending: false)
          .get();

      final expenseSnapshot = await userDoc
          .collection('transactionHistory')
          .where('type', whereIn: ['Payment', 'Transfer out'])
          .where('date', isGreaterThanOrEqualTo: startOfMonth)
          .where('date', isLessThanOrEqualTo: endOfMonth)
          .orderBy('date', descending: false)
          .get();

      final totalIncome = incomeSnapshot.docs.fold<int>(
        0,
        (sums, doc) =>
            sums + ((doc.data()['amount'] as num).toDouble()).toInt(),
      );

      final totalExpense = expenseSnapshot.docs.fold<int>(
        0,
        (sums, doc) =>
            sums + ((doc.data()['amount'] as num).toDouble()).toInt(),
      );

      final profileSnapshot = await userDoc.get();
      final profileData = profileSnapshot.data() as Map<String, dynamic>;

      setState(() {
        profileUserId = user.uid;
        profileName = profileData['fullName'];
        profilePhone = profileData['phone'];
        profileImageUrl = profileData['profileImageUrl'] ?? '';
        profileBalance = profileData['saldo'];
        profileIncome = totalIncome;
        profileExpense = totalExpense;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  String _formatCurrency(num value) {
    return 'Rp${value.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

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
                mainAxisSize: MainAxisSize.min, // Biarkan tinggi fleksibel
                children: [
                  // Feature Grid
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildFeatureItem(
                          Icons.account_balance,
                          'Balance',
                          _formatCurrency(profileBalance),
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BalancePage(userId: profileUserId)),
                            );
                          },
                        ),
                        _buildFeatureItem(
                          Icons.history,
                          'Transaction History',
                          'All Transactions',
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TransactionHistory(),
                              ),
                            );
                          },
                        ),
                        _buildFeatureItem(
                          Icons.volunteer_activism,
                          'Donation Hub',
                          'Support system',
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DonationHub(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Income/Expense Row
                  Container(
                    height: 80,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildTransactionItem(
                          Icons.arrow_downward,
                          'Income',
                          _formatCurrency(profileIncome),
                          Colors.green,
                          () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const IncomeExpensePage(),
                                ));
                          },
                        ),
                        VerticalDivider(
                          color: Colors.grey[400],
                          thickness: 1,
                        ),
                        _buildTransactionItem(
                          Icons.arrow_upward,
                          'Expense',
                          _formatCurrency(profileExpense),
                          Colors.orange,
                          () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const IncomeExpensePage(),
                                ));
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Additional Menu Items - Box 1
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
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
                  const SizedBox(height: 120), // Spasi tambahan di bagian bawah
                ],
              ),
            ),
          ),
          // Container biru dengan profile info
          Container(
            padding: const EdgeInsets.only(top: 30),
            height: 120,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 0, 124, 226),
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
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const UserProfile(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0); // Slide from right
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );

              _fetchUserProfile();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[500],
                    child: ClipOval(
                      child: profileImageUrl.isNotEmpty
                          ? Image.network(
                              profileImageUrl,
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                        : null,
                                    strokeWidth: 2,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            Colors.white),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.error,
                                  size: 40,
                                  color: Colors.red,
                                );
                              },
                            )
                          : const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white,
                            ),
                    ),
                  ),

                  const SizedBox(width: 16), // Spasi antar avatar dan teks
                  // Informasi profil
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profileName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                            height: 4), // Spasi antar nama dan nomor telepon
                        Text(
                          profilePhone,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Tombol "MY QR"
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .push(createRoute(UserQRCode(), 1, 0)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.verified_user,
                              size: 16, color: Colors.blue),
                          SizedBox(width: 4), // Spasi antar ikon dan teks
                          Text(
                            'MY QR',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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
            mainAxisAlignment: MainAxisAlignment.center,
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
