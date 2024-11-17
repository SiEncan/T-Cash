import 'package:flutter/material.dart';
import 'package:fintar/widgets/custom_dialog.dart';

class MeterNumberInput extends StatefulWidget {
  final Function(String) onMeterNumberValid;
  final String customerName;

  const MeterNumberInput(
      {super.key,
      required this.onMeterNumberValid,
      required this.customerName});

  @override
  MeterNumberInputState createState() => MeterNumberInputState();
}

class MeterNumberInputState extends State<MeterNumberInput> {
  final TextEditingController meterNumberInputController =
      TextEditingController();
  bool inputValid = false;
  String meterNumber = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'METER NUMBER',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700]),
            ),
            const SizedBox(width: 4),
            GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(8)),
                    ),
                    builder: (BuildContext context) {
                      return FractionallySizedBox(
                        heightFactor: 0.3,
                        widthFactor: 1.0,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 50,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Text(
                                    'How to find Meter Number',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Icon(
                                      Icons.cancel,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    'img/meteran.jpg',
                                    height: 100,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Check 11 or 12 digits number on the electric meter & recent electricity token receipt.',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[800]),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'GOT IT!',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Icon(
                  Icons.info_outline_rounded,
                  color: Colors.blue,
                  size: 18,
                )),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: meterNumberInputController,
          maxLength: 12,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter your Meter Number',
            hintStyle: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
                fontSize: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 2,
              horizontal: 12,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                meterNumberInputController.text = '';
              },
              child: const Icon(
                Icons.cancel,
                color: Colors.grey,
                size: 18,
              ),
            ),
          ),
          buildCounter: (_,
              {required currentLength, maxLength, required isFocused}) {
            return null; // Menyembunyikan penghitung karakter
          },
          onEditingComplete: () {
            setState(() {
              if (meterNumberInputController.text.length >= 11) {
                meterNumber = meterNumberInputController.text;
                widget.onMeterNumberValid(meterNumber);
                inputValid = true;
              } else {
                showCustomDialog(
                  context: context,
                  imagePath: 'img/failed.png',
                  message: 'Meter Number consists of 11 minimum characters.',
                  height: 100,
                  buttonColor: Colors.red,
                );
              }
            });
          },
        ),
        if (inputValid)
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Customer Name',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    widget.customerName,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[900],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Tariff / Power',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    'R1 / 2200 VA',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[900],
                    ),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
