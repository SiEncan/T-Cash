import 'package:fintar/services/auth_services.dart';
import 'package:fintar/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:fintar/screen/auth/passcode_confirm_create.dart';
import 'package:simple_numpad/simple_numpad.dart';

// ignore: must_be_immutable
class CreatePasscode extends StatefulWidget {
  String userId = AuthService().getUserId();

  CreatePasscode({super.key});
  @override
  CreatePasscodeState createState() => CreatePasscodeState();
}

class CreatePasscodeState extends State<CreatePasscode> {
  final int _pinLength = 6;
  final TextEditingController _pinController = TextEditingController();
  bool _isNavigating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Set Payment PIN",
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
                controller: _pinController,
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
                onCompleted: (value) async {
                  if (!_isNavigating && value.length == _pinLength) {
                    _isNavigating = true; // mencegah multiple navigation push
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreatePasscodeConfirm(
                          userId: widget.userId,
                          passcode: value,
                        ),
                      ),
                    );
                  } else if (value.length != _pinLength) {
                    showCustomDialog(
                      context: context,
                      imagePath: 'img/failed.png',
                      message: 'The passcode must be 6 characters long.',
                      height: 100,
                      buttonColor: Colors.red,
                    );
                  }
                },
              ),
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
                      if (_pinController.text.length < _pinLength ||
                          str == 'BACKSPACE' ||
                          str == 'Clear') {
                        switch (str) {
                          case 'BACKSPACE':
                            if (_pinController.text.isNotEmpty) {
                              _pinController.text = _pinController.text
                                  .substring(0, _pinController.text.length - 1);
                            }
                            break;
                          case 'Clear':
                            _pinController.text = '';
                            break;
                          default:
                            _pinController.text += str;
                            break;
                        }
                      }
                    }),
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_pinController.text.trim().length != _pinLength) {
                      showCustomDialog(
                        context: context,
                        imagePath: 'img/failed.png',
                        message: 'The passcode must be 6 characters long.',
                        height: 100,
                        buttonColor: Colors.red,
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreatePasscodeConfirm(
                            userId: widget.userId,
                            passcode: _pinController.text.trim(),
                          ),
                        ),
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
