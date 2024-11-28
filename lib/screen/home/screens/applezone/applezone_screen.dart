import 'package:fintar/screen/home/screens/applezone/widget/product_card.dart';
import 'package:flutter/material.dart';

class AppleZoneScreen extends StatelessWidget {
  const AppleZoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Apple Zone',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            SectionTitle(title: 'iCloud Storage Plans'),
            ProductCard(
              itemName: 'iCloud 50GB (1 Month)',
              description: 'For basic storage needs',
              price: 49000,
              icon: Icons.cloud,
            ),
            ProductCard(
              itemName: 'iCloud 200GB (1 Month)',
              description: 'For medium storage needs',
              price: 99000,
              icon: Icons.cloud,
            ),
            ProductCard(
              itemName: 'iCloud 2TB (1 Month)',
              description: 'For heavy storage needs',
              price: 249000,
              icon: Icons.cloud,
            ),
            SizedBox(height: 20),
            SectionTitle(title: 'Apple Music Subscriptions'),
            ProductCard(
              itemName: 'Apple Music (1 Month)',
              description: 'Stream millions of songs',
              price: 9990,
              icon: Icons.music_note,
            ),
            ProductCard(
              itemName: 'Apple Music (3 Months)',
              description: 'Special rate for 3 Months',
              price: 19950,
              icon: Icons.music_note,
            ),
            ProductCard(
              itemName: 'Apple Music Family (1 Month)',
              description: 'Stream for up to 6 members',
              price: 59990,
              icon: Icons.music_note,
            ),
            SizedBox(height: 20),
            SectionTitle(title: 'Apple Arcade'),
            ProductCard(
              itemName: 'Apple Arcade Monthly (1 Month)',
              description: 'Unlimited access to 200+ games',
              price: 14500,
              icon: Icons.videogame_asset,
            ),
            ProductCard(
              itemName: 'Apple Arcade Yearly (12 Months)',
              description: 'Save more with a yearly plan',
              price: 89000,
              icon: Icons.videogame_asset,
            ),
            ProductCard(
              itemName: 'Apple Family Arcade Plan (1 Month)',
              description: 'Play with up to 6 family members',
              price: 23900,
              icon: Icons.videogame_asset,
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
