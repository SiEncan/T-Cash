import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fintar/screen/profile/userprofilecomponents/income_page.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  List<double> dailyData = [];
  List<String> dailyDates = [];
  List<Map<String, dynamic>> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchExpenseData();
  }

  Future<void> _fetchExpenseData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userId = user.uid;
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);

      // Fetch daily expenses (grafik)
      final expenseSnapshot =
          await userDoc.collection('dailyExpense').orderBy('date').get();
      final expenseData = expenseSnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'expense': data['expense']?.toDouble() ?? 0.0,
          'date': data['date'] ?? '',
        };
      }).toList();

      // Fetch transactions (riwayat)
      final transactionSnapshot = await userDoc
          .collection('transactions')
          .where('type', isEqualTo: 'expense') // Filter untuk expense saja
          .orderBy('date', descending: true)
          .get();
      final transactionData = transactionSnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'description': data['description'] ?? '',
          'amount': data['amount'] ?? 0,
          'date': data['date'] ?? '',
        };
      }).toList();

      final amounts = expenseData.map((e) => e['expense'] as double).toList();
      final dates = expenseData.map((e) => e['date'] as String).toList();

      setState(() {
        dailyData = amounts;
        dailyDates = dates;
        transactions = transactionData;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching expense data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Expense',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Tombol navigasi ke halaman lain
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ExpensePage()),
                            );
                          },
                          child: const Text('Go to Expense'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const IncomePage()),
                            );
                          },
                          child: const Text('Go to Income'),
                        ),
                      ],
                    ),
                  ),
                  // Grafik bagian atas
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    height: 250,
                    child: dailyData.isNotEmpty
                        ? LineChart(
                            LineChartData(
                              lineBarsData: [
                                LineChartBarData(
                                  isCurved: true,
                                  spots: dailyData
                                      .asMap()
                                      .entries
                                      .map((entry) => FlSpot(
                                          entry.key.toDouble(), entry.value))
                                      .toList(),
                                  barWidth: 4,
                                  isStrokeCapRound: true,
                                  color: Colors.blue,
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: Colors.blue.withOpacity(0.3),
                                  ),
                                ),
                              ],
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 50,
                                    getTitlesWidget: (value, _) {
                                      return Text(
                                        value.toInt().toString(),
                                        style: const TextStyle(fontSize: 12),
                                      );
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, _) {
                                      if (dailyDates.isNotEmpty &&
                                          value.toInt() < dailyDates.length) {
                                        return Text(
                                          dailyDates[value.toInt()],
                                          style: const TextStyle(fontSize: 10),
                                        );
                                      }
                                      return const Text('');
                                    },
                                  ),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: FlGridData(show: true),
                            ),
                          )
                        : const Center(child: Text('No data available')),
                  ),
                  const Divider(),
                  // Riwayat transaksi bagian bawah
                  Expanded(
                    child: ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        return ListTile(
                          leading: const Icon(Icons.attach_money),
                          title: Text('${transaction['description']}'),
                          subtitle: Text('Date: ${transaction['date']}'),
                          trailing: Text('Rp${transaction['amount']}'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
