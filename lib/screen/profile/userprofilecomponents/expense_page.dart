import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fintar/screen/profile/userprofilecomponents/income_page.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  // Dummy data for daily tracking
  final List<double> dailyData = [50, 100, 150, 80, 200, 120, 90];
  final List<Map<String, dynamic>> transactions = [
    {'date': '2024-11-15', 'amount': 50, 'description': 'Groceries'},
    {'date': '2024-11-15', 'amount': 20, 'description': 'Transport'},
    {'date': '2024-11-14', 'amount': 80, 'description': 'Dining'},
    {'date': '2024-11-13', 'amount': 100, 'description': 'Shopping'},
  ];

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
        body: Container(
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
                        // Arahkan ke halaman expense tracking (saat ini dummy)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ExpensePage()),
                        );
                      },
                      child: const Text('Go to Expense'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Arahkan ke halaman income tracking (saat ini dummy)
                        Navigator.push(
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
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        spots: dailyData
                            .asMap()
                            .entries
                            .map((entry) =>
                                FlSpot(entry.key.toDouble(), entry.value))
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
                            const days = [
                              'Mon',
                              'Tue',
                              'Wed',
                              'Thu',
                              'Fri',
                              'Sat',
                              'Sun'
                            ];
                            return Text(
                              days[value.toInt() % days.length],
                              style: const TextStyle(fontSize: 12),
                            );
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: false), // Matikan judul di sumbu kanan
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: false), // Matikan judul di sumbu atas
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: true),
                  ),
                ),
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
                      trailing: Text('\$${transaction['amount']}'),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
