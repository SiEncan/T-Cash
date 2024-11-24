import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class IncomeExpensePage extends StatefulWidget {
  final int totalIncome;
  final int totalExpense;

  const IncomeExpensePage(
      {super.key, required this.totalIncome, required this.totalExpense});

  @override
  State<IncomeExpensePage> createState() => _IncomeExpensePageState();
}

class _IncomeExpensePageState extends State<IncomeExpensePage> {
  List<double> incomeData = [];
  List<double> expenseData = [];
  List<String> dailyDates = [];
  List<Map<String, dynamic>> transactions = [];
  bool isLoading = true;
  String currentView = 'Income';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  String _formatCurrency(num value) {
    return 'Rp${value.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  Future<void> _fetchData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userId = user.uid;
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);

      final incomeSnapshot = await userDoc
          .collection('transactionHistory')
          .where('type', whereIn: ['Top-Up', 'Transfer in'])
          .orderBy('date', descending: false)
          .get();

      final expenseSnapshot = await userDoc
          .collection('transactionHistory')
          .where('type', whereIn: ['Payment', 'Transfer out'])
          .orderBy('date', descending: false)
          .get();

      final Map<String, double> incomeGrouped = {};
      final Map<String, double> expenseGrouped = {};
      final List<Map<String, dynamic>> transactionData = [];

      for (var doc in incomeSnapshot.docs) {
        final data = doc.data();
        final timestamp = data['date'] as Timestamp?;
        final date = timestamp != null
            ? DateFormat('d MMM').format(timestamp.toDate())
            : '';
        final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;

        incomeGrouped[date] = (incomeGrouped[date] ?? 0.0) + amount;

        transactionData.add({
          'type': 'Income',
          'description':
              data['description'] != null && data['description'].isNotEmpty
                  ? 'Virtual Account Top-Up'
                  : 'Transfer by ${data['partyName']}',
          'amount': amount,
          'date': date,
        });
      }

      for (var doc in expenseSnapshot.docs) {
        final data = doc.data();
        final timestamp = data['date'] as Timestamp?;
        final date = timestamp != null
            ? DateFormat('d MMM').format(timestamp.toDate())
            : '';
        final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;

        expenseGrouped[date] = (expenseGrouped[date] ?? 0.0) + amount;

        transactionData.add({
          'type': 'Expense',
          'description':
              data['description'] != null && data['description'].isNotEmpty
                  ? data['description']
                  : 'Transfer to ${data['partyName']}',
          'amount': amount,
          'date': date,
        });
      }

      final allDates = {...incomeGrouped.keys, ...expenseGrouped.keys}.toList();
      allDates.sort((a, b) =>
          DateFormat('d MMM').parse(a).compareTo(DateFormat('d MMM').parse(b)));

      final List<double> incomes = [];
      final List<double> expenses = [];

      for (var date in allDates) {
        incomes.add(incomeGrouped[date] ?? 0.0);
        expenses.add(expenseGrouped[date] ?? 0.0);
      }

      setState(() {
        dailyDates = allDates;
        incomeData = incomes;
        expenseData = expenses;
        transactions = transactionData;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
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
          'Income & Expense',
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
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    height: 250,
                    child: dailyDates.isNotEmpty
                        ? LineChart(LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                isCurved: true,
                                preventCurveOverShooting: true,
                                spots:
                                    List.generate(incomeData.length, (index) {
                                  return FlSpot(
                                      index.toDouble(), incomeData[index]);
                                }),
                                barWidth: 4,
                                isStrokeCapRound: true,
                                color: Colors.blue,
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.blue.withOpacity(0.3),
                                      Colors.blue.withOpacity(0.0),
                                    ],
                                  ),
                                ),
                              ),
                              LineChartBarData(
                                isCurved: true,
                                preventCurveOverShooting: true,
                                spots:
                                    List.generate(expenseData.length, (index) {
                                  return FlSpot(
                                      index.toDouble(), expenseData[index]);
                                }),
                                barWidth: 4,
                                isStrokeCapRound: true,
                                color: Colors.orange,
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.orange.withOpacity(0.3),
                                      Colors.orange.withOpacity(0.0),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
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
                              rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                            ),
                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(
                              verticalInterval: 1,
                              show: true,
                              drawVerticalLine: true,
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                    color: Colors.grey.withOpacity(0.5),
                                    strokeWidth: 0.7);
                              },
                              getDrawingVerticalLine: (value) {
                                if (value.toInt() < dailyDates.length) {
                                  return FlLine(
                                    color: Colors.grey.withOpacity(0.5),
                                    strokeWidth: 0.7,
                                  );
                                }
                                return const FlLine(
                                  color: Colors.transparent,
                                );
                              },
                            ),
                          ))
                        : const Center(child: Text('No data available')),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentView = 'Income';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: currentView == 'Income'
                              ? Colors.blue
                              : Colors.grey,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.arrow_circle_down,
                                color: Colors.green),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Income',
                                  style: TextStyle(color: Colors.grey[300]),
                                ),
                                Text(
                                  _formatCurrency(widget.totalIncome),
                                  style: const TextStyle(color: Colors.white),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentView = 'Expense';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: currentView == 'Expense'
                              ? Colors.orange
                              : Colors.grey,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.arrow_circle_up,
                                color: Colors.red),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Expense',
                                  style: TextStyle(color: Colors.grey[300]),
                                ),
                                Text(
                                  _formatCurrency(widget.totalExpense),
                                  style: const TextStyle(color: Colors.white),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        itemCount: transactions
                            .where((transaction) =>
                                transaction['type'] == currentView)
                            .toList()
                            .length,
                        itemBuilder: (context, index) {
                          final filteredTransactions = transactions
                              .where((transaction) =>
                                  transaction['type'] == currentView)
                              .toList();
                          final transaction = filteredTransactions[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
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
                            child: ListTile(
                              leading: Icon(
                                Icons.attach_money,
                                color: currentView == 'Income'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              title: Text(
                                transaction['description'],
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text('Date: ${transaction['date']}'),
                              trailing: Text(
                                _formatCurrency(transaction['amount']),
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[900]),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
