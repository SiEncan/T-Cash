import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintar/widgets/bottom_navigation.dart';
import 'package:fintar/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:simple_numpad/simple_numpad.dart';

class CreatePasscodeConfirm extends StatefulWidget {
  final String userId;
  final String passcode;

  const CreatePasscodeConfirm(
      {super.key, required this.userId, required this.passcode});
  @override
  CreatePasscodeConfirmState createState() => CreatePasscodeConfirmState();
}

class CreatePasscodeConfirmState extends State<CreatePasscodeConfirm> {
  bool _isNavigating = false;
  bool _dialogShown = false;
  final int _pinLength = 6;
  final TextEditingController _confirmationPinController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PIN Confirmation",
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'It looks like you haven\'t set your payment PIN yet.',
                style: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(221, 20, 20, 20),
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 16),
              const Text(
                'Create Payment PIN',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black38,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 5),
              PinCodeTextField(
                  controller: _confirmationPinController,
                  appContext: context,
                  autoFocus: true,
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
                      _confirmationPinController.text =
                          value.substring(0, _pinLength);
                    }
                  },
                  onCompleted: (value) async {
                    if (_dialogShown) return; // mencegah multiple dialog

                    if (value != widget.passcode) {
                      _dialogShown = true;
                      showCustomDialog(
                        context: context,
                        imagePath: 'img/failed.png',
                        message: 'Passcodes do not match',
                        height: 100,
                        buttonColor: Colors.red,
                      );
                      _dialogShown = false;
                    } else if (value.length != _pinLength) {
                      _dialogShown = true;
                      showCustomDialog(
                        context: context,
                        imagePath: 'img/failed.png',
                        message: 'The passcode must be 6 characters long.',
                        height: 100,
                        buttonColor: Colors.red,
                      );
                      _dialogShown = false;
                    } else if (value == widget.passcode &&
                        value.length == _pinLength &&
                        !_isNavigating) {
                      _isNavigating = true; // mencegah multiple navigation push

                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.userId)
                          .update({
                        'passcode': value,
                      });

                      // Navigate to the next screen after successful update
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BottomNavigation()),
                      );
                    }
                  }),
              const Text(
                'For your security, we require you to set a passcode to authorize payments. Please enter a 6-digit passcode above.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF607D8B),
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 30),
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
                        if (_confirmationPinController.text.isNotEmpty) {
                          _confirmationPinController.text =
                              _confirmationPinController.text.substring(0,
                                  _confirmationPinController.text.length - 1);
                        }
                        break;
                      case 'Clear':
                        _confirmationPinController.text = '';
                        break;
                      default:
                        if (_confirmationPinController.text.length <
                            _pinLength) {
                          _confirmationPinController.text += str;
                        }
                        break;
                    }
                  },
                ),
              ),
              const Spacer(),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "By continuing, you accept to our ",
                    style: TextStyle(
                        color: Colors.black38,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Terms of Use",
                    style: TextStyle(color: Colors.blueAccent, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_confirmationPinController.text != widget.passcode) {
                      showCustomDialog(
                        context: context,
                        imagePath: 'img/failed.png',
                        message: 'Passcodes do not match',
                        height: 100,
                        buttonColor: Colors.red,
                      );
                    } else if (_confirmationPinController.text.length !=
                        _pinLength) {
                      showCustomDialog(
                        context: context,
                        imagePath: 'img/failed.png',
                        message: 'The passcode must be 6 characters long.',
                        height: 100,
                        buttonColor: Colors.red,
                      );
                    } else {
                      int passcode = int.parse(widget.passcode.trim());
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.userId)
                          .update({
                        'passcode': passcode,
                      });
                      // Navigate to the next screen after successful update
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BottomNavigation()),
                      );
                    }
                  },
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
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
