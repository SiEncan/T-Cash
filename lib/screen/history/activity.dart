import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintar/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  // Sample data
  final List<Transaction> transactions = [
    Transaction('Transfer', 'John Doe', 50000, '11 Nov 2024', 'Sent'),
    Transaction('Payment', 'Uber Eats', 12000, '10 Nov 2024', 'Paid'),
    Transaction('Top-up', 'DANA', 100000, '09 Nov 2024', 'Received'),
    Transaction('Purchase', 'Shopee', 25000, '08 Nov 2024', 'Paid'),
    Transaction('Purchase', 'Shopee', 25000, '08 Nov 2024', 'Paid'),
    Transaction('Purchase', 'Shopee', 25000, '08 Nov 2024', 'Paid'),
    Transaction('Purchase', 'Shopee', 25000, '08 Nov 2024', 'Paid'),
    Transaction('Purchase', 'Shopee', 25000, '08 Nov 2024', 'Paid'),
    Transaction('Purchase', 'Shopee', 25000, '08 Nov 2024', 'Paid'),
  ];

  String _selectedFilter = 'All'; // Default filter selected

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
    String userId = AuthService().getUserId();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Center(
            child: Text(
              'Activity',
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_alt, color: Colors.white),
              onPressed: () {
                // _showFilterDialog();
              },
            ),
          ],
        ),
        body: Scaffold(
            backgroundColor: Colors.white,
            body: Column(children: [
              // Filter: Dropdown to select filter criteria
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownButton<String>(
                  value: _selectedFilter,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedFilter = newValue!;
                    });
                  },
                  items: <String>['All', 'Received', 'Sent', 'Payment']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  isExpanded: true,
                ),
              ),

              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection('transactionHistory')
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                        child: Text('Error fetching transactions.'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No recent transactions.'));
                  }

                  final transactions = snapshot.data!.docs.map((doc) {
                    return doc.data() as Map<String, dynamic>;
                  }).toList();

                  final filteredTransactions =
                      transactions.where((transaction) {
                    switch (_selectedFilter) {
                      case 'Received':
                        return transaction['type'] == 'Transfer in' ||
                            transaction['type'] == 'Top-Up';
                      case 'Sent':
                        return transaction['type'] == 'Transfer out';
                      case 'Payment':
                        return transaction['type'] == 'Payment';
                      default:
                        return true; // Filter "All"
                    }
                  }).toList();

                  // Kelompokkan transaksi berdasarkan bulan
                  Map<String, List<Map<String, dynamic>>> groupedTransactions =
                      {};
                  for (var transaction in filteredTransactions) {
                    final date = (transaction['date'] as Timestamp).toDate();
                    final monthKey = DateFormat('MMMM yyyy')
                        .format(date); // Key berdasarkan bulan

                    if (!groupedTransactions.containsKey(monthKey)) {
                      groupedTransactions[monthKey] = [];
                    }
                    groupedTransactions[monthKey]!.add(transaction);
                  }

                  // Hitung total uang berdasarkan bulan
                  return Expanded(
                    child: ListView(
                      children: groupedTransactions.entries.map((entry) {
                        final month = entry.key;
                        final transactions = entry.value;

                        // Hitung total uang untuk bulan ini
                        int totalReceived = 0;
                        int totalSentPayment = 0;

                        for (var transaction in transactions) {
                          final amount = transaction['amount'] as int;
                          final type = transaction['type'] as String;
                          if (type == 'Transfer in' || type == 'Top-Up') {
                            totalReceived += amount;
                          } else if (type == 'Transfer out' ||
                              type == 'Payment') {
                            totalSentPayment += amount;
                          }
                        }

                        final totalAmount = totalReceived - totalSentPayment;
                        String formattedAmount = totalAmount > 0
                            ? '+${_formatAmount(totalAmount)}'
                            : '-${_formatAmount(totalAmount)}';
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              color: Colors.grey[200],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Row(
                                children: [
                                  Text(
                                    month,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  Text(formattedAmount)
                                ],
                              ),
                            ),
                            ...transactions.map((transaction) {
                              final amount = transaction['amount'] as int;
                              final date =
                                  (transaction['date'] as Timestamp).toDate();
                              final type = transaction['type'] as String;
                              final description =
                                  transaction['description'] as String?;

                              return TransactionItem(
                                title: (type.contains('Pay') &&
                                        description != null)
                                    ? description
                                    : type,
                                icon: (type.contains('out'))
                                    ? Icons.send
                                    : (type.contains('Pay'))
                                        ? Icons.shopping_cart_outlined
                                        : (type.contains('Top'))
                                            ? Icons.add_circle
                                            : Icons.arrow_downward,
                                iconColor: Colors.blue,
                                detail: description,
                                date: DateFormat('dd MMM yyyy • HH:mm')
                                    .format(date),
                                amount: (type == 'Transfer out') ||
                                        (type == 'Payment')
                                    ? '-${_formatAmount(amount)}'
                                    : '+${_formatAmount(amount)}',
                              );
                            }),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                },
              )
            ])));
  }
}

class TransactionItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String date;
  final String amount;
  final String? detail;

  const TransactionItem({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.date,
    required this.amount,
    this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[500]!, width: 0.7),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    date,
                    style: TextStyle(color: Colors.grey[700]),
                  )
                ],
              ),
              const Spacer(),
              Text(
                amount,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              )
            ],
          ),
        ),
        Divider(
          color: Colors.grey[300],
          thickness: 1.5,
          indent: 16,
          endIndent: 16,
        ),
      ],
    );
  }
}

class Transaction {
  final String type;
  final String description;
  final double amount;
  final String date;
  final String status;

  Transaction(this.type, this.description, this.amount, this.date, this.status);
}
