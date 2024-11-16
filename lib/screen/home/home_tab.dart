import 'package:fintar/screen/home/widgets/purchase_widget.dart';
import 'package:fintar/screen/home/widgets/recent_feeds_widget.dart';
import 'package:flutter/material.dart';
import 'package:fintar/screen/home/widgets/top_balance_widget.dart';
import 'package:fintar/screen/home/widgets/carousel_widget.dart';
import 'package:fintar/screen/home/widgets/deals_widget.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Stack(
              children: [
                Stack(children: [
                  Container(
                      color: const Color.fromARGB(255, 25, 140, 235),
                      width: 500,
                      height: 220),
                  Positioned(
                    top: 62, // posisi dari atas
                    child: Image.asset(
                      'img/banners/ads.jpg',
                      width: 412,
                      height: 200,
                    ),
                  )
                ]),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 190), // Padding untuk konten di bawah container biru
                  child: Column(
                    children: [
                      // kumpulan icon fitur pembelian
                      const PurchaseMenu(),
                      // notif
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
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
                        // Preview Activity Feeds
                        child: RecentFeeds(),
                      ),
                      // Carousel Slider
                      const Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: CarouselWidget()),

                      // Deals and Discount section
                      const DealsAndDiscounts()
                    ],
                  ),
                ),
              ],
            ),
          ),
          const BalanceDisplayWidget()
        ],
      ),
    );
  }
}
