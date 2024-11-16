import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintar/services/auth_services.dart';
import 'package:flutter/material.dart';

class PasscodeChecker {
  String userId = AuthService().getUserId();

  Future<bool> checkIfPasscodeExists() async {
    try {
      Map<String, dynamic>? userData = (await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get())
          .data();
      return userData != null && userData.containsKey('passcode');
    } catch (e) {
      return false;
    }
  }

  Future<bool> verifyPasscode(
      BuildContext context, String enteredPasscode) async {
    final passcodeRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    try {
      final docSnapshot = await passcodeRef.get();
      if (docSnapshot.exists) {
        final storedPasscode = docSnapshot.data()?['passcode'];
        return storedPasscode == enteredPasscode;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
