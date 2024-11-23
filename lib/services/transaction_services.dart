import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveTransaction(
    String userId,
    String type, {
    int? amount,
    String? description,
    String? additionalInfo,
    String? note,
    String? partyName,
  }) async {
    try {
      Map<String, dynamic> transactionData = {
        'amount': amount,
        'date': Timestamp.now(),
        'type': type,
      };

      if (type == 'Transfer out' || type == 'Transfer in') {
        transactionData.addAll({
          'note': note,
          'partyName': partyName,
        });
      } else if (type == 'Payment') {
        transactionData.addAll({
          'description': description,
          'additionalInfo': additionalInfo,
        });
      }
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactionHistory')
          .add(transactionData);
    } catch (e) {
      print('Error saving transaction: $e');
    }
  }
}
