import 'package:fintar/screen/home/screens/applezone/applezone_screen.dart';
import 'package:fintar/screen/home/screens/discount_voucher/voucher_screen.dart';
import 'package:fintar/screen/home/screens/game/game_screen.dart';
import 'package:fintar/screen/home/screens/kuota/kuota_screen.dart';
import 'package:fintar/screen/home/screens/linkpay/linkpay_screen.dart';
import 'package:fintar/screen/home/screens/pln/pln_screen.dart';
import 'package:fintar/screen/home/screens/pulsa/pulsa_screen.dart';
import 'package:fintar/screen/home/screens/steam/steam_screen.dart';
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
                child: _featureIcon(Icons.sim_card, 'Kuota', Colors.blue, () {
                  Navigator.of(context)
                      .push(createRoute(const KuotaScreen(), 2.0, 0));
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _featureIcon(Icons.card_giftcard, 'Voucher', Colors.blue,
                    () {
                  Navigator.of(context)
                      .push(createRoute(const VoucherScreen(), 2.0, 0));
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _featureIcon(Icons.wallet, 'LinkPay', Colors.blue, () {
                  Navigator.of(context)
                      .push(createRoute(LinkPaySelectionPage(), 2.0, 0));
                }),
              ),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _featureIcon(Icons.apple, 'Apple Zone', Colors.blue, () {
                  Navigator.of(context)
                      .push(createRoute(const AppleZoneScreen(), -1.0, 0));
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
                child: _featureIcon(Icons.gamepad, 'Game', Colors.blue, () {
                  Navigator.of(context)
                      .push(createRoute(const GameScreen(), 2.0, 0));
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _featureIcon(Icons.computer, 'Steam', Colors.blue, () {
                  Navigator.of(context)
                      .push(createRoute(const SteamScreen(), 2.0, 0));
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
