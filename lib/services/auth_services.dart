import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Mendapatkan userId dari Firebase
  String getUserId() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? 'unknown';
  }

  Future<String> getFullName() async {
    String userId = getUserId();

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return userDoc['fullName'] ?? 'No name available';
      } else {
        return 'User not found';
      }
    } catch (e) {
      return 'Error fetching name';
    }
  }
}
