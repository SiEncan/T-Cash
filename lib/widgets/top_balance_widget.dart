import 'package:flutter/material.dart';

class BalanceDisplayWidget extends StatefulWidget {
  const BalanceDisplayWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BalanceDisplayWidgetState createState() => _BalanceDisplayWidgetState();
}

class _BalanceDisplayWidgetState extends State<BalanceDisplayWidget> {
  bool _isBalanceVisible = false; // Inisialisasi dengan default false

  @override
  Widget build(BuildContext context) {
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
              // Widget menampilkan saldo
              _BalanceDisplay(isVisible: _isBalanceVisible),
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

class _BalanceDisplay extends StatelessWidget {
  final bool isVisible;

  const _BalanceDisplay({required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return Text(
      isVisible ? 'RP 37.450' : '*****', // saldo atau tanda bintang
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
