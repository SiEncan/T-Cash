import 'package:flutter/material.dart';
import 'create_account2.dart';

class CreateAccountPage1 extends StatefulWidget {
  const CreateAccountPage1({super.key});

  @override
  _CreateAccountPage1State createState() => _CreateAccountPage1State();
}

class _CreateAccountPage1State extends State<CreateAccountPage1> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;

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
                    'Create Account',
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

                // Input Email
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email',
                    style: TextStyle(
                        color: const Color(0xFF1A1A1A),
                        fontSize: size.width *
                            0.045, // Menyesuaikan ukuran font dengan lebar layar
                        fontWeight: FontWeight.w400),
                  ),
                ),

                const SizedBox(height: 5),

                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(
                        color: const Color.fromARGB(77, 0, 0, 0),
                        fontWeight: FontWeight.w300,
                        fontSize: size.width *
                            0.035), // Menyesuaikan ukuran font hint
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

                // Input Password
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Password',
                    style: TextStyle(
                        color: const Color(0xFF1A1A1A),
                        fontSize: size.width * 0.045, // Responsif
                        fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(height: 5),

                TextField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(
                        color: const Color.fromARGB(77, 0, 0, 0),
                        fontWeight: FontWeight.w300,
                        fontSize:
                            size.width * 0.035), // Responsif untuk hint text
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black54),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  style: TextStyle(
                      color: Colors.black, fontSize: size.width * 0.04),
                ),

                const SizedBox(height: 24),

                // Input Confirm Password
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Confirm Password',
                    style: TextStyle(
                        color: const Color(0xFF1A1A1A),
                        fontSize: size.width * 0.045, // Responsif
                        fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(height: 5),

                TextField(
                  controller: confirmPasswordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Re-enter your password',
                    hintStyle: TextStyle(
                        color: const Color.fromARGB(77, 0, 0, 0),
                        fontWeight: FontWeight.w300,
                        fontSize:
                            size.width * 0.035), // Responsif untuk hint text
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
                  onPressed: () {
                    // Menyembunyikan snackbar yang sedang tampil jika ada agar tidak menyebabkan notifikasi berlebihan
                    ScaffoldMessenger.of(context).clearSnackBars();
                    if (passwordController.text !=
                        confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Passwords do not match')),
                      );
                    } else if (emailController.text.trim() == '' ||
                        passwordController.text.trim() == '' ||
                        confirmPasswordController.text.trim() == '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Please input all information above')),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateAccountPage2(
                                  email: emailController.text,
                                  password: passwordController.text,
                                )),
                      );
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
