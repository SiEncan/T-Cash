import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveTransaction(
      String userId, int amount, String type, String description) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactionHistory')
          .add({
        'amount': amount,
        'date': Timestamp.now(),
        'type': type,
        'description': description,
      });
    } catch (e) {
      print('Terjadi kesalahan saat menyimpan transaksi: $e');
    }
  }
}
