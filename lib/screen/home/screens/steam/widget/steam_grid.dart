import 'package:fintar/services/auth_services.dart';
import 'package:fintar/widgets/transaction_details_modal.dart';
import 'package:flutter/material.dart';

class SteamGrid extends StatelessWidget {
  SteamGrid({
    super.key,
  });

  final List<Map<String, dynamic>> walletItems = [
    {'display_name': 'Steam Wallet 45.000', 'price': 47500},
    {'display_name': 'Steam Wallet 60.000', 'price': 58000},
    {'display_name': 'Steam Wallet 90.000', 'price': 93000},
    {'display_name': 'Steam Wallet 120.000', 'price': 126000},
    {'display_name': 'Steam Wallet 225.000', 'price': 227500},
    {'display_name': 'Steam Wallet 300.000', 'price': 315000},
    {'display_name': 'Steam Wallet 450.000', 'price': 455000},
    {'display_name': 'Steam Wallet 900.000', 'price': 905500},
    {'display_name': 'Steam Wallet 1.200.000', 'price': 1350000},
    {'display_name': 'Steam Wallet 1.500.000', 'price': 1650000},
  ];

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
    return ListView.builder(
      itemCount: (walletItems.length / 2).ceil(),
      itemBuilder: (context, index) {
        final leftItem = walletItems[index * 2];
        final rightItem = index * 2 + 1 < walletItems.length
            ? walletItems[index * 2 + 1]
            : null;

        // Adjust the price to be higher than the wallet amount
        final int leftPrice =
            leftItem['price'] + 5000; // Increase price by 5000
        String leftFormattedPrice = _formatAmount(leftPrice);

        String? rightFormattedPrice;

        final int rightPrice =
            rightItem?['price'] + 5000; // Increase price by 5000
        rightFormattedPrice = _formatAmount(rightPrice);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side card
              Expanded(
                child: Card(
                  elevation: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: const Color.fromARGB(255, 244, 249, 252),
                  child: InkWell(
                    onTap: () async {
                      String customerName = await AuthService().getFullName();
                      TransactionDetailsModal(
                              customerName: customerName,
                              serviceName: leftItem['display_name'],
                              serviceImage: 'img/Steam_logo.png',
                              amount: leftPrice)
                          .showCustomModal(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Centered Token amount
                          Text(
                            leftItem['display_name'],
                            textAlign: TextAlign.center, // Center the title
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Steam logo
                          Image.asset(
                            'img/Steam_logo.png',
                            height: 50,
                            width: 50,
                          ),
                          const SizedBox(height: 10),
                          // Price
                          Text(
                            leftFormattedPrice,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue[500],
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Right side card (if exists)
              if (rightItem != null)
                Expanded(
                  child: Card(
                    elevation: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: const Color.fromARGB(255, 244, 249, 252),
                    child: InkWell(
                      onTap: () async {
                        String customerName = await AuthService().getFullName();
                        TransactionDetailsModal(
                                customerName: customerName,
                                serviceName: rightItem['display_name'],
                                serviceImage: 'img/Steam_logo.png',
                                amount: rightPrice)
                            .showCustomModal(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Centered Token amount
                            Text(
                              rightItem['display_name'],
                              textAlign: TextAlign.center, // Center the title
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Steam logo
                            Image.asset(
                              'img/Steam_logo.png',
                              height: 50,
                              width: 50,
                            ),
                            const SizedBox(height: 10),
                            // Price
                            Text(
                              rightFormattedPrice,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue[500],
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
