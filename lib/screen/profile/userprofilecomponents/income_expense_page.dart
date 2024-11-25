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
  int daysInMonth = 0;

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

  int getDaysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
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
      final endOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 31);

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
        daysInMonth = getDaysInMonth(selectedMonth);
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

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
        backgroundColor: const Color.fromARGB(255, 16, 138, 238),
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
              // margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child: Column(
                children: [
                  // Graph
                  Stack(
                    children: [
                      Container(
                          width: double.infinity,
                          height: 250,
                          color: const Color.fromARGB(255, 16, 138, 238)),
                      SizedBox(
                          height: 250,
                          child: dailyDates.isNotEmpty
                              ? SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    width: 31 *
                                        80, // Lebar sesuai 31 hari (30 piksel per hari)
                                    child: LineChart(
                                      LineChartData(
                                        backgroundColor: const Color.fromARGB(
                                            255, 16, 138, 238),
                                        lineTouchData: LineTouchData(
                                            touchTooltipData:
                                                LineTouchTooltipData(
                                                    getTooltipColor:
                                                        (LineBarSpot spot) {
                                                      return Colors.white
                                                          .withOpacity(0.8);
                                                    },
                                                    getTooltipItems:
                                                        (touchedSpots) {
                                                      return touchedSpots
                                                          .map((spot) {
                                                        final bool isIncome =
                                                            spot.barIndex == 0;
                                                        final String currency =
                                                            _formatCurrency(
                                                                spot.y as num);

                                                        final String arrowIcon =
                                                            isIncome
                                                                ? '↓ '
                                                                : '↑ ';
                                                        final Color?
                                                            arrowColor =
                                                            isIncome
                                                                ? Colors
                                                                    .green[500]
                                                                : Colors.orange[
                                                                    700];
                                                        return LineTooltipItem(
                                                          '',
                                                          const TextStyle(),
                                                          children: [
                                                            TextSpan(
                                                              text: arrowIcon,
                                                              style: TextStyle(
                                                                color:
                                                                    arrowColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: currency,
                                                              style: TextStyle(
                                                                color:
                                                                    arrowColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }).toList();
                                                    },
                                                    tooltipPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 12,
                                                            vertical: 4),
                                                    fitInsideVertically: true)),
                                        clipData: const FlClipData.none(),
                                        lineBarsData: [
                                          // Grafik untuk Income

                                          LineChartBarData(
                                            spots: List.generate(daysInMonth,
                                                (index) {
                                              // Periksa apakah tanggal (index + 1) ada di dailyDates
                                              double value = 0.0;
                                              int dateIndex =
                                                  dailyDates.indexWhere(
                                                (date) =>
                                                    int.parse(
                                                        date.split(' ')[0]) ==
                                                    (index + 1),
                                              );
                                              if (dateIndex != -1) {
                                                value = incomeData[dateIndex];
                                              }
                                              return FlSpot(
                                                  index.toDouble(), value);
                                            }),
                                            barWidth: 3,
                                            dotData: FlDotData(
                                              getDotPainter: (spot, percent,
                                                      barData, index) =>
                                                  FlDotCirclePainter(
                                                radius: 2,
                                                strokeWidth: 2,
                                                color: const Color.fromARGB(
                                                    255, 16, 138, 238),
                                                strokeColor: Colors.green,
                                              ),
                                            ),
                                            isStrokeCapRound: true,
                                            color: Colors.green,
                                            belowBarData: BarAreaData(
                                              show: true,
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.green.withOpacity(0.5),
                                                  Colors.green.withOpacity(0),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Grafik untuk Expense
                                          LineChartBarData(
                                            spots: List.generate(daysInMonth,
                                                (index) {
                                              // Periksa apakah tanggal (index + 1) ada di dailyDates
                                              double value = 0.0;
                                              int dateIndex =
                                                  dailyDates.indexWhere(
                                                (date) =>
                                                    int.parse(
                                                        date.split(' ')[0]) ==
                                                    (index + 1),
                                              );
                                              if (dateIndex != -1) {
                                                value = expenseData[dateIndex];
                                              }
                                              return FlSpot(
                                                  index.toDouble(), value);
                                            }),
                                            barWidth: 3,
                                            dotData: FlDotData(
                                              getDotPainter: (spot, percent,
                                                      barData, index) =>
                                                  FlDotCirclePainter(
                                                radius: 2,
                                                strokeWidth: 2,
                                                color: const Color.fromARGB(
                                                    255, 16, 138, 238),
                                                strokeColor: Colors.orange,
                                              ),
                                            ),
                                            isStrokeCapRound: true,
                                            color: Colors.orange,
                                            belowBarData: BarAreaData(
                                              show: true,
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.orange
                                                      .withOpacity(0.5),
                                                  Colors.orange.withOpacity(0),
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
                                                    return Transform.translate(
                                                      offset: const Offset(0,
                                                          8), // Menggeser teks ke bawah
                                                      child: Text(
                                                        (value.toInt() + 1)
                                                            .toString(), // Menampilkan tanggal 1-31
                                                        style: const TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  return const Text('');
                                                },
                                                reservedSize: 30),
                                          ),
                                          leftTitles: const AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: true,
                                                  interval: 999999999999999,
                                                  reservedSize: 200,
                                                  minIncluded: false,
                                                  maxIncluded: false)),
                                          rightTitles: const AxisTitles(
                                            sideTitles: SideTitles(
                                                reservedSize: 200,
                                                showTitles: true,
                                                minIncluded: false,
                                                maxIncluded: false,
                                                interval:
                                                    99999999999999), // agar tidak akan pernah muncul
                                          ),
                                          topTitles: const AxisTitles(
                                            sideTitles: SideTitles(
                                                minIncluded: false,
                                                maxIncluded: false,
                                                interval:
                                                    33, // agar tidak akan pernah muncul
                                                showTitles: true,
                                                reservedSize: 10),
                                          ),
                                        ),
                                        borderData: FlBorderData(show: false),
                                        gridData: FlGridData(
                                          show: false,
                                          drawVerticalLine: false,
                                          getDrawingHorizontalLine: (value) {
                                            return FlLine(
                                              color:
                                                  Colors.white.withOpacity(0.5),
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
                                    width: 31 * 80,
                                    child: LineChart(
                                      LineChartData(
                                        backgroundColor: const Color.fromARGB(
                                            255, 16, 138, 238),
                                        lineTouchData: LineTouchData(
                                            touchTooltipData:
                                                LineTouchTooltipData(
                                                    getTooltipColor:
                                                        (LineBarSpot spot) {
                                                      return Colors.white
                                                          .withOpacity(0.8);
                                                    },
                                                    getTooltipItems:
                                                        (touchedSpots) {
                                                      return touchedSpots
                                                          .map((spot) {
                                                        final bool isIncome =
                                                            spot.barIndex == 0;
                                                        final String currency =
                                                            _formatCurrency(
                                                                spot.y as num);

                                                        final String arrowIcon =
                                                            isIncome
                                                                ? '↓ '
                                                                : '↑ ';
                                                        final Color?
                                                            arrowColor =
                                                            isIncome
                                                                ? Colors
                                                                    .green[500]
                                                                : Colors.orange[
                                                                    700];
                                                        return LineTooltipItem(
                                                          '',
                                                          const TextStyle(),
                                                          children: [
                                                            TextSpan(
                                                              text: arrowIcon,
                                                              style: TextStyle(
                                                                color:
                                                                    arrowColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: currency,
                                                              style: TextStyle(
                                                                color:
                                                                    arrowColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }).toList();
                                                    },
                                                    tooltipPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 12,
                                                            vertical: 4),
                                                    fitInsideVertically: true)),
                                        clipData: const FlClipData.none(),
                                        lineBarsData: [
                                          // Grafik untuk Income
                                          LineChartBarData(
                                            spots: List.generate(daysInMonth,
                                                (index) {
                                              double value = 0.0;
                                              return FlSpot(
                                                  index.toDouble(), value);
                                            }),
                                            barWidth: 3,
                                            dotData: FlDotData(
                                              getDotPainter: (spot, percent,
                                                      barData, index) =>
                                                  FlDotCirclePainter(
                                                radius: 2,
                                                strokeWidth: 2,
                                                color: Colors.blue,
                                                strokeColor: Colors.green,
                                              ),
                                            ),
                                            isStrokeCapRound: true,
                                            color: Colors.green,
                                            belowBarData: BarAreaData(
                                              show: true,
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.green.withOpacity(0.5),
                                                  Colors.green.withOpacity(0),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Grafik untuk Expense
                                          LineChartBarData(
                                            spots: List.generate(daysInMonth,
                                                (index) {
                                              double value = 0.0;
                                              return FlSpot(
                                                  index.toDouble(), value);
                                            }),
                                            barWidth: 3,
                                            dotData: FlDotData(
                                              getDotPainter: (spot, percent,
                                                      barData, index) =>
                                                  FlDotCirclePainter(
                                                radius: 2,
                                                strokeWidth: 2,
                                                color: Colors.blue,
                                                strokeColor: Colors.orange,
                                              ),
                                            ),
                                            isStrokeCapRound: true,
                                            color: Colors.orange,
                                            belowBarData: BarAreaData(
                                              show: true,
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.orange
                                                      .withOpacity(0.5),
                                                  Colors.orange.withOpacity(0),
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
                                                // Hanya menampilkan tanggal 1 sampai jumlah hari yang sesuai
                                                if (value.toInt() <
                                                    daysInMonth) {
                                                  return Text(
                                                    (value.toInt() + 1)
                                                        .toString(), // Menampilkan tanggal 1-31
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.white),
                                                  );
                                                }
                                                return const Text('');
                                              },
                                            ),
                                          ),
                                          leftTitles: const AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: true,
                                                  reservedSize: 200,
                                                  minIncluded: false,
                                                  maxIncluded: false)),
                                          rightTitles: const AxisTitles(
                                            sideTitles: SideTitles(
                                                reservedSize: 200,
                                                showTitles: true,
                                                minIncluded: false,
                                                maxIncluded: false),
                                          ),
                                          topTitles: const AxisTitles(
                                            sideTitles: SideTitles(
                                                minIncluded: false,
                                                maxIncluded: false,
                                                showTitles: true,
                                                reservedSize: 10),
                                          ),
                                        ),
                                        borderData: FlBorderData(show: false),
                                        gridData: const FlGridData(
                                          show: false,
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                      const IgnorePointer(child: HorizontalLinesWidget())
                    ],
                  ),
                  const SizedBox(height: 8),
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

class HorizontalLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..strokeWidth = 0.5;

    int lineCount = 7;

    double lineSpacing = size.height / (lineCount - 0.2);

    for (int i = 0; i < lineCount; i++) {
      double y = i * lineSpacing;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class HorizontalLinesWidget extends StatelessWidget {
  const HorizontalLinesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 250),
      painter: HorizontalLinesPainter(),
    );
  }
}
