import 'package:fintar/screen/home/screens/kuota/widgets/kuota_card.dart';
import 'package:flutter/material.dart';

class KuotaScreen extends StatefulWidget {
  @override
  _KuotaScreenState createState() => _KuotaScreenState();
}

class _KuotaScreenState extends State<KuotaScreen> {
  // Variable to hold the phone number
  TextEditingController _phoneController =
      TextEditingController(text: '0821 1117 8512');

  // Data for quota packages
  final List<Map<String, String>> quotaPackages = [
    {
      'originalPrice': 'Rp25.800',
      'discountPrice': 'Rp24.990',
      'quota': '3.8 GB',
      'validity': '3 Hari',
      'description': 'Paket Internet Harian 25K',
    },
    {
      'originalPrice': 'Rp31.000',
      'discountPrice': 'Rp29.990',
      'quota': '2.5 GB',
      'validity': '7 Hari',
      'description': 'Paket Internet Mingguan 30K',
    },
    {
      'originalPrice': 'Rp56.700',
      'discountPrice': 'Rp54.900',
      'quota': '3.3 - 7 GB',
      'validity': '30 Hari',
      'description': 'Paket Internet Bulanan OMG!',
    },
    {
      'originalPrice': 'Rp26.050',
      'discountPrice': 'Rp25.200',
      'quota': '300 MB - 1 GB',
      'validity': '30 Hari',
      'description': 'Pulsa Internet Rp25.000',
    },
    {
      'originalPrice': 'Rp21.150',
      'discountPrice': 'Rp20.500',
      'quota': '4 GB',
      'validity': '30 Hari',
      'description': 'MAXstream 4GB',
    },
    {
      'originalPrice': 'Rp49.000',
      'discountPrice': 'Rp46.500',
      'quota': '10 GB',
      'validity': '30 Hari',
      'description': 'Paket Internet 10GB',
    },
    {
      'originalPrice': 'Rp75.000',
      'discountPrice': 'Rp70.000',
      'quota': '15 GB',
      'validity': '30 Hari',
      'description': 'Paket Internet 15GB',
    },
    {
      'originalPrice': 'Rp90.000',
      'discountPrice': 'Rp85.000',
      'quota': '20 GB',
      'validity': '30 Hari',
      'description': 'Paket Internet 20GB',
    },
    {
      'originalPrice': 'Rp115.000',
      'discountPrice': 'Rp110.000',
      'quota': '25 GB',
      'validity': '30 Hari',
      'description': 'Paket Internet 25GB',
    },
    {
      'originalPrice': 'Rp150.000',
      'discountPrice': 'Rp140.000',
      'quota': '30 GB',
      'validity': '30 Hari',
      'description': 'Paket Internet 30GB',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nomor Kamu',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.sim_card, color: Colors.red, size: 32),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan Nomor Telepon',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: quotaPackages.length,
                itemBuilder: (context, index) {
                  final package = quotaPackages[index];
                  return QuotaPackageCard(
                    originalPrice: package['originalPrice']!,
                    discountPrice: package['discountPrice']!,
                    quota: package['quota']!,
                    validity: package['validity']!,
                    description: package['description']!,
                    onTap: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
