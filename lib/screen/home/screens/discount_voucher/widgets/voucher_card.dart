import 'package:fintar/services/auth_services.dart';
import 'package:fintar/widgets/transaction_details_modal.dart';
import 'package:flutter/material.dart';

class VoucherCard extends StatelessWidget {
  final Map<String, dynamic> voucher;

  const VoucherCard({required this.voucher, super.key});

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
    return InkWell(
      onTap: () async {
        String customerName = await AuthService().getFullName();
        TransactionDetailsModal(
                customerName: customerName,
                serviceName:
                    'Voucher ${voucher['title']} ${voucher['originalPrice']}',
                serviceImage: voucher['logoImage'],
                expiryDate: voucher['expiryDate'],
                amount: voucher['discountedPrice'])
            .showCustomModal(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: AssetImage(voucher['backgroundImage']),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 45,
                top: 30,
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(voucher['logoImage']),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(100, 10, 30, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            voucher['title'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            voucher['originalPrice'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            voucher['description'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 50, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _formatAmount(voucher['discountedPrice']),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Tersedia sampai",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            voucher['expiryDate'],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
