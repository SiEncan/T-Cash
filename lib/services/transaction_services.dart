import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveTransaction(String userId, int amount, String type,
      String description, String additionalInfo) async {
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
        'additionalInfo': additionalInfo,
      });
    } catch (e) {
      return;
    }
  }
}
