import 'package:flutter/material.dart';
import 'widgets/voucher_card.dart';
import 'data/voucher_data.dart';

class VoucherScreen extends StatelessWidget {
  const VoucherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text(
          "T-CASH Deals",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children:
              vouchers.map((voucher) => VoucherCard(voucher: voucher)).toList(),
        ),
      ),
    );
  }
}
