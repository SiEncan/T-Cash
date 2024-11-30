import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

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
  PhoneNumberInputState createState() => PhoneNumberInputState();
}

class PhoneNumberInputState extends State<PhoneNumberInput> {
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
                          return const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          );
                        }

                        var userDoc = snapshot.data!.docs.isNotEmpty
                            ? snapshot.data!.docs.first
                            : null;

                        String displayName;

                        if (widget.phoneNumberController.text.isEmpty &&
                            widget.nameController.text.isEmpty) {
                          displayName = widget.user.displayName ?? '';
                          widget.nameController.text = displayName;
                          widget.onNameChanged(widget.nameController.text);
                        } else if (userDoc == null) {
                          displayName = 'Unknown';
                        } else {
                          displayName = userDoc['fullName'] ?? 'Unknown';

                          if (currentName != displayName) {
                            currentName = displayName;
                            widget.nameController.text = displayName;
                            widget.onNameChanged(displayName);
                          }
                        }

                        if (displayName == 'Unknown' &&
                            currentName != displayName) {
                          currentName = displayName;
                          widget.nameController.text = displayName;
                          widget.onNameChanged(displayName);
                        }

                        return Text(
                          displayName,
                          style: TextStyle(
                            fontSize: 16,
                            color: displayName == 'Unknown'
                                ? Colors.grey[500]
                                : Colors.grey[800],
                            fontWeight: displayName == 'Unknown'
                                ? FontWeight.w400
                                : FontWeight.w500,
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
                          return const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          );
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
                          maxLength: 13,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          buildCounter: (_,
                              {required currentLength,
                              maxLength,
                              required isFocused}) {
                            return null; // Hide character counter
                          },
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
