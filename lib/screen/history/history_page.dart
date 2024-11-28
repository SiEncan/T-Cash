import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: HistoryPage(),
    theme: ThemeData(
      primaryColor: Color.fromARGB(255, 36, 142, 255), // DANA Green color
    ),
  ));
}

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // Sample data
  final List<Transaction> transactions = [
    Transaction('Transfer', 'John Doe', 50000, '11 Nov 2024', 'Sent'),
    Transaction('Payment', 'Uber Eats', 12000, '10 Nov 2024', 'Paid'),
    Transaction('Top-up', 'DANA', 100000, '09 Nov 2024', 'Received'),
    Transaction('Purchase', 'Shopee', 25000, '08 Nov 2024', 'Paid'),
  ];

  String _selectedFilter = 'All'; // Default filter selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Balance Info

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
              items: <String>['All', 'Received', 'Sent', 'Paid']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              isExpanded: true,
            ),
          ),

          // Transaction List with Dividers
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                if (_selectedFilter != 'All' &&
                    transactions[index].status != _selectedFilter) {
                  return Container(); // Skip item if it doesn't match filter
                }

                // ListTile for each transaction
                return Column(
                  children: [
                    ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      leading: Icon(
                        Icons.payment,
                        color: transactions[index].status == 'Received'
                            ? Colors.green
                            : Colors.red,
                        size: 30, // Larger icon size for better visibility
                      ),
                      title: Text(
                        transactions[index].description,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        transactions[index].date,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      trailing: Text(
                        'Rp ${transactions[index].status == 'Sent' || transactions[index].status == 'Paid' ? '-' : ''}${transactions[index].amount}',
                        style: TextStyle(
                          color: transactions[index].status == 'Received'
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize:
                              22, // Increased font size for better readability
                        ),
                      ),
                    ),
                    // Divider to separate transactions
                    Divider(
                      color: Colors.grey[300],
                      thickness: 1.5,
                      indent: 16,
                      endIndent: 16,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter Transactions'),
          content: DropdownButton<String>(
            value: _selectedFilter,
            onChanged: (String? newValue) {
              setState(() {
                _selectedFilter = newValue!;
              });
              Navigator.of(context).pop();
            },
            items: <String>['All', 'Received', 'Sent', 'Paid']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        );
      },
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
