import 'package:fintar/pulsa.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool _isBalanceVisible = true; // Variabel untuk mengontrol visibilitas saldo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(
                top: 106), // Padding untuk konten di bawah container biru
            child: Column(
              children: [
                // kumpulan icon fitur
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(2, 16, 2, 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _featureIcon(Icons.phone, 'Pulsa/Data', Colors.blue,
                                () {
                              Navigator.of(context)
                                  .push(_createRoute(const Pulsa()));
                            }),
                            _featureIcon(
                                Icons.card_giftcard, 'Voucher', Colors.blue,
                                () {
                              // gesture
                            }),
                            _featureIcon(
                                Icons.local_movies, 'TIX ID', Colors.blue, () {
                              // gesture
                            }),
                            _featureIcon(
                                Icons.line_axis, 'Investasi', Colors.blue, () {
                              // gesture
                            }),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _featureIcon(Icons.apple, 'Apple Zone', Colors.blue,
                                () {
                              // gesture
                            }),
                            _featureIcon(
                                Icons.electric_bolt_sharp, 'PLN', Colors.blue,
                                () {
                              // gesture
                            }),
                            _featureIcon(Icons.receipt, 'Pajak', Colors.blue,
                                () {
                              // gesture
                            }),
                            _featureIcon(Icons.gavel, 'Beli Emas', Colors.blue,
                                () {
                              // gesture
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
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
                      padding:
                          EdgeInsets.all(16.0), // Jarak antara icon dan tepi
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
                        _isBalanceVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
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
          ),
        ],
      ),
    );
  }
}

// Widget untuk menampilkan saldo
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

Widget _featureIcon(
    IconData icon, String label, Color color, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 30, color: color),
        const SizedBox(height: 8), // Jarak antara icon dan label
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13),
        ),
      ],
    ),
  );
}

Route _createRoute(Widget widget) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(2.0, 0.0); // Mulai dari kanan
      const end = Offset.zero; // Akhir di posisi normal
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
