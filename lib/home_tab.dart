import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(0),
              height: 100, // besar container biru atas
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 0, 124, 226),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.only(
                    top: 16.0), // jarak antara text dan atas layar
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(
                          16.0), //  jarak antara icon dan tepi container
                      child: Icon(
                        Icons.account_balance,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    Text(
                      'RP 37.450',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
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
