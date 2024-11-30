import 'package:fintar/screen/home/screens/steam/widget/steam_grid.dart';
import 'package:flutter/material.dart';

class SteamScreen extends StatefulWidget {
  const SteamScreen({Key? key}) : super(key: key);

  @override
  State<SteamScreen> createState() => _SteamScreenState();
}

class _SteamScreenState extends State<SteamScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Steam Funds',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
        elevation: 4.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Choose your Steam Funds below:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SteamGrid(),
            ),
          ],
        ),
      ),
    );
  }
}
