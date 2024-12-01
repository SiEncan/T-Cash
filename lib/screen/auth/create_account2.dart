import 'package:fintar/screen/auth/login.dart';
import 'package:fintar/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class CreateAccountPage2 extends StatefulWidget {
  final String email;
  final String password;

  const CreateAccountPage2(
      {super.key, required this.email, required this.password});

  @override
  State<CreateAccountPage2> createState() => _CreateAccountPage2State();
}

class _CreateAccountPage2State extends State<CreateAccountPage2> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Ukuran layar
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Input Nama Lengkap
            TextField(
              maxLength: 30,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
              ],
              buildCounter: (_,
                  {required currentLength, maxLength, required isFocused}) {
                return null; // Hide character counter
              },
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                hintText: 'Enter your full name',
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
            const SizedBox(height: 20),

            // Input Alamat
            TextField(
              controller: addressController,
              maxLength: 30,
              buildCounter: (_,
                  {required currentLength, maxLength, required isFocused}) {
                return null; // Hide character counter
              },
              decoration: InputDecoration(
                labelText: 'Address',
                hintText: 'Enter your address',
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
            const SizedBox(height: 20),

            // Input Nomor Telepon
            TextField(
              maxLength: 13,
              buildCounter: (_,
                  {required currentLength, maxLength, required isFocused}) {
                return null; // Hide character counter
              },
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Enter your phone number',
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
            const SizedBox(height: 40),

            // Tombol Submit untuk menyelesaikan pendaftaran
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.02,
                  horizontal: size.width * 0.1,
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                // Validasi input
                if (nameController.text.isEmpty ||
                    addressController.text.isEmpty ||
                    phoneNumberController.text.isEmpty) {
                  showCustomDialog(
                    context: context,
                    imagePath: 'img/form_failed.png',
                    message: 'Please fill all fields above',
                    height: 100,
                    buttonColor: Colors.red,
                  );
                  return;
                }

                // Mengecek apakah nomor telepon sudah terdaftar
                String phone = phoneNumberController.text;

                // Mengambil data dari Firestore untuk memeriksa apakah ada dokumen dengan nomor telepon tersebut
                QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                    .collection('users')
                    .where('phone', isEqualTo: phone)
                    .get();

                if (querySnapshot.docs.isNotEmpty) {
                  // Jika ada dokumen yang ditemukan, artinya nomor telepon sudah terdaftar
                  showCustomDialog(
                    context: context,
                    imagePath: 'img/phone_failed.png',
                    message: 'Phone number already registered',
                    height: 100,
                    buttonColor: Colors.red,
                  );
                  return;
                }

                // Buat akun Firebase menggunakan email dan password dari halaman pertama
                try {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: widget.email,
                    password: widget.password,
                  );

                  // Simpan data tambahan ke Firestore
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(userCredential.user!.uid)
                      .set({
                    'fullName': nameController.text,
                    'address': addressController.text,
                    'phone': phoneNumberController.text,
                    'email': widget.email,
                    'saldo': 0
                  });

                  // Logout pengguna setelah pembuatan akun
                  await FirebaseAuth.instance.signOut();

                  // Navigasi ke halaman utama setelah berhasil
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen(
                              showDialog: true,
                            )),
                    (Route<dynamic> route) =>
                        false, // Menghapus seluruh stack navigasi
                  );
                } on FirebaseAuthException catch (e) {
                  String errorMessage;

                  // Tampilkan pesan error yang lebih ramah berdasarkan kode error
                  switch (e.code) {
                    case 'email-already-in-use':
                      errorMessage = 'The email address is already registered.';
                      break;
                    case 'invalid-email':
                      errorMessage = 'The email address is invalid.';
                      break;
                    case 'weak-password':
                      errorMessage =
                          'The password is too weak. Please use a stronger password.';
                      break;
                    case 'operation-not-allowed':
                      errorMessage = 'Email/password accounts are not enabled.';
                      break;
                    default:
                      errorMessage =
                          'An unknown error occurred. Please try again later.';
                  }
                  showCustomDialog(
                    context: context,
                    imagePath: 'img/failed.png',
                    message: errorMessage,
                    height: 100,
                    buttonColor: Colors.red,
                  );
                } catch (e) {
                  // Tampilkan pesan error umum jika error bukan dari FirebaseAuth
                  showCustomDialog(
                    context: context,
                    imagePath: 'img/failed.png',
                    message: 'An error occurred. Please try again.',
                    height: 100,
                    buttonColor: Colors.red,
                  );
                }
              },
              child: Text(
                'Create Account',
                style: TextStyle(
                    fontSize: size.width * 0.045, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
