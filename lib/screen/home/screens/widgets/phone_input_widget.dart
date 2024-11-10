import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneNumberInput extends StatefulWidget {
  final User user;
  final TextEditingController phoneNumberController;
  final TextEditingController nameController;

  const PhoneNumberInput({
    super.key,
    required this.user,
    required this.phoneNumberController,
    required this.nameController,
  });

  @override
  _PhoneNumberInputState createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  String currentPhoneNumber = '';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Phone Number',
            style: TextStyle(
              color: const Color(0xFF1A1A1A),
              fontSize: size.width * 0.03,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1.0,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.contacts_outlined,
                size: 24,
                color: Colors.black54,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where('phone',
                              isEqualTo: widget.phoneNumberController.text)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }

                        var userDoc = snapshot.data!.docs.isNotEmpty
                            ? snapshot.data!.docs.first
                            : null;

                        if (widget.phoneNumberController.text == '') {
                          String? displayName = widget.user.displayName;
                          return Text(
                            '$displayName',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }
                        if (userDoc == null) {
                          return Text(
                            'User not found',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        }

                        var nama = userDoc['fullName'] ?? 'Unknown';
                        widget.nameController.text = nama;
                        return TextField(
                          readOnly: true,
                          controller: widget.nameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                            hintStyle: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 16,
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.user.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        if (snapshot.hasError) {
                          return const Text("Error loading phone number.");
                        }

                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return const Text("User data not found.");
                        }

                        String phone = snapshot.data!['phone'] ?? '';
                        if (currentPhoneNumber != phone) {
                          currentPhoneNumber = phone;
                          widget.phoneNumberController.text = phone;
                        }

                        return TextField(
                          controller: widget.phoneNumberController,
                          decoration: InputDecoration(
                            hintText: '08*********',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          onEditingComplete: () {
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
