import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintar/screen/auth/set_new_passcode.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:simple_numpad/simple_numpad.dart';
import 'package:fintar/widgets/custom_dialog.dart';

class EnterCurrentPasscode extends StatefulWidget {
  final String userId;

  const EnterCurrentPasscode({super.key, required this.userId});

  @override
  _EnterCurrentPasscodeState createState() => _EnterCurrentPasscodeState();
}

class _EnterCurrentPasscodeState extends State<EnterCurrentPasscode> {
  final int _pinLength = 6;
  final TextEditingController _currentPasscodeController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Enter Current Passcode",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Please enter your current passcode to continue.',
                style: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(221, 20, 20, 20),
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              const Text(
                'Current Passcode',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black38,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              PinCodeTextField(
                controller: _currentPasscodeController,
                appContext: context,
                length: _pinLength,
                obscureText: true,
                keyboardType: TextInputType.none,
                showCursor: false,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 60,
                  fieldWidth: 50,
                  activeColor: Colors.grey,
                  inactiveColor: Colors.grey.shade300,
                  selectedColor: Colors.blue,
                ),
                onChanged: (value) {
                  // Prevent user from entering more than 6 digits
                  if (value.length > _pinLength) {
                    _currentPasscodeController.text =
                        value.substring(0, _pinLength);
                  }
                },
                onCompleted: (value) async {
                  await _validateCurrentPasscode(value);
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: SimpleNumpad(
                  buttonWidth: 90,
                  buttonHeight: 90,
                  gridSpacing: 10,
                  buttonBorderRadius: 50,
                  buttonBorderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 2.5,
                  ),
                  foregroundColor: Colors.black,
                  backgroundColor: const Color.fromARGB(45, 255, 255, 255),
                  textStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  useBackspace: true,
                  optionText: 'Clear',
                  onPressed: (str) {
                    switch (str) {
                      case 'BACKSPACE':
                        if (_currentPasscodeController.text.isNotEmpty) {
                          _currentPasscodeController.text =
                              _currentPasscodeController.text.substring(0,
                                  _currentPasscodeController.text.length - 1);
                        }
                        break;
                      case 'Clear':
                        _currentPasscodeController.text = '';
                        break;
                      default:
                        if (_currentPasscodeController.text.length <
                            _pinLength) {
                          _currentPasscodeController.text += str;
                        }
                        break;
                    }
                  },
                ),
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    String currentPasscode = _currentPasscodeController.text;
                    await _validateCurrentPasscode(currentPasscode);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 110, vertical: 15),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Validate the current passcode entered by the user
  Future<void> _validateCurrentPasscode(String enteredPasscode) async {
    // Fetch the current passcode from Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();

    String currentPasscode =
        userDoc['passcode']; // Assuming the passcode is stored as 'passcode'

    if (enteredPasscode != currentPasscode) {
      showCustomDialog(
        context: context,
        imagePath: 'img/failed.png',
        message: 'The current passcode is incorrect.',
        height: 100,
        buttonColor: Colors.red,
      );
    } else {
      // If correct, navigate to the second page to set a new passcode
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SetNewPasscode(userId: widget.userId),
        ),
      );
    }
  }
}
