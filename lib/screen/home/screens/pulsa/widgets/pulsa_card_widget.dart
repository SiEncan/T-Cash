import 'package:flutter/material.dart';

class PulsaCard extends StatelessWidget {
  final String jumlahPulsa;
  final String hargaPulsa;

  const PulsaCard(
      {super.key, required this.jumlahPulsa, required this.hargaPulsa});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Stack(
        children: [
          Image.asset(
            'img/blue_card.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            alignment: Alignment.topLeft,
            color: Colors.black.withOpacity(0.07),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
              child: Text(
                jumlahPulsa,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              hargaPulsa,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
