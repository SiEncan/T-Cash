import 'package:fintar/pulsa.dart';
import 'package:flutter/material.dart';
import 'package:fintar/widgets/top_balance_widget.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Stack(
              children: [
                Stack(children: [
                  Container(
                      color: const Color.fromARGB(255, 25, 140, 235),
                      width: 500,
                      height: 220),
                  Positioned(
                    top: 62, // posisi dari atas
                    child: Image.asset(
                      'img/ads.jpg',
                      width: 412,
                      height: 200,
                    ),
                  )
                ]),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 190), // Padding untuk konten di bawah container biru
                  child: Column(
                    children: [
                      // kumpulan icon fitur
                      Container(
                        margin: const EdgeInsets.fromLTRB(12, 20, 12, 10),
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _featureIcon(
                                    Icons.phone, 'Pulsa/Data', Colors.blue, () {
                                  Navigator.of(context).push(
                                      _createRoute(const Pulsa(), 2.0, 0));
                                }),
                                _featureIcon(
                                    Icons.card_giftcard, 'Voucher', Colors.blue,
                                    () {
                                  // gesture
                                }),
                                _featureIcon(
                                    Icons.local_movies, 'TIX ID', Colors.blue,
                                    () {
                                  // gesture
                                }),
                                _featureIcon(
                                    Icons.line_axis, 'Investasi', Colors.blue,
                                    () {
                                  // gesture
                                }),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _featureIcon(
                                    Icons.apple, 'Apple Zone', Colors.blue, () {
                                  // gesture
                                }),
                                _featureIcon(Icons.electric_bolt_sharp, 'PLN',
                                    Colors.blue, () {
                                  // gesture
                                }),
                                _featureIcon(
                                    Icons.receipt, 'Pajak', Colors.blue, () {
                                  // gesture
                                }),
                                _featureIcon(
                                    Icons.gavel, 'Beli Emas', Colors.blue, () {
                                  // gesture
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.notifications_active,
                                    size: 20, color: Colors.blue[400]),
                                const SizedBox(width: 8),
                                const Text(
                                  "Bastian",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  "sent you Rp 25.000",
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(width: 6),
                                Icon(Icons.send_and_archive_outlined,
                                    size: 20, color: Colors.blue[400]),
                                const Spacer(),
                                const Text(
                                  "28/10",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.notifications_active,
                                    size: 20, color: Colors.blue[400]),
                                const SizedBox(width: 8),
                                const Text(
                                  "Afzaal",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  "sent you Rp 10.000",
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(width: 6),
                                Icon(Icons.send_and_archive_outlined,
                                    size: 20, color: Colors.blue[400]),
                                const Spacer(),
                                const Text(
                                  "28/10",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.notifications_active,
                                    size: 20, color: Colors.blue[400]),
                                const SizedBox(width: 8),
                                const Text(
                                  "T-Cash",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(width: 4),
                                const Flexible(
                                  child: Text(
                                    "Enjoy your trip by using 20% OFF T-Cash Voucher",
                                    style: TextStyle(fontSize: 12),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(Icons.celebration,
                                    size: 20, color: Colors.blue[400]),
                                const SizedBox(width: 6),
                                const Text(
                                  "26/10",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text(
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                  "Feeds",
                                  textAlign: TextAlign.right,
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        _createRoute(const Pulsa(), 0, 1.0));
                                  },
                                  child: const Text(
                                    "View All",
                                    style: TextStyle(
                                      fontSize: 12,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const BalanceDisplayWidget()
        ],
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

Route _createRoute(Widget widget, double x, double y) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(x, y); // Mulai dari mana
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
