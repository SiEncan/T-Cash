import 'package:fintar/screen/home/screens/pulsa_screen.dart';
import 'package:fintar/widgets/custom_page_transition.dart';
import 'package:flutter/material.dart';

class RecentFeeds extends StatelessWidget {
  const RecentFeeds({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.notifications_active, size: 20, color: Colors.blue[400]),
            const SizedBox(width: 8),
            const Text(
              "Bastian",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
            ),
            const SizedBox(width: 4),
            const Text(
              "sent you Rp 25.000",
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(width: 6),
            Icon(Icons.send_and_archive_outlined,
                size: 20, color: Colors.blue[400]),
            const Spacer(),
            const Text(
              "28/10",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.notifications_active, size: 20, color: Colors.blue[400]),
            const SizedBox(width: 8),
            const Text(
              "Afzaal",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
            ),
            const SizedBox(width: 4),
            const Text(
              "sent you Rp 10.000",
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(width: 6),
            Icon(Icons.send_and_archive_outlined,
                size: 20, color: Colors.blue[400]),
            const Spacer(),
            const Text(
              "28/10",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Icon(Icons.notifications_active, size: 20, color: Colors.blue[400]),
            const SizedBox(width: 8),
            const Text(
              "T-Cash",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
            ),
            const SizedBox(width: 4),
            const Flexible(
              child: Text(
                "Enjoy your trip by using 20% OFF T-Cash Voucher",
                style: TextStyle(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.celebration, size: 20, color: Colors.blue[400]),
            const SizedBox(width: 6),
            const Text(
              "26/10",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              "Feeds",
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
        )
      ],
    );
  }
}
