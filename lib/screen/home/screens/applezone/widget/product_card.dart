import 'package:fintar/screen/home/screens/applezone/widget/bottom_sheet.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String itemName;
  final String description;
  final int price;
  final IconData icon;

  const ProductCard({
    super.key,
    required this.itemName,
    required this.description,
    required this.price,
    required this.icon,
  });

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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(
          itemName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          '$description\n${_formatAmount(price)}',
          style: const TextStyle(fontSize: 14),
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
            ),
            builder: (BuildContext context) {
              return BottomSheetContent(
                itemName: itemName,
                price: price,
                icon: icon,
              );
            },
          );
        },
      ),
    );
  }
}
