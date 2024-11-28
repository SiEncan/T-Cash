import 'package:fintar/widgets/transaction_details_modal.dart';
import 'package:flutter/material.dart';
import 'package:fintar/screen/home/screens/pulsa/widgets/pulsa_card_widget.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class PulsaGrid extends StatelessWidget {
  String selectedProviderParam;
  String phoneNumber;
  String receiverName;

  PulsaGrid(
      {super.key,
      required this.selectedProviderParam,
      required this.phoneNumber,
      required this.receiverName});

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

  late List<int> hargaPulsa; // declare list harga pulsa

  String _formatAmount(dynamic amount) {
    String text = amount is int ? amount.toString() : amount.toString();

    if (text.isEmpty) return '';
    final number = int.parse(text.replaceAll(RegExp(r'[^0-9]'), ''));

    return 'Rp${number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  @override
  Widget build(BuildContext context) {
    //  harga pulsa berdasarkan selected provider
    if (selectedProviderParam == 'IM3') {
      hargaPulsa = [
        7000,
        12000,
        17000,
        21000,
        26000,
        31000,
        41000,
        51000,
        61000,
        71000,
        81000,
        91000,
        101000
      ];
    } else if (selectedProviderParam == 'Telkomsel') {
      hargaPulsa = [
        8000,
        13000,
        18000,
        22000,
        28000,
        32500,
        42500,
        52500,
        62500,
        72500,
        82500,
        92500,
        102500
      ];
    } else if (selectedProviderParam == 'XL') {
      hargaPulsa = [
        7500,
        12500,
        17500,
        21500,
        26500,
        31500,
        41500,
        51500,
        61500,
        71500,
        81500,
        91500,
        101500
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
        return InkWell(
          child: PulsaCard(
            jumlahPulsa: jumlahPulsa[index],
            hargaPulsa: _formatAmount(hargaPulsa[index]),
          ),
          onTap: () {
            String withoutK = jumlahPulsa[index].replaceAll('k', '000');
            int value = int.parse(withoutK);
            String formattedAmount =
                NumberFormat('#,###', 'id_ID').format(value);

            TransactionDetailsModal(
                    customerName: receiverName,
                    serviceName:
                        'Pulsa $selectedProviderParam $formattedAmount',
                    serviceImage: 'img/$selectedProviderParam.png',
                    recipientInfo: phoneNumber,
                    amount: hargaPulsa[index])
                .showCustomModal(context);
          },
        );
      },
    );
  }
}
