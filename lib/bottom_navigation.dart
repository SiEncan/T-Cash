import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Center(child: Text('Home Page', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Activity', style: TextStyle(fontSize: 24))),
    const Center(child: Text('QR', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Transaction', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Profile', style: TextStyle(fontSize: 24))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.home_outlined), label: 'Home'),
            NavigationDestination(
                icon: Icon(Icons.receipt_long_outlined), label: 'Activity'),
            NavigationDestination(
                icon: Icon(Icons.qr_code_scanner_rounded), label: 'QRIS'),
            NavigationDestination(
                icon: Icon(Icons.attach_money), label: 'Transaction'),
            NavigationDestination(
                icon: Icon(Icons.person_4_outlined), label: 'Profile'),
          ]),
    );
  }
}
