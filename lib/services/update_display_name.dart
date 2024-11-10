import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> updateDisplayNameFromFirestore() async {
  User? user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
  String fullName = userDoc['fullName'] ?? '-';
  await user?.updateProfile(displayName: fullName);
}
