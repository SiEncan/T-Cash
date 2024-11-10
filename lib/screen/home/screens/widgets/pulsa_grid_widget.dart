import 'package:flutter/material.dart';
import 'package:fintar/screen/home/screens/widgets/pulsa_card_widget.dart';

class PulsaGrid extends StatelessWidget {
  String selectedProviderParam;

  PulsaGrid({super.key, required this.selectedProviderParam});

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

  late List<String> hargaPulsa; // declare list harga pulsa

  @override
  Widget build(BuildContext context) {
    //  harga pulsa berdasarkan selected provider
    if (selectedProviderParam == 'IM3') {
      hargaPulsa = [
        'Rp7.000',
        'Rp12.000',
        'Rp17.000',
        'Rp21.000',
        'Rp26.000',
        'Rp31.000',
        'Rp41.000',
        'Rp51.000',
        'Rp61.000',
        'Rp71.000',
        'Rp81.000',
        'Rp91.000',
        'Rp101.000'
      ];
    } else if (selectedProviderParam == 'telkomsel') {
      hargaPulsa = [
        'Rp8.000',
        'Rp13.000',
        'Rp18.000',
        'Rp22.000',
        'Rp28.000',
        'Rp32.500',
        'Rp42.500',
        'Rp52.500',
        'Rp62.500',
        'Rp72.500',
        'Rp82.500',
        'Rp92.500',
        'Rp102.500'
      ];
    } else if (selectedProviderParam == 'XL') {
      hargaPulsa = [
        'Rp7.500',
        'Rp12.500',
        'Rp17.500',
        'Rp21.500',
        'Rp26.500',
        'Rp31.500',
        'Rp41.500',
        'Rp51.500',
        'Rp61.500',
        'Rp71.500',
        'Rp81.500',
        'Rp91.500',
        'Rp101.500'
      ];
    }

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
