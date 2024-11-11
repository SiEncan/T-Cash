import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintar/screen/auth/login.dart';
import 'package:fintar/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreatePasscodePage extends StatefulWidget {
  const CreatePasscodePage({super.key, required this.userid});
  final String userid;

  @override
  _CreatePasscodePageState createState() => _CreatePasscodePageState();
}

class _CreatePasscodePageState extends State<CreatePasscodePage> {
  final passcodeController = TextEditingController();
  final confirmPasscodeController = TextEditingController();
  bool _obscurePasscode = true;

  static const Color primaryColor = Color(0xFF1A87DD);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bottomPadding =
        MediaQuery.of(context).padding.bottom; // Padding bawah untuk perangkat

    return Scaffold(
      backgroundColor: primaryColor,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.1),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'img/logo_transparent.png',
                    width: size.width * 0.4,
                  ),
                ),
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Create Passcode',
                    style: TextStyle(
                      fontSize: size.width * 0.075,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(2, 2),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * 0.6,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              bottomPadding + 20, // padding bawah sesuai perangkat
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 5),

                // Input Passcode
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Passcode',
                    style: TextStyle(
                        color: const Color(0xFF1A1A1A),
                        fontSize: size.width *
                            0.045, // Menyesuaikan ukuran font dengan lebar layar
                        fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: passcodeController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  obscureText: _obscurePasscode,
                  keyboardType: TextInputType.number,
                  maxLength: 6, // 6-digit passcode
                  decoration: InputDecoration(
                    hintText: 'Enter 6-digit passcode',
                    hintStyle: TextStyle(
                        color: const Color.fromARGB(77, 0, 0, 0),
                        fontWeight: FontWeight.w300,
                        fontSize: size.width * 0.035),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black54),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: size.width * 0.04), // Responsif untuk teks
                ),

                const SizedBox(height: 24),

                // Input Confirm Passcode
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Confirm Passcode',
                    style: TextStyle(
                        color: const Color(0xFF1A1A1A),
                        fontSize: size.width * 0.045, // Responsif
                        fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: confirmPasscodeController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  obscureText: _obscurePasscode,
                  keyboardType: TextInputType.number,
                  maxLength: 6, // 6-digit passcode
                  decoration: InputDecoration(
                    hintText: 'Re-enter your passcode',
                    hintStyle: TextStyle(
                        color: const Color.fromARGB(77, 0, 0, 0),
                        fontWeight: FontWeight.w300,
                        fontSize: size.width * 0.035),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black54),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const Spacer(flex: 1),

                // Tombol Next
                ElevatedButton(
                  onPressed: () async {
                    if (passcodeController.text !=
                        confirmPasscodeController.text) {
                      showCustomDialog(
                        context: context,
                        imagePath: 'img/failed.png',
                        message: 'Passcodes do not match',
                        height: 100,
                        buttonColor: Colors.red,
                      );
                    } else if (passcodeController.text.trim() == '' ||
                        confirmPasscodeController.text.trim() == '') {
                      showCustomDialog(
                        context: context,
                        imagePath: 'img/form_failed.png',
                        message: 'Please fill all fields above',
                        height: 100,
                        buttonColor: Colors.red,
                      );
                    } else {
                      int passcode = int.parse(passcodeController.text.trim());
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.userid)
                          .update({
                        'passcode': passcode,
                      });
                      // Navigasi ke halaman utama setelah berhasil
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen(
                                    showDialog: true,
                                  )));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.02,
                      horizontal: size.width * 0.1,
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(
                        fontSize: size.width * 0.045, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
