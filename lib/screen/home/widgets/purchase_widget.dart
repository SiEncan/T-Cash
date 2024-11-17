import 'package:fintar/screen/home/screens/pln/pln_screen.dart';
import 'package:fintar/screen/home/screens/pulsa/pulsa_screen.dart';
import 'package:fintar/widgets/custom_page_transition.dart';
import 'package:flutter/material.dart';

class PurchaseMenu extends StatelessWidget {
  const PurchaseMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Table(
        children: [
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(
                    8.0), // Adjusts spacing around each icon
                child: _featureIcon(Icons.phone, 'Pulsa', Colors.blue, () {
                  Navigator.of(context)
                      .push(createRoute(const PulsaScreen(), 2.0, 0));
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _featureIcon(Icons.card_giftcard, 'Voucher', Colors.blue,
                    () {
                  // gesture
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    _featureIcon(Icons.local_movies, 'TIX ID', Colors.blue, () {
                  // gesture
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    _featureIcon(Icons.line_axis, 'Investasi', Colors.blue, () {
                  // gesture
                }),
              ),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _featureIcon(Icons.apple, 'Apple Zone', Colors.blue, () {
                  // gesture
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _featureIcon(
                    Icons.electric_bolt_sharp, 'PLN', Colors.blue, () {
                  Navigator.of(context)
                      .push(createRoute(const PlnScreen(), 2.0, 0));
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _featureIcon(Icons.receipt, 'Pajak', Colors.blue, () {
                  // gesture
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _featureIcon(Icons.gavel, 'Beli Emas', Colors.blue, () {
                  // gesture
                }),
              ),
            ],
          ),
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
