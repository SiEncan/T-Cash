import 'package:flutter/material.dart';

class PromoCodePage extends StatefulWidget {
  const PromoCodePage({super.key});

  @override
  State<PromoCodePage> createState() => _PromoCodePageState();
}

class _PromoCodePageState extends State<PromoCodePage> {
  final TextEditingController promoCodeController = TextEditingController();
  bool _isLoading = false;
  String? _discountMessage;

  // Simulasi daftar kode promo
  final Map<String, String> promoCodes = {
    'DISCOUNT10': '10% off on your next purchase',
    'FREESHIP': 'Free shipping on orders above \$50',
    'SAVE20': '20% off for first-time users',
  };

  void _redeemPromoCode() async {
    setState(() {
      _isLoading = true;
      _discountMessage = null; // Reset pesan sebelumnya
    });

    await Future.delayed(const Duration(seconds: 1)); // Simulasi API call

    final code = promoCodeController.text.trim().toUpperCase();
    if (promoCodes.containsKey(code)) {
      setState(() {
        _discountMessage = promoCodes[code];
      });
    } else {
      setState(() {
        _discountMessage = 'Invalid promo code. Please try again.';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Background biru penuh
      appBar: AppBar(
        backgroundColor: Colors.blue, // Warna app bar sama dengan background
        elevation: 0, // Hilangkan bayangan pada AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Enter your promo code below to redeem discounts:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white, // Teks berwarna putih
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: promoCodeController,
                    decoration: InputDecoration(
                      labelText: 'Promo Code',
                      labelStyle: const TextStyle(color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.blue),
                        onPressed: () {
                          promoCodeController.clear();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          )
                        : ElevatedButton(
                            onPressed: _redeemPromoCode,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, // Tombol putih
                              foregroundColor: Colors.blue, // Teks tombol biru
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 32),
                            ),
                            child: const Text('Redeem'),
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (_discountMessage != null)
              Center(
                child: Text(
                  _discountMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: _discountMessage!.startsWith('Invalid')
                        ? const Color.fromARGB(255, 255, 67, 54)
                        : const Color.fromARGB(255, 38, 255, 45),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
