import 'package:fintar/services/auth_services.dart';
import 'package:fintar/widgets/custom_dialog.dart';
import 'package:fintar/widgets/transaction_details_modal.dart';
import 'package:flutter/material.dart';

class BottomSheetContent extends StatefulWidget {
  final String itemName;
  final int price;
  final IconData icon;

  const BottomSheetContent({
    super.key,
    required this.itemName,
    required this.price,
    required this.icon,
  });

  @override
  BottomSheetContentState createState() => BottomSheetContentState();
}

class BottomSheetContentState extends State<BottomSheetContent> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.itemName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _formatAmount(widget.price),
            style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _emailController,
            maxLength: 50,
            buildCounter: (_,
                {required currentLength, maxLength, required isFocused}) {
              return null; // Hide character counter
            },
            decoration: InputDecoration(
              hintText: 'Enter your ICloud E-Mail',
              prefixIcon: const Icon(
                Icons.email,
                color: Colors.black,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  width: 2,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                String email = _emailController.text.trim();
                if (email.isNotEmpty && email.contains('@')) {
                  Navigator.pop(context);

                  String customerName = await AuthService().getFullName();
                  TransactionDetailsModal(
                          customerName: customerName,
                          serviceName: widget.itemName,
                          icon: widget.icon,
                          recipientInfo: _emailController.text,
                          amount: widget.price)
                      .showCustomModal(context);
                } else {
                  showCustomDialog(
                    context: context,
                    imagePath: 'img/failed.png',
                    message: 'Please enter a valid email.',
                    height: 100,
                    buttonColor: Colors.red,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Proceed to Transaction',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(dynamic amount) {
    String text = amount is int ? amount.toString() : amount.toString();

    if (text.isEmpty) return '';
    final number = int.parse(text.replaceAll(RegExp(r'[^0-9]'), ''));

    return 'Rp${number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }
}
