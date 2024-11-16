import 'package:cloud_firestore/cloud_firestore.dart';

class SaldoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //  mengurangi saldo
  Future<bool> reduceSaldo(String userId, int amount) async {
    final userDoc = _firestore.collection('users').doc(userId);

    try {
      // saldo pengguna saat ini
      final docSnapshot = await userDoc.get();
      if (docSnapshot.exists) {
        int currentSaldo = docSnapshot['saldo'];

        if (currentSaldo >= amount) {
          // Mengurangi saldo jika cukup
          int newSaldo = currentSaldo - amount;

          // Update saldo di Firestore
          await userDoc.update({'saldo': newSaldo});
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // menambah saldo
  Future<bool> addSaldo(String userId, int amount) async {
    final userDoc = _firestore.collection('users').doc(userId);

    try {
      // saldo pengguna saat ini
      final docSnapshot = await userDoc.get();
      if (docSnapshot.exists) {
        int currentSaldo = docSnapshot['saldo'];

        // Menambah saldo
        int newSaldo = currentSaldo + amount;

        // Update saldo di Firestore
        await userDoc.update({'saldo': newSaldo});
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
