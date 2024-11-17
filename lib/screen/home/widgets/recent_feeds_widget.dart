import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintar/screen/home/screens/pulsa_screen.dart';
import 'package:fintar/widgets/custom_page_transition.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fintar/services/auth_services.dart';

class RecentFeeds extends StatelessWidget {
  RecentFeeds({
    super.key,
  });
  final userId = AuthService().getUserId();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('transactionHistory')
          .orderBy('date', descending: true)
          .limit(3)
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

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
              child: Column(
                children: List.generate(transactions.length, (index) {
                  final transaction =
                      transactions[index].data() as Map<String, dynamic>;
                  final amount = (transaction['amount'] as double).toInt();
                  final date = (transaction['date'] as Timestamp).toDate();
                  final type = transaction['type'] as String;
                  final partyName = transaction['partyName'] as String?;
                  final description = transaction['description'] as String?;

                  final formattedDate = DateFormat('E, dd-MM').format(date);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.notifications_active,
                            size: 20, color: Colors.blue[400]),
                        const SizedBox(width: 8),
                        (type == "Transfer in")
                            ? Text(
                                partyName!,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w800),
                              )
                            : (type == "Transfer out")
                                ? Text(
                                    "You sent Rp$amount to ",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  )
                                : const Text(
                                    'You Just Bought ',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                        (type == "Transfer in")
                            ? Text(
                                " sent you Rp$amount",
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              )
                            : (type == "Transfer out")
                                ? Text(
                                    partyName!,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800),
                                  )
                                : Text(
                                    description!,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800),
                                  ),
                        const SizedBox(width: 4),
                        (type == "Transfer in")
                            ? Icon(Icons.south_outlined,
                                size: 20, color: Colors.green[400])
                            : (type == "Transfer out")
                                ? Icon(Icons.north,
                                    size: 20, color: Colors.red[300])
                                : Icon(Icons.shopping_bag_outlined,
                                    size: 20, color: Colors.blue[400]),
                        const Spacer(),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Text(
                  "Feeds",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(createRoute(const PulsaScreen(), 0, 1.0));
                  },
                  child: const Text(
                    "View All",
                    style: TextStyle(
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
