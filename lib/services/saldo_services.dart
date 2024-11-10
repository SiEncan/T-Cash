import 'package:cloud_firestore/cloud_firestore.dart';

class SaldoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //  mengurangi saldo
  Future<void> reduceSaldo(String userId, int amount) async {
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
          print('Saldo berhasil diupdate');
        } else {
          print('Saldo ga cukup');
        }
      } else {
        print('Pengguna tidak ditemukan');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
  }

  // menambah saldo
  Future<void> addSaldo(String userId, int amount) async {
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
        print('Saldo berhasil diupdate');
      } else {
        print('Pengguna tidak ditemukan');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
  }
}
