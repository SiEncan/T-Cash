import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintar/widgets/balance_display.dart';
import 'package:flutter/material.dart';

class TopBalance extends StatefulWidget {
  final String userId;

  const TopBalance({
    super.key,
    required this.userId,
  });

  @override
  State<TopBalance> createState() => _TopBalanceState();
}

bool _isBalanceVisible = false;

class _TopBalanceState extends State<TopBalance> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Welcome Back!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Static Balance
          Row(
            children: [
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    );
                  }

                  var userDoc = snapshot.data!;
                  var balance = userDoc['saldo'] ?? 0;

                  return BalanceDisplay(
                    isVisible: _isBalanceVisible,
                    saldo: balance,
                  );
                },
              ),
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
