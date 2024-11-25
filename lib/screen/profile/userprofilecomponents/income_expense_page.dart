import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class IncomeExpensePage extends StatefulWidget {
  const IncomeExpensePage({
    super.key,
  });

  @override
  State<IncomeExpensePage> createState() => _IncomeExpensePageState();
}

class _IncomeExpensePageState extends State<IncomeExpensePage> {
  List<double> incomeData = [];
  List<double> expenseData = [];
  List<String> dailyDates = [];
  List<Map<String, dynamic>> transactions = [];
  double totalIncomePerMonth = 0.0;
  double totalExpensePerMonth = 0.0;

  bool isLoading = true;
  String currentView = 'Income';
  DateTime selectedMonth = DateTime.now();

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

      // Format month for query
      final startOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
      final endOfMonth =
          DateTime(selectedMonth.year, selectedMonth.month + 1, 0);

      final incomeSnapshot = await userDoc
          .collection('transactionHistory')
          .where('type', whereIn: ['Top-Up', 'Transfer in'])
          .where('date', isGreaterThanOrEqualTo: startOfMonth)
          .where('date', isLessThanOrEqualTo: endOfMonth)
          .orderBy('date', descending: false)
          .get();

      final expenseSnapshot = await userDoc
          .collection('transactionHistory')
          .where('type', whereIn: ['Payment', 'Transfer out'])
          .where('date', isGreaterThanOrEqualTo: startOfMonth)
          .where('date', isLessThanOrEqualTo: endOfMonth)
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
              data['description'] ?? 'Transfer by ${data['partyName']}',
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
              data['description'] ?? 'Transfer to ${data['partyName']}',
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

      totalIncomePerMonth = 0.0;
      totalExpensePerMonth = 0.0;

      for (var date in allDates) {
        totalIncomePerMonth += incomeGrouped[date] ?? 0.0;
        totalExpensePerMonth += expenseGrouped[date] ?? 0.0;
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

  // Helper method to handle month navigation
  void _changeMonth(int increment) {
    setState(() {
      selectedMonth =
          DateTime(selectedMonth.year, selectedMonth.month + increment, 1);
      isLoading = true;
    });
    _fetchData();
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
              margin: const EdgeInsets.only(top: 62),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                children: [
                  // Graph
                  Container(
                    padding: const EdgeInsets.fromLTRB(8, 0, 32, 8),
                    height: 250,
                    child: dailyDates.isNotEmpty
                        ? SingleChildScrollView(
                            // Membuat chart bisa digeser secara horizontal
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: 31 *
                                  30.0, // Lebar sesuai dengan 31 hari (30 piksel per hari)
                              child: LineChart(
                                LineChartData(
                                  lineBarsData: [
                                    LineChartBarData(
                                      isCurved: true,
                                      preventCurveOverShooting: true,
                                      spots: List.generate(31, (index) {
                                        // Tampilkan tanggal 1-31
                                        double value = index < incomeData.length
                                            ? incomeData[index]
                                            : 0.0;
                                        return FlSpot(index.toDouble(), value);
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
                                      spots: List.generate(31, (index) {
                                        // Tampilkan tanggal 1-31
                                        double value =
                                            index < expenseData.length
                                                ? expenseData[index]
                                                : 0.0;
                                        return FlSpot(index.toDouble(), value);
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
                                          if (value.toInt() < 31) {
                                            return Text(
                                              (value.toInt() + 1)
                                                  .toString(), // Menampilkan tanggal 1-31
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            );
                                          }
                                          return const Text('');
                                        },
                                      ),
                                    ),
                                    rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  gridData: FlGridData(
                                    verticalInterval: 1,
                                    show: true,
                                    drawVerticalLine: true,
                                    getDrawingHorizontalLine: (value) {
                                      return FlLine(
                                        color: Colors.grey.withOpacity(0.5),
                                        strokeWidth: 0.7,
                                      );
                                    },
                                    getDrawingVerticalLine: (value) {
                                      return FlLine(
                                        color: Colors.grey.withOpacity(0.5),
                                        strokeWidth: 0.7,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: 31 * 30.0,
                              child: LineChart(
                                LineChartData(
                                  lineBarsData: [
                                    LineChartBarData(
                                      isCurved: true,
                                      preventCurveOverShooting: true,
                                      spots: List.generate(31, (index) {
                                        double value = 0.0;
                                        return FlSpot(index.toDouble(), value);
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
                                      spots: List.generate(31, (index) {
                                        double value = 0.0;
                                        return FlSpot(index.toDouble(), value);
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
                                          if (value.toInt() < 31) {
                                            return Text(
                                              (value.toInt() + 1).toString(),
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            );
                                          }
                                          return const Text('');
                                        },
                                      ),
                                    ),
                                    rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  gridData: FlGridData(
                                    verticalInterval: 1,
                                    show: true,
                                    drawVerticalLine: true,
                                    getDrawingHorizontalLine: (value) {
                                      return FlLine(
                                        color: Colors.grey.withOpacity(0.5),
                                        strokeWidth: 0.7,
                                      );
                                    },
                                    getDrawingVerticalLine: (value) {
                                      return FlLine(
                                        color: Colors.grey.withOpacity(0.5),
                                        strokeWidth: 0.7,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                  // Navigation for month change
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: GestureDetector(
                          onTap: () => _changeMonth(-1),
                          child: const Icon(Icons.chevron_left,
                              color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('MMMM yyyy').format(selectedMonth),
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: GestureDetector(
                          onTap: () => _changeMonth(1),
                          child: const Icon(Icons.chevron_right,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  // Income and Expense Toggle
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
                                  _formatCurrency(
                                      totalIncomePerMonth), // Ganti dengan totalIncomePerMonth
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
                                  _formatCurrency(
                                      totalExpensePerMonth), // Ganti dengan totalExpensePerMonth
                                  style: const TextStyle(color: Colors.white),
                                )
                              ],
                            ),
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
                              offset: Offset(0, 1)),
                        ],
                      ),
                      child: transactions
                              .where((transaction) =>
                                  transaction['type'] == currentView)
                              .toList()
                              .isEmpty // Cek apakah data kosong
                          ? Center(
                              child: Text(
                                'You Have No Transaction This Month', // jika kosong
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[600]),
                              ),
                            )
                          : ListView.builder(
                              itemCount: transactions
                                  .where((transaction) =>
                                      transaction['type'] == currentView)
                                  .toList()
                                  .length,
                              itemBuilder: (context, index) {
                                final filteredTransactions = transactions
                                    .where((transaction) =>
                                        transaction['type'] == currentView)
                                    .toList()
                                  ..sort((a, b) => DateFormat('d MMM')
                                      .parse(b['date'])
                                      .compareTo(DateFormat('d MMM')
                                          .parse(a['date'])));

                                final transaction = filteredTransactions[index];
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 2,
                                          offset: Offset(0, 1)),
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
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    subtitle:
                                        Text('Date: ${transaction['date']}'),
                                    trailing: Text(
                                      _formatCurrency(transaction['amount']),
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[900]),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
