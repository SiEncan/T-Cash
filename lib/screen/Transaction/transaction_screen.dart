import 'package:flutter/material.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade700,
      body: SafeArea(
        child: Column(
          children: [
            // Header & Balance Section
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting & Mail Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Welcome Back!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Static Balance
                  Text(
                    "Rp 37.914",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Buttons Section
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick Actions Section
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      child: Text(
                        "Quick Actions",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ActionButton(
                          icon: Icons.qr_code_scanner,
                          label: "Scan",
                          backgroundColor: Colors.blue.shade50,
                          shadowColor: Colors.blue.shade200,
                          onTap: () {},
                        ),
                        ActionButton(
                          icon: Icons.add,
                          label: "Top Up",
                          backgroundColor: Colors.blue.shade50,
                          shadowColor: Colors.blue.shade200,
                          onTap: () {},
                        ),
                        ActionButton(
                          icon: Icons.send,
                          label: "Send",
                          backgroundColor: Colors.blue.shade50,
                          shadowColor: Colors.blue.shade200,
                          onTap: () {},
                        ),
                        ActionButton(
                          icon: Icons.request_page,
                          label: "Request",
                          backgroundColor: Colors.blue.shade50,
                          shadowColor: Colors.blue.shade200,
                          onTap: () {},
                        ),
                      ],
                    ),

                    // Recent Transactions Section
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Recent Transactions",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        children: [
                          TransactionItem(
                            title: "Top Up via Bank",
                            date: "27 Nov 2024",
                            amount: "+Rp 50.000",
                            amountColor: Colors.green.shade700,
                          ),
                          TransactionItem(
                            title: "Send Money",
                            date: "26 Nov 2024",
                            amount: "-Rp 20.000",
                            amountColor: Colors.red.shade700,
                          ),
                          TransactionItem(
                            title: "Received Payment",
                            date: "25 Nov 2024",
                            amount: "+Rp 100.000",
                            amountColor: Colors.green.shade700,
                          ),
                          TransactionItem(
                            title: "Purchased Item",
                            date: "24 Nov 2024",
                            amount: "-Rp 30.000",
                            amountColor: Colors.red.shade700,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color shadowColor;

  const ActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.backgroundColor,
    required this.shadowColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, size: 30, color: Colors.blue.shade700),
          ),
          SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String title;
  final String date;
  final String amount;
  final Color amountColor;

  const TransactionItem({
    Key? key,
    required this.title,
    required this.date,
    required this.amount,
    required this.amountColor,
  }) : super(key: key);

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
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
              SizedBox(height: 4),
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
