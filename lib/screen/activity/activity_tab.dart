import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintar/screen/activity/transaction_detail.dart';
import 'package:fintar/services/auth_services.dart';
import 'package:fintar/widgets/custom_page_transition.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityTab extends StatefulWidget {
  const ActivityTab({super.key});

  @override
  ActivityTabState createState() => ActivityTabState();
}

class ActivityTabState extends State<ActivityTab> {
  final int _pageSize = 10; // Jumlah transaksi per halaman
  final List<Map<String, dynamic>> _transactions = [];
  DocumentSnapshot? _lastDocument;
  bool _isLoading = false;
  bool _hasMore = true;
  final ScrollController _scrollController = ScrollController();
  String _selectedFilter = 'All'; // Filter default

  @override
  void initState() {
    super.initState();
    _fetchTransactions();

    // Listener untuk mendeteksi scroll sampai bawah
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMore) {
        _fetchTransactions();
      }
    });
  }

  Future<void> _fetchTransactions() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      String userId = AuthService().getUserId();

      Query query = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('transactionHistory')
          .orderBy('date', descending: true)
          .limit(_pageSize);

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      QuerySnapshot querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _transactions.addAll(querySnapshot.docs.map((doc) {
            return {
              ...doc.data() as Map<String, dynamic>,
              'id': doc.id,
            };
          }).toList());

          _lastDocument = querySnapshot.docs.last;

          if (querySnapshot.docs.length < _pageSize) {
            _hasMore = false;
          }
        });
      } else {
        setState(() {
          _hasMore = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching transactions: $e");
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
    // Filter transaksi berdasarkan kategori
    final filteredTransactions = _transactions.where((transaction) {
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
    final Map<String, List<Map<String, dynamic>>> groupedTransactions = {};
    for (var transaction in filteredTransactions) {
      final date = (transaction['date'] as Timestamp).toDate();
      final monthKey = DateFormat('MMMM yyyy').format(date);

      if (!groupedTransactions.containsKey(monthKey)) {
        groupedTransactions[monthKey] = [];
      }
      groupedTransactions[monthKey]!.add(transaction);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(
          child: Text(
            'Activity',
            style: TextStyle(color: Colors.white),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt, color: Colors.white),
            onPressed: () {
              // Filter logic
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Dropdown untuk filter
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
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

          // ListView untuk transaksi
          Expanded(
            child: filteredTransactions.isEmpty
                ? Center(
                    child: Text(
                      'No recent activity',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.only(bottom: 128),
                    controller: _scrollController,
                    children: groupedTransactions.entries.map((entry) {
                      final month = entry.key;
                      final transactions = entry.value;

                      final now = DateTime.now();
                      final currentMonth = DateFormat('MMMM yyyy').format(now);
                      final displayMonth =
                          (month == currentMonth) ? 'This Month' : month;

                      // Hitung total transaksi untuk bulan ini
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
                          // Header untuk bulan
                          Container(
                            color: Colors.grey[200],
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Row(
                              children: [
                                Text(
                                  displayMonth,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                Text(formattedAmount),
                              ],
                            ),
                          ),

                          // Daftar transaksi dalam bulan
                          ...transactions.map((transaction) {
                            final amount = transaction['amount'] as int;
                            final date =
                                (transaction['date'] as Timestamp).toDate();
                            final type = transaction['type'] as String;

                            final additionalInfo =
                                transaction['additionalInfo'] as String?;
                            final description =
                                transaction['description'] as String?;
                            final partyName =
                                transaction['partyName'] as String?;
                            final note = transaction['note'] as String?;

                            return TransactionItem(
                              transactionId: transaction['id'],
                              type: type,
                              titleDisplay:
                                  (type.contains('Pay') && description != null)
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
                              date: DateFormat('dd MMM yyyy • HH:mm')
                                  .format(date),
                              amount: (type == 'Transfer out') ||
                                      (type == 'Payment')
                                  ? '-${_formatAmount(amount)}'
                                  : '+${_formatAmount(amount)}',
                              description: description,
                              partyName: partyName,
                              note: note,
                              additionalInfo: additionalInfo,
                            );
                          }),
                        ],
                      );
                    }).toList(),
                  ),
          ),

          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class TransactionItem extends StatelessWidget {
  final String transactionId;
  final String type;
  final String titleDisplay;
  final IconData icon;
  final Color iconColor;
  final String date;
  final String amount;
  final String? additionalInfo;
  final String? description;
  final String? partyName;
  final String? note;

  const TransactionItem({
    super.key,
    required this.transactionId,
    required this.type,
    required this.titleDisplay,
    required this.icon,
    required this.iconColor,
    required this.date,
    required this.amount,
    this.additionalInfo,
    this.description,
    this.partyName,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        String fullName = await AuthService().getFullName();

        Navigator.of(context).push(createRoute(
            DetailScreen(
                transactionId: transactionId,
                fullName: fullName,
                type: type,
                date: date,
                amount: amount,
                additionalInfo: additionalInfo,
                description: description,
                partyName: partyName,
                note: note),
            0,
            1));
      },
      splashColor: Colors.grey.withOpacity(0.3),
      highlightColor: Colors.grey.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      child: Column(
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titleDisplay,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        date,
                        style: TextStyle(color: Colors.grey[700]),
                      )
                    ],
                  ),
                ),
                Text(
                  amount,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16),
                ),
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
      ),
    );
  }
}
