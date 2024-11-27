import 'package:fintar/screen/home/screens/linkpay/input_screen.dart';
import 'package:flutter/material.dart';

class LinkPaySelectionPage extends StatelessWidget {
  final List<String> services = ['GoPay', 'ShopeePay', 'Tokopedia', 'OVO'];
  final List<String> imageAssets = [
    'img/gopay_logo.png',
    'img/shopeepay_logo.png',
    'img/tokopedia_logo.png',
    'img/ovo_logo.png',
  ];

  LinkPaySelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Link Pay",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.separated(
        itemCount: services.length + 1,
        itemBuilder: (context, index) {
          if (index == services.length) {
            return null;
          }
          return ListTile(
            leading: ClipOval(
              child: Image.asset(
                imageAssets[index],
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(services[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransferToServiceScreen(
                    service: services[index],
                    serviceImage: imageAssets[index],
                  ),
                ),
              );
            },
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            color: Colors.grey,
            thickness: 1,
            indent: 0,
            endIndent: 0,
          );
        },
      ),
    );
  }
}
