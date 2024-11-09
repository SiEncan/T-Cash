import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  static const Color primaryColor = Color(0xFF1A87DD);
  static const double horizontalPadding = 30.0;
  static const double buttonHeight = 52.0;

  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Screen Size
    final size = MediaQuery.of(context).size;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('img/welcomescreen.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // responsive untuk spacing
              SizedBox(height: size.height * 0.75), // 75% dari tinggi layar
              Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  10,
                  horizontalPadding,
                  bottomPadding + 20, //padding bottom sesuai device
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCreateAccountButton(size),
                    SizedBox(
                        height: size.height * 0.015), // 1.5% dari tinggi layar
                    _buildLoginButton(size),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateAccountButton(Size size) {
    return SizedBox(
      width: size.width - (horizontalPadding * 2),
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          'Create new account',
          style: TextStyle(
            fontSize: size.width * 0.04, // Responsive font size
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(Size size) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        minimumSize: Size(size.width - (horizontalPadding * 2), buttonHeight),
      ),
      child: Text(
        'Already have account?',
        style: TextStyle(
          fontSize: size.width * 0.04, // Responsive font size
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
