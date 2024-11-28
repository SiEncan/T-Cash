import 'package:fintar/screen/home/screens/pln/widgets/meter_number_input.dart';
import 'package:fintar/screen/home/screens/pln/widgets/pln_grid.dart';
import 'package:fintar/services/auth_services.dart';
import 'package:flutter/material.dart';

class PlnScreen extends StatefulWidget {
  const PlnScreen({super.key});

  @override
  State<PlnScreen> createState() => _PayElectricityScreenState();
}

class _PayElectricityScreenState extends State<PlnScreen> {
  final userId = AuthService().getUserId();
  bool inputValid = false;
  String customerName = '';
  String meterNumber = '';

  Future<void> getCustomerName() async {
    String fullName = await AuthService().getFullName();
    setState(() {
      customerName = fullName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Listrik PLN',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(children: [
        Container(
          height: 70,
          color: Colors.blue,
        ),
        Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 0.7,
                ),
              ),
              child: MeterNumberInput(
                  onMeterNumberValid: (validMeterNumber) {
                    setState(() {
                      meterNumber = validMeterNumber;
                      getCustomerName();
                      inputValid = true;
                    });
                  },
                  customerName: customerName),
            ),
            if (inputValid)
              Expanded(
                child: PlnGridWidget(
                    customerName: customerName, meterNumber: meterNumber),
              ),
          ],
        ),
      ]),
    );
  }
}
