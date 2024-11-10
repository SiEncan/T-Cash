import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Mendapatkan userId dari Firebase
  String getUserId() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? 'unknown';
  }
}
