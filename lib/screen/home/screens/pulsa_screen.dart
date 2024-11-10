import 'package:fintar/screen/home/screens/widgets/pulsa_grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fintar/screen/home/screens/widgets/phone_input_widget.dart';

class PulsaScreen extends StatefulWidget {
  const PulsaScreen({super.key});

  @override
  State<PulsaScreen> createState() => _PulsaScreenState();
}

class _PulsaScreenState extends State<PulsaScreen> {
  final phoneNumberController = TextEditingController();
  final nameController = TextEditingController();
  String selectedProvider = 'IM3';

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Text("User not logged in.");
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pulsa',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              PhoneNumberInput(
                user: user,
                phoneNumberController: phoneNumberController,
                nameController: nameController,
                selectedProviderParam: selectedProvider,
                onProviderSelected: (provider) {
                  setState(() {
                    selectedProvider = provider; // Update selected provider
                  });
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                  child: PulsaGrid(
                selectedProviderParam: selectedProvider,
              ))
            ],
          ),
        ),
      ),
    );
  }
}
