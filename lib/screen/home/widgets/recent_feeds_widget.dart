import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintar/screen/activity/activity_tab.dart';
import 'package:fintar/widgets/custom_page_transition.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fintar/services/auth_services.dart';

class RecentFeeds extends StatelessWidget {
  RecentFeeds({
    super.key,
  });
  final userId = AuthService().getUserId();

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
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                children: List.generate(transactions.length, (index) {
                  final transaction =
                      transactions[index].data() as Map<String, dynamic>;
                  final amount = transaction['amount'] as int;
                  final date = (transaction['date'] as Timestamp).toDate();
                  final type = transaction['type'] as String;
                  final partyName = transaction['partyName'] as String?;
                  final description = transaction['description'] as String?;

                  final formattedDate = DateFormat('E, dd-MM').format(date);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.notifications_active,
                            size: 20, color: Colors.blue[400]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                  child: (type == "Transfer in")
                                      ? Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "$partyName ",
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                              const TextSpan(
                                                text: "sent you ",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              TextSpan(
                                                text: _formatAmount(amount),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.green[800]),
                                              ),
                                            ],
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        )
                                      : (type == "Transfer out")
                                          ? Text.rich(
                                              TextSpan(
                                                children: [
                                                  const TextSpan(
                                                    text: "You sent ",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  TextSpan(
                                                    text: _formatAmount(amount),
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.red[800]),
                                                  ),
                                                  const TextSpan(
                                                    text: " to ",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  TextSpan(
                                                    text: partyName,
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                ],
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            )
                                          : (type == "Payment")
                                              ? Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                        text:
                                                            "You just bought ",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      TextSpan(
                                                        text: description,
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800),
                                                      ),
                                                    ],
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                )
                                              : (type == "Top-Up")
                                                  ? Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          const TextSpan(
                                                            text:
                                                                "You just Topped-Up ",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                          TextSpan(
                                                            text: _formatAmount(
                                                                amount),
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color: Colors
                                                                        .green[
                                                                    800]),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                " via $description",
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ],
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    )
                                                  : const Text(
                                                      "No valid action",
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    )),
                            ],
                          ),
                        ),
                        (type == "Transfer in")
                            ? Icon(Icons.south_outlined,
                                size: 20, color: Colors.green[400])
                            : (type == "Transfer out")
                                ? Icon(Icons.north,
                                    size: 20, color: Colors.red[300])
                                : (type == "Payment")
                                    ? Icon(Icons.shopping_cart,
                                        size: 20, color: Colors.blue[400])
                                    : (type == "Top-Up")
                                        ? Icon(Icons.account_balance,
                                            size: 20, color: Colors.blue[400])
                                        : const Icon(Icons.error_outline),
                        const SizedBox(width: 8),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
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
                        .push(createRoute(const ActivityTab(), 0, 1.0));
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
