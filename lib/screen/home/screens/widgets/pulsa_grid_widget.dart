import 'package:fintar/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fintar/screen/home/screens/widgets/pulsa_card_widget.dart';
import 'package:fintar/services/auth_services.dart';
import 'package:fintar/services/saldo_services.dart';
import 'package:fintar/services/transaction_services.dart';

// ignore: must_be_immutable
class PulsaGrid extends StatelessWidget {
  String selectedProviderParam;
  String phoneNumber;
  String receiverName;

  PulsaGrid(
      {super.key,
      required this.selectedProviderParam,
      required this.phoneNumber,
      required this.receiverName});

  final authService = AuthService();
  final SaldoService _saldoService = SaldoService();
  final TransactionService _transactionService = TransactionService();

  final List<String> jumlahPulsa = [
    '5k',
    '10k',
    '15k',
    '20k',
    '25k',
    '30k',
    '40k',
    '50k',
    '60k',
    '70k',
    '80k',
    '90k',
    '100k'
  ];

  late List<String> hargaPulsa; // declare list harga pulsa

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    //  harga pulsa berdasarkan selected provider
    if (selectedProviderParam == 'IM3') {
      hargaPulsa = [
        '7.000',
        '12.000',
        '17.000',
        '21.000',
        '26.000',
        '31.000',
        '41.000',
        '51.000',
        '61.000',
        '71.000',
        '81.000',
        '91.000',
        '101.000'
      ];
    } else if (selectedProviderParam == 'Telkomsel') {
      hargaPulsa = [
        '8.000',
        '13.000',
        '18.000',
        '22.000',
        '28.000',
        '32.500',
        '42.500',
        '52.500',
        '62.500',
        '72.500',
        '82.500',
        '92.500',
        '102.500'
      ];
    } else if (selectedProviderParam == 'XL') {
      hargaPulsa = [
        '7.500',
        '12.500',
        '17.500',
        '21.500',
        '26.500',
        '31.500',
        '41.500',
        '51.500',
        '61.500',
        '71.500',
        '81.500',
        '91.500',
        '101.500'
      ];
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 3 / 2,
      ),
      itemCount: jumlahPulsa.length,
      itemBuilder: (context, index) {
        return InkWell(
          child: PulsaCard(
            jumlahPulsa: jumlahPulsa[index],
            hargaPulsa: 'Rp${hargaPulsa[index]}',
          ),
          onTap: () {
            showModal(context, index, screenHeight);
          },
        );
      },
    );
  }

  Future<dynamic> showModal(
      BuildContext context, int index, double screenHeight) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.7, // 70% tinggi layar
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
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
                      const SizedBox(height: 10),
                      const Text(
                        "Transaction Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Divider(height: 30, color: Colors.grey),
                      const SizedBox(height: 8),
                      Text(
                        'Receiver Name',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        receiverName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Phone Number',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        phoneNumber,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 57, 57, 57),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 30, color: Colors.grey),
                      Text(
                        'Purchase Detail',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      Image.asset(
                        'img/$selectedProviderParam.png',
                        width: 120,
                        height: 60,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Pulsa: ${jumlahPulsa[index].replaceAll('k', '.000')}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(height: 30, color: Colors.grey),
                      Text(
                        'Payment Detail',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Price:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '  Rp${hargaPulsa[index]}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  height: (screenHeight * 0.7) * 0.2,
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(78, 50, 50, 50),
                        blurRadius: 8,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        'All your transactions are secure and fast. By continuing, you agree to the ',
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 12),
                                  ),
                                  const TextSpan(
                                    text: 'Terms and Conditions',
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: BorderSide(color: Colors.grey[400]!),
                                ),
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  String userId = authService.getUserId();
                                  int hargaFormatted = int.parse(
                                      hargaPulsa[index].replaceAll('.', ''));
                                  await _saldoService.reduceSaldo(
                                      userId, hargaFormatted);

                                  await _transactionService.saveTransaction(
                                      userId,
                                      hargaFormatted,
                                      'Payment',
                                      'Pulsa $selectedProviderParam ${jumlahPulsa[index].replaceAll('k', '.000')}');
                                  Navigator.pop(context);
                                  showCustomDialog(
                                    context: context,
                                    imagePath: 'img/success.png',
                                    message:
                                        'Purchase successful. Your credits will be applied shortly.',
                                    height: 100,
                                    buttonColor: Colors.green,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: Colors.blueAccent,
                                ),
                                child: const Text(
                                  "Confirm Payment",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
