import 'package:fintar/screen/home/screens/applezone/applezone_screen.dart';
import 'package:fintar/screen/home/screens/pulsa/pulsa_screen.dart';
import 'package:flutter/material.dart';

class DealsAndDiscounts extends StatelessWidget {
  const DealsAndDiscounts({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Deals & Discounts',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 160.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.grey[200],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          'img/banners/byu.png',
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    const Text(
                      'Diskon Pulsa 20%',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Dapatkan diskon 20% untuk pembelian paket data by.U via aplikasi.',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Center(
                      child: Container(
                        width: 200,
                        height: 38,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              color: const Color.fromARGB(255, 31, 141, 231),
                              width: 1.0),
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(8.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8.0),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PulsaScreen()),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 38,
                              child: const Text(
                                'Buy Now',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 31, 141, 231),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 160.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.grey[200],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          'img/banners/icloud.png',
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    const Text(
                      'Diskon iCloud 50%',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Hemat 50% untuk berlangganan iCloud pertama kali.',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Center(
                      child: Container(
                        width: 200,
                        height: 38,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              color: const Color.fromARGB(255, 31, 141, 231),
                              width: 1.0),
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(8.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8.0),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AppleZoneScreen()),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 38,
                              child: const Text(
                                'Buy Now',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 31, 141, 231),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
