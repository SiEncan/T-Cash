import 'package:fintar/services/passcode_checker.dart';
import 'package:fintar/widgets/transaction_details_modal.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class PlnGridWidget extends StatelessWidget {
  final String customerName;
  final String meterNumber;

  PlnGridWidget({
    super.key,
    required this.customerName,
    required this.meterNumber,
  });

  final NumberFormat numberFormat = NumberFormat('#,###', 'id_ID');
  final List<int> tokenAmounts = [20, 50, 100, 200, 500, 1000];
  final passcodeChecker = PasscodeChecker();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tokenAmounts.length + 1, // tambah 1 untuk "CHOOSE TOKEN"
      itemBuilder: (context, index) {
        if (index == 0) {
          // text ini item pertama
          return Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text(
              'CHOOSE TOKEN',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          );
        }
        final int nominal = tokenAmounts[index - 1];
        final int price = nominal * 1000 + 1500;
        String formattedPrice = numberFormat.format(price);

        String tokenDisplay;
        if (nominal < 1000) {
          tokenDisplay = '$nominal.000';
        } else {
          tokenDisplay = '1.000.000';
        }

        return Card(
          color: Colors.white,
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
            title: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (nominal < 1000)
                        ? RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '$nominal',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                WidgetSpan(
                                  child: Transform.translate(
                                    offset: const Offset(2, -2),
                                    child: const Text(
                                      'k',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: '1',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                WidgetSpan(
                                  child: Transform.translate(
                                    offset: const Offset(2, -2),
                                    child: const Text(
                                      'Mil',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(height: 32),
                    Text(
                      'Rp $formattedPrice',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue[500],
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                const Spacer(),
                Image.asset(
                  'img/Logo_PLN.png',
                  height: 80,
                  width: 80,
                ),
              ],
            ),
            onTap: () {
              TransactionDetailsModal(
                      customerName: customerName,
                      serviceName: 'Token PLN $tokenDisplay',
                      serviceImage: 'img/Logo_PLN.png',
                      recipientInfo: meterNumber,
                      amount: price)
                  .showCustomModal(context);
            },
          ),
        );
      },
    );
  }
}
