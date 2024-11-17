import 'package:fintar/screen/home/widgets/purchase_widget.dart';
import 'package:flutter/material.dart';

class MyBillsPage extends StatefulWidget {
  const MyBillsPage({super.key});

  @override
  State<MyBillsPage> createState() => _MyBillsPageState();
}

class _MyBillsPageState extends State<MyBillsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Choose a Bill Category',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ), // Padding untuk konten di bawah container biru
        child: Column(
          children: [
            // kumpulan icon fitur pembelian
            const PurchaseMenu(),
            // notif
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
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
            ),
          ],
        ),
      ),
    );
  }
}
