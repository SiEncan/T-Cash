import 'package:flutter/material.dart';
import 'package:fintar/screen/home/home_tab.dart';
import 'package:fintar/screen/auth/logout_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeTab(),
    const Center(child: Text('Activity', style: TextStyle(fontSize: 24))),
    const Center(
        child:
            Text('SIZE BOX', style: TextStyle(fontSize: 24))), // INACCESSIBLE
    const Center(child: Text('Transaction', style: TextStyle(fontSize: 24))),
    const logoutScreen(),
  ];

  void _onItemTapped(int index) {
    if (index != 2) {
      // menghindari akses index 2
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: SizedBox(
          width: 80,
          height: 80,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 36, 142, 255),
                  Color.fromARGB(255, 31, 135, 255),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: Colors.transparent,
              onPressed: () {},
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code_scanner_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                  SizedBox(height: 1),
                  Text(
                    "PAY",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(30), bottom: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: NavigationBar(
            height: 80,
            elevation: 0,
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            backgroundColor: Colors.transparent,
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.home_outlined), label: 'Home'),
              NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined), label: 'Activity'),
              SizedBox(width: 1),
              NavigationDestination(
                  icon: Icon(Icons.attach_money), label: 'Transaction'),
              NavigationDestination(
                  icon: Icon(Icons.person_4_outlined), label: 'Profile'),
            ]),
      ),
    );
  }
}
