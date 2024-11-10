import 'package:flutter/material.dart';
import 'package:fintar/screen/home/screens/widgets/pulsa_card_widget.dart';

class PulsaGrid extends StatelessWidget {
  final List<String> jumlahPulsa = [
    '5k',
    '10k',
    '15k',
    '20k',
    '25k',
    '30k',
    '40k',
    '50k',
    '60k',
    '70k',
    '80k',
    '90k',
    '100k'
  ];
  final List<String> hargaPulsa = [
    'Rp7.500',
    'Rp12.500',
    'Rp17.500',
    'Rp21.500',
    'Rp27.000',
    'Rp31.500',
    'Rp41.500',
    'Rp51.500',
    'Rp61.500',
    'Rp71.500',
    'Rp81.500',
    'Rp91.500',
    'Rp101.500'
  ];

  PulsaGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 3 / 2,
      ),
      itemCount: jumlahPulsa.length,
      itemBuilder: (context, index) {
        return PulsaCard(
          jumlahPulsa: jumlahPulsa[index],
          hargaPulsa: hargaPulsa[index],
        );
      },
    );
  }
}
