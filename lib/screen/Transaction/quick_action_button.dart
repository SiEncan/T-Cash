import 'package:fintar/screen/Transaction/send.dart';
import 'package:fintar/screen/home/screens/linkpay/linkpay_screen.dart';
import 'package:fintar/screen/profile/userprofilecomponents/balance.dart';
import 'package:fintar/screen/qr/qrScanner.dart';
import 'package:flutter/material.dart';

class QuickActionButton extends StatelessWidget {
  const QuickActionButton({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ActionButton(
          icon: Icons.qr_code_scanner,
          label: "Scan",
          backgroundColor: Colors.blue.shade50,
          shadowColor: Colors.blue.shade200,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QRScanner()),
            );
          },
        ),
        ActionButton(
          icon: Icons.add,
          label: "Top Up",
          backgroundColor: Colors.blue.shade50,
          shadowColor: Colors.blue.shade200,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BalancePage(
                        userId: userId,
                      )),
            );
          },
        ),
        ActionButton(
          icon: Icons.send,
          label: "Send",
          backgroundColor: Colors.blue.shade50,
          shadowColor: Colors.blue.shade200,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SendMoneyScreen()),
            );
          },
        ),
        ActionButton(
          icon: Icons.wallet,
          label: "LinkPay",
          backgroundColor: Colors.blue.shade50,
          shadowColor: Colors.blue.shade200,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LinkPaySelectionPage()),
            );
          },
        ),
      ],
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color shadowColor;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.backgroundColor,
    required this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, size: 30, color: Colors.blue.shade700),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
