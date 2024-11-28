import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecentTransaction extends StatelessWidget {
  final String userId;

  const RecentTransaction({super.key, required this.userId});

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
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('transactionHistory')
          .orderBy('date', descending: true)
          .limit(10)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error fetching transactions.'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No recent transactions.'));
        }

        final transactions = snapshot.data!.docs;

        return Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction =
                  transactions[index].data() as Map<String, dynamic>;
              final amount = transaction['amount'] as int;
              final date = (transaction['date'] as Timestamp).toDate();
              final type = transaction['type'] as String;
              final partyName = transaction['partyName'] as String?;
              final description = transaction['description'] as String?;

              // Format date
              String formattedDate = DateFormat('E, dd MMMM yyyy').format(date);

              return TransactionItem(
                title: type,
                detail: type.toLowerCase().contains('transfer')
                    ? partyName
                    : type.toLowerCase().contains('top-up')
                        ? description
                        : (type == 'Payment')
                            ? description
                            : null,
                date: formattedDate,
                amount: (type == 'Transfer out') || (type == 'Payment')
                    ? '-${_formatAmount(amount)}'
                    : (type == 'Transfer in') || (type.contains('Top-Up'))
                        ? '+${_formatAmount(amount)}'
                        : '',
                amountColor: (type == 'Transfer out') || (type == 'Payment')
                    ? Colors.red.shade700
                    : (type == 'Transfer in') || (type.contains('Top-Up'))
                        ? Colors.green.shade700
                        : Colors.black,
              );
            },
          ),
        );
      },
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String title;
  final String date;
  final String amount;
  final String? detail;
  final Color amountColor;

  const TransactionItem({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    this.detail,
    required this.amountColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              detail != null && detail!.isNotEmpty
                  ? Column(
                      children: [
                        const SizedBox(height: 2),
                        Text(
                          detail!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    )
                  : const SizedBox(height: 4),
              Text(
                date,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
}
