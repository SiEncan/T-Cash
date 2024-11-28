import 'package:fintar/screen/Transaction/transaction_screen.dart';
import 'package:fintar/screen/auth/passcode_create.dart';
import 'package:fintar/screen/profile/profile.dart';
import 'package:fintar/screen/qr/qrScanner.dart';
import 'package:fintar/screen/history/history_page.dart';
import 'package:fintar/services/passcode_checker.dart';
import 'package:fintar/widgets/custom_page_transition.dart';
import 'package:flutter/material.dart';
import 'package:fintar/screen/home/home_tab.dart';

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
    HistoryPage(),
    const Center(
        child:
            Text('SIZE BOX', style: TextStyle(fontSize: 24))), // INACCESSIBLE
    const TransactionScreen(),
    const Profile(),
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final passcodeChecker = PasscodeChecker();
      bool isPasscodeExist = await passcodeChecker.checkIfPasscodeExists();
      if (!isPasscodeExist) {
        Navigator.of(context).push(createRoute(CreatePasscode(), 0, 1));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          _pages[_selectedIndex],
          Positioned(
            bottom: 45,
            left: MediaQuery.of(context).size.width * 0.5 - 40,
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QRScanner()),
                    );
                  },
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
        ],
      ),
      bottomNavigationBar: ClipPath(
        clipper: _NavigationBarClipper(),
        child: Container(
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
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(30),
      ),
    );

    path.addOval(
      Rect.fromCircle(
        center: Offset(size.width * 0.5, 15),
        radius: 45,
      ),
    );

    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
