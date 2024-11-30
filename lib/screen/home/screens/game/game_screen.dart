import 'package:fintar/screen/home/screens/game/widgets/voucher_card.dart';
import 'package:fintar/services/auth_services.dart';
import 'package:fintar/widgets/custom_dialog.dart';
import 'package:fintar/widgets/transaction_details_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Jumlah tab
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 10, 43, 70),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Game Vouchers',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Color.fromARGB(255, 10, 43, 70),
            tabs: [
              Tab(text: 'Free Fire'),
              Tab(text: 'Mobile Legends'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            VoucherList(isFreeFire: true),
            VoucherList(isFreeFire: false),
          ],
        ),
      ),
    );
  }
}

String _formatAmount(dynamic amount) {
  String text = amount is int ? amount.toString() : amount.toString();

  if (text.isEmpty) return '';
  final number = int.parse(text.replaceAll(RegExp(r'[^0-9]'), ''));

  return 'Rp${number.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      )}';
}

class VoucherList extends StatelessWidget {
  final bool isFreeFire;
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _serverIdController = TextEditingController();

  VoucherList({required this.isFreeFire, super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> vouchers = isFreeFire
        ? [
            {
              'price': 85000,
              'gamename': 'Free Fire',
              'item_name': '700 Diamonds + Skin M416 Viper'
            },
            {
              'price': 90000,
              'gamename': 'Free Fire',
              'item_name': '800 Diamonds + Character Alok'
            },
            {
              'price': 95000,
              'gamename': 'Free Fire',
              'item_name': '1000 Diamonds + Bundle DJ Alok'
            },
            {
              'price': 100000,
              'gamename': 'Free Fire',
              'item_name': '1200 Diamonds + Skin AK47 Fire'
            },
            {
              'price': 105000,
              'gamename': 'Free Fire',
              'item_name': '1500 Diamonds + Skin M1887'
            },
            {
              'price': 110000,
              'gamename': 'Free Fire',
              'item_name': '2000 Diamonds + Parachute Skin'
            },
            {
              'price': 115000,
              'gamename': 'Free Fire',
              'item_name': '2500 Diamonds + Skin Scar Titan'
            },
            {
              'price': 120000,
              'gamename': 'Free Fire',
              'item_name': '3000 Diamonds + Bundle Elite Pass'
            },
            {
              'price': 125000,
              'gamename': 'Free Fire',
              'item_name': '3500 Diamonds + Skin AK47 Galactic'
            },
            {
              'price': 130000,
              'gamename': 'Free Fire',
              'item_name': '4000 Diamonds + Character Jai'
            },
          ]
        : [
            {
              'price': 85000,
              'gamename': 'Mobile Legends',
              'item_name': '500 Diamonds + Skin KOF'
            },
            {
              'price': 90000,
              'gamename': 'Mobile Legends',
              'item_name': '600 Diamonds + Skin Epic Lancelot'
            },
            {
              'price': 95000,
              'gamename': 'Mobile Legends',
              'item_name': '700 Diamonds + Hero Lesley'
            },
            {
              'price': 100000,
              'gamename': 'Mobile Legends',
              'item_name': '800 Diamonds + Skin Special Layla'
            },
            {
              'price': 105000,
              'gamename': 'Mobile Legends',
              'item_name': '1000 Diamonds + Hero Granger'
            },
            {
              'price': 110000,
              'gamename': 'Mobile Legends',
              'item_name': '1200 Diamonds + Skin Epic Moskov'
            },
            {
              'price': 115000,
              'gamename': 'Mobile Legends',
              'item_name': '1500 Diamonds + Skin Karina'
            },
            {
              'price': 120000,
              'gamename': 'Mobile Legends',
              'item_name': '2000 Diamonds + Hero Chou'
            },
            {
              'price': 125000,
              'gamename': 'Mobile Legends',
              'item_name': '2500 Diamonds + Skin Epic Selena'
            },
            {
              'price': 130000,
              'gamename': 'Mobile Legends',
              'item_name': '3000 Diamonds + Skin Granger'
            },
          ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input User ID
          TextField(
            controller: _userIdController,
            maxLength: 10,
            buildCounter: (_,
                {required currentLength, maxLength, required isFocused}) {
              return null;
            },
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Type User ID here',
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 20,
              ), // Padding internal
            ),
            keyboardType: TextInputType.number,
            style: const TextStyle(
              fontSize: 16,
            ),
            cursorColor: const Color.fromARGB(255, 10, 43, 70),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: _serverIdController,
            maxLength: 4,
            buildCounter: (_,
                {required currentLength, maxLength, required isFocused}) {
              return null;
            },
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Server ID game',
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 20,
              ), // Padding internal
            ),
            keyboardType: TextInputType.number,
            style: const TextStyle(
              fontSize: 16,
            ),
            cursorColor: const Color.fromARGB(255, 10, 43, 70),
          ),

          const SizedBox(height: 16),

          // Voucher List
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: vouchers.length,
                  itemBuilder: (context, index) {
                    final voucher = vouchers[index];
                    return GestureDetector(
                      onTap: () async {
                        final userId = _userIdController.text;
                        final serverId = _serverIdController.text;

                        // Pastikan input sudah diisi
                        if (userId.isEmpty || serverId.isEmpty) {
                          showCustomDialog(
                            context: context,
                            imagePath: 'img/form_failed.png',
                            message: 'User ID dan Server ID harus diisi!',
                            height: 100,
                            buttonColor: Colors.red,
                          );

                          return;
                        } else if (userId.length != 10 ||
                            serverId.length != 4) {
                          showCustomDialog(
                            context: context,
                            imagePath: 'img/form_failed.png',
                            message:
                                'User ID Harus berisi 10 digit dan Server ID berisi 4 digit!',
                            height: 100,
                            buttonColor: Colors.red,
                          );
                          return;
                        }

                        String customerName = await AuthService().getFullName();
                        String imageUrl = '';

                        if (voucher['gamename'].contains('Free Fire')) {
                          imageUrl = 'img/free_fire.jpg';
                        } else {
                          imageUrl = 'img/mobile_legend.png';
                        }
                        TransactionDetailsModal(
                                customerName: customerName,
                                recipientInfo:
                                    '${_userIdController.text.trim()} (${_serverIdController.text.trim()})',
                                serviceName:
                                    '${voucher['gamename']} ${voucher['item_name']}',
                                serviceImage: imageUrl,
                                amount: voucher['price'])
                            .showCustomModal(context);
                      },
                      child: GameCard(
                        gameName: voucher['gamename']!,
                        voucherName: voucher['item_name']!,
                        voucherPrice: _formatAmount(voucher['price']),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
