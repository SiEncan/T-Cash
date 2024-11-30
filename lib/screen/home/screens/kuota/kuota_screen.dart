import 'package:fintar/screen/home/screens/kuota/widgets/kuota_card.dart';
import 'package:fintar/services/auth_services.dart';
import 'package:fintar/widgets/custom_dialog.dart';
import 'package:fintar/widgets/transaction_details_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KuotaScreen extends StatefulWidget {
  const KuotaScreen({super.key});

  @override
  _KuotaScreenState createState() => _KuotaScreenState();
}

class _KuotaScreenState extends State<KuotaScreen> {
  // Variable to hold the phone number
  final TextEditingController _phoneController = TextEditingController();

  // Data for quota packages
  final List<Map<String, dynamic>> quotaPackages = [
    {
      'originalPrice': 25800,
      'discountPrice': 24990,
      'quota': '3.8 GB',
      'validity': '3 Hari',
      'description': 'Paket Internet Harian',
    },
    {
      'originalPrice': 31000,
      'discountPrice': 29990,
      'quota': '2.5 GB',
      'validity': '7 Hari',
      'description': 'Paket Internet Mingguan',
    },
    {
      'originalPrice': 56700,
      'discountPrice': 54900,
      'quota': '3.3 - 7 GB',
      'validity': '30 Hari',
      'description': 'Paket Internet Bulanan OMG!',
    },
    {
      'originalPrice': 26050,
      'discountPrice': 25200,
      'quota': '300 MB - 1 GB',
      'validity': '30 Hari',
      'description': 'Internet Hemat',
    },
    {
      'originalPrice': 21150,
      'discountPrice': 20500,
      'quota': '4 GB',
      'validity': '30 Hari',
      'description': 'MAXstream 4GB',
    },
    {
      'originalPrice': 49000,
      'discountPrice': 46500,
      'quota': '10 GB',
      'validity': '30 Hari',
      'description': 'Paket Internet 10GB',
    },
    {
      'originalPrice': 75000,
      'discountPrice': 70000,
      'quota': '15 GB',
      'validity': '30 Hari',
      'description': 'Paket Internet 15GB',
    },
    {
      'originalPrice': 90000,
      'discountPrice': 85000,
      'quota': '20 GB',
      'validity': '30 Hari',
      'description': 'Paket Internet 20GB',
    },
    {
      'originalPrice': 115000,
      'discountPrice': 110000,
      'quota': '25 GB',
      'validity': '30 Hari',
      'description': 'Paket Internet 25GB',
    },
    {
      'originalPrice': 150000,
      'discountPrice': 140000,
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
            const Text(
              'Nomor Kamu',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.sim_card, color: Colors.red, size: 32),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    maxLength: 13,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      hintText: 'Masukkan Nomor Telepon',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    buildCounter: (_,
                        {required currentLength,
                        maxLength,
                        required isFocused}) {
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: quotaPackages.length,
                itemBuilder: (context, index) {
                  final package = quotaPackages[index];
                  return KuotaPackageCard(
                    originalPrice: package['originalPrice'],
                    discountPrice: package['discountPrice'],
                    quota: package['quota'],
                    validity: package['validity'],
                    description: package['description'],
                    onTap: () async {
                      String customerName = await AuthService().getFullName();

                      // Pastikan input sudah diisi
                      if (_phoneController.text.trim().isEmpty) {
                        showCustomDialog(
                          context: context,
                          imagePath: 'img/form_failed.png',
                          message: 'Mohon isi Nomor Hp',
                          height: 100,
                          buttonColor: Colors.red,
                        );

                        return;
                      }

                      TransactionDetailsModal(
                              customerName: customerName,
                              serviceName:
                                  'Kuota ${package['quota']} - ${package['description']}\n${package['validity']}',
                              icon: Icons.sim_card,
                              recipientInfo: _phoneController.text.trim(),
                              amount: package['discountPrice'])
                          .showCustomModal(context);
                    },
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
