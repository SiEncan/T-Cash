import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: must_be_immutable
class PhoneNumberInput extends StatefulWidget {
  final User user;
  final TextEditingController phoneNumberController;
  final TextEditingController nameController;
  String selectedProviderParam;
  final Function(String) onProviderSelected;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onPhoneNumberChanged;

  PhoneNumberInput({
    super.key,
    required this.user,
    required this.phoneNumberController,
    required this.nameController,
    required this.selectedProviderParam,
    required this.onProviderSelected,
    required this.onNameChanged,
    required this.onPhoneNumberChanged,
  });

  @override
  _PhoneNumberInputState createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  String currentPhoneNumber = '';
  String currentName = '';
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
                Icons.contacts,
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

                        if (widget.phoneNumberController.text.isEmpty) {
                          String? displayName = widget.user.displayName;
                          widget.nameController.text = displayName ?? '';

                          widget.onNameChanged(widget.nameController.text);

                          return Text(
                            displayName ?? '',
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

                        var name = userDoc['fullName'] ?? 'Unknown';
                        if (currentName != name) {
                          currentName = name;
                          widget.nameController.text = name;
                          widget.onNameChanged(name);
                        }

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
                            setState(() {
                              widget.onPhoneNumberChanged(
                                  widget.phoneNumberController.text);
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: providerSelect(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  DropdownButtonHideUnderline providerSelect() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        menuWidth: 130,
        borderRadius: BorderRadius.circular(16),
        value: widget.selectedProviderParam, // selected value
        onChanged: (String? newValue) {
          setState(() {
            widget.selectedProviderParam = newValue!;
            widget.onProviderSelected(
                newValue); // oper ke parent screen ketika berubah
          });
        },
        items: <String>['IM3', 'Telkomsel', 'XL']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'img/$value.png',
                  width: 80,
                  height: 60,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
