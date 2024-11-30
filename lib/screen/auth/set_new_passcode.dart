import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintar/widgets/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:simple_numpad/simple_numpad.dart';
import 'package:fintar/widgets/custom_dialog.dart';

class SetNewPasscode extends StatefulWidget {
  final String userId;

  const SetNewPasscode({super.key, required this.userId});

  @override
  _SetNewPasscodeState createState() => _SetNewPasscodeState();
}

class _SetNewPasscodeState extends State<SetNewPasscode> {
  final int _pinLength = 6;
  final TextEditingController _newPasscodeController = TextEditingController();
  final TextEditingController _confirmPasscodeController =
      TextEditingController();

  final FocusNode _newPasscodeFocusNode = FocusNode();
  final FocusNode _confirmPasscodeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).requestFocus(_newPasscodeFocusNode);
      }
    });
  }

  @override
  void dispose() {
    if (!mounted) {
      _newPasscodeFocusNode.dispose();
      _confirmPasscodeFocusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Set New Passcode",
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
                'Please enter and confirm your new passcode.',
                style: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(221, 20, 20, 20),
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              const Text(
                'New Passcode',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black38,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              PinCodeTextField(
                controller: _newPasscodeController,
                focusNode: _newPasscodeFocusNode,
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
                  if (value.length == _pinLength) {
                    FocusScope.of(context)
                        .requestFocus(_confirmPasscodeFocusNode);
                  }
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Confirm New Passcode',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black38,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              PinCodeTextField(
                controller: _confirmPasscodeController,
                focusNode: _confirmPasscodeFocusNode,
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
                onCompleted: _onContinue,
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
                        if (_newPasscodeFocusNode.hasFocus &&
                            _newPasscodeController.text.isNotEmpty) {
                          _newPasscodeController.text =
                              _newPasscodeController.text.substring(
                                  0, _newPasscodeController.text.length - 1);
                        } else if (_confirmPasscodeFocusNode.hasFocus &&
                            _confirmPasscodeController.text.isNotEmpty) {
                          _confirmPasscodeController.text =
                              _confirmPasscodeController.text.substring(0,
                                  _confirmPasscodeController.text.length - 1);
                        }
                        break;
                      case 'Clear':
                        if (_newPasscodeFocusNode.hasFocus) {
                          _newPasscodeController.text = '';
                        } else if (_confirmPasscodeFocusNode.hasFocus) {
                          _confirmPasscodeController.text = '';
                        }
                        break;
                      default:
                        if (_newPasscodeFocusNode.hasFocus &&
                            _newPasscodeController.text.length < _pinLength) {
                          _newPasscodeController.text += str;
                        } else if (_confirmPasscodeFocusNode.hasFocus &&
                            _confirmPasscodeController.text.length <
                                _pinLength) {
                          _confirmPasscodeController.text += str;
                        }
                        break;
                    }
                  },
                ),
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () => _onContinue(_newPasscodeController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 110, vertical: 15),
                  ),
                  child: const Text(
                    "Continue",
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

  void _onContinue(String value) async {
    String newPasscode = _newPasscodeController.text;
    String confirmPasscode = _confirmPasscodeController.text;

    if (newPasscode != confirmPasscode) {
      showCustomDialog(
        context: context,
        imagePath: 'img/failed.png',
        message: 'The passcodes do not match.',
        height: 100,
        buttonColor: Colors.red,
      );
      FocusScope.of(context).requestFocus(_confirmPasscodeFocusNode);
    } else if (newPasscode.length != _pinLength) {
      showCustomDialog(
        context: context,
        imagePath: 'img/failed.png',
        message: 'The passcode must be 6 characters long.',
        height: 100,
        buttonColor: Colors.red,
      );
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({
        'passcode': newPasscode,
      });

      showCustomDialog(
        context: context,
        imagePath: 'img/success.png',
        message: 'Passcode successfully changed.',
        height: 100,
        buttonColor: Colors.green,
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavigation()),
            (Route<dynamic> route) => false,
          );
        },
      );
    }
  }
}
