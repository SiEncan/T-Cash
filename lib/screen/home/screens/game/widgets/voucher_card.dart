import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  final String gameName;
  final String voucherName;
  final String voucherPrice;

  const GameCard({
    super.key,
    required this.gameName,
    required this.voucherName,
    required this.voucherPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo Image Game
            if (gameName.contains('Free Fire'))
              Image.asset(
                'img/free_fire.jpg',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              )
            else
              Image.asset(
                'img/mobile_legend.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 8),

            Text(
              gameName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 2),

            Text(
              voucherName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            Text(
              voucherPrice,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
