import 'package:fintar/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class BalanceDisplayWidget extends StatefulWidget {
  const BalanceDisplayWidget({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _BalanceDisplayWidgetState createState() => _BalanceDisplayWidgetState();
}

class _BalanceDisplayWidgetState extends State<BalanceDisplayWidget> {
  bool _isBalanceVisible = true; // Inisialisasi dengan default false
  int saldo = 0;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    String userId = AuthService().getUserId();

    return Container(
      padding: const EdgeInsets.only(top: 42), // Padding ke atas layar hp
      height: 106, // Tinggi Container
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0), // Jarak antara icon dan tepi
                child: Icon(
                  Icons.account_balance,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              // Widget menampilkan saldo / Menampilkan loading jika data sedang diambil
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId) // Menggunakan UID untuk mendapatkan dokumen
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ); // Menunggu data
                  }

                  var userDoc = snapshot.data!;
                  var balance = userDoc['saldo'] ?? 0;

                  return _BalanceDisplay(
                    isVisible: _isBalanceVisible,
                    saldo: balance,
                  );
                },
              ),

              // Tombol hide/unhide saldo
              IconButton(
                icon: Icon(
                  _isBalanceVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isBalanceVisible =
                        !_isBalanceVisible; // Toggle saldo visibility
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String formatSaldo(int saldo) {
  final formatter = NumberFormat('#,###');
  return formatter.format(saldo);
}

class _BalanceDisplay extends StatelessWidget {
  final bool isVisible;
  final int saldo;

  const _BalanceDisplay({required this.isVisible, required this.saldo});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Rp',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(137, 255, 255, 255),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.2, end: 1.0).animate(animation),
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.2, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
              );
            },
            child: Text(
              isVisible
                  ? ' ${formatSaldo(saldo)}'
                  : ' *****', // saldo atau tanda bintang
              key: ValueKey<bool>(isVisible),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
