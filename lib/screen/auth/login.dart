import 'package:fintar/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/bottom_navigation.dart';
import 'create_account1.dart';

class LoginScreen extends StatefulWidget {
  final bool showDialog;
  const LoginScreen({super.key, this.showDialog = false});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true; // Variabel untuk mengatur visibilitas password
  bool _isLoading = false;

  static const Color primaryColor = Color(0xFF1A87DD); // biru

  @override
  void initState() {
    super.initState();
    if (widget.showDialog) {
      // Menampilkan dialog success jika showDialog bernilai true
      Future.delayed(const Duration(milliseconds: 500), () {
        showCustomDialog(
          context: context,
          imagePath: 'img/success.png',
          message: 'Account created successfully',
          height: 100,
          buttonColor: Colors.green,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // ukuran layar
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
                    'Login Here',
                    style: TextStyle(
                      fontSize: size.width * 0.075,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(2, 2),
                            blurRadius: 20),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * 0.6, // Tinggi Container
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
                  obscureText:
                      _obscurePassword, // Mengatur visibilitas password
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
                          _obscurePassword =
                              !_obscurePassword; // Toggle visibility
                        });
                      },
                    ),
                  ),
                  style: TextStyle(
                      color: Colors.black, fontSize: size.width * 0.04),
                ),

                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Logika tombol
                    },
                    child: Text(
                      'Forget Password?',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: size.width * 0.035,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 1),

                // Tombol Login
                ElevatedButton(
                  onPressed:
                      _isLoading ? null : _login, // Disable tombol jika loading
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(
                          fontSize: size.width * 0.045,
                          color: Colors.white,
                        ),
                      ),
                      // Tampilkan indikator loading jika _isLoading bernilai true
                      if (_isLoading) const SizedBox(width: 10),
                      if (_isLoading)
                        const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 5),

                // Tombol Create new account
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateAccountPage1()));
                  },
                  child: Text(
                    'Create new account',
                    style: TextStyle(
                      fontSize: size.width * 0.04,
                      color: primaryColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _login() async {
    // Menyembunyikan snackbar yang sedang tampil jika ada agar tidak menyebabkan notifikasi berlebihan
    ScaffoldMessenger.of(context).clearSnackBars();

    setState(() {
      _isLoading = true; // Tampilkan loading saat login mulai
    });

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        _isLoading = false;
      });

      showCustomDialog(
        context: context,
        imagePath: 'img/failed.png',
        message: 'Email dan password tidak boleh kosong!',
        height: 100,
        buttonColor: Colors.red,
      );

      return;
    }
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavigation()),
        (Route<dynamic> route) => false, // Menghapus seluruh stack navigasi
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'Wrong Password/Email';
          break;
        case 'user-not-found':
          errorMessage = 'User not found';
          break;
        case 'invalid-credential':
          errorMessage = 'Wrong Password/Email';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many attempts, please try again later';
          break;
        default:
          errorMessage = 'An unknown error occurred. Please try again later';
      }
      showCustomDialog(
        context: context,
        imagePath: 'img/failed.png',
        message: errorMessage,
        height: 100,
        buttonColor: Colors.red,
      );
    } catch (e) {
      showCustomDialog(
        context: context,
        imagePath: 'img/failed.png',
        message: e.toString(),
        height: 100,
        buttonColor: Colors.red,
      );
    } finally {
      setState(() {
        _isLoading = false; // Sembunyikan loading setelah proses selesai
      });
    }
  }
}
