import 'package:fintar/screen/profile/userprofilecomponents/help_center.dart';
import 'package:fintar/widgets/custom_page_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class DetailScreen extends StatefulWidget {
  final String transactionId;
  final String fullName;
  final String type;
  final String date;
  final String amount;
  final String? additionalInfo;
  final String? description;
  final String? partyName;
  final String? note;

  const DetailScreen({
    super.key,
    required this.transactionId,
    required this.fullName,
    required this.type,
    required this.date,
    required this.amount,
    this.additionalInfo,
    this.description,
    this.partyName,
    this.note,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
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

void showVoucherPopup(
    BuildContext context, String? description, String? additionalInfo) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                description!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // QR Code
              // ignore: deprecated_member_use
              PrettyQr(
                size: 200,
                data: additionalInfo!.split(' ').last,
                errorCorrectLevel: QrErrorCorrectLevel.H,
                roundEdges: true,
                elementColor: Colors.white,
              ),
              const SizedBox(height: 10),
              Text(
                additionalInfo,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Menutup popup
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.grey[800],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Close",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Container(
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 5.5),
          child: const Text(
            'Transaction',
            style: TextStyle(color: Colors.white),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            color: Colors.blue,
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding:
                const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 16),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: () {
                    final description = widget.description ?? '';
                    final assetMap = {
                      'Tokopedia': 'img/tokopedia_logo.png',
                      'Shopee': 'img/shopeepay_logo.png',
                      'OVO': 'img/ovo_logo.png',
                      'GoPay': 'img/gopay_logo.png',
                      'PLN': 'img/Logo_PLN.png',
                      'Hophop': 'img/hophop.png',
                      'Dokki': 'img/dookki.png',
                      'Starbuck': 'img/starbucks.png',
                      'Kenangan': 'img/kopikenangan.png',
                      'KFC': 'img/kfc.png',
                      'Lazada': 'img/lazada.png',
                      'blibli': 'img/blibli.png',
                      'Tiket': 'img/tiket.png',
                      'Traveloka': 'img/traveloka.png',
                      'Steam': 'img/Steam_logo.png',
                      'Mobile Legend': 'img/mobile_legend.png',
                      'Free Fire': 'img/free_fire.jpg',
                    };

                    for (final entry in assetMap.entries) {
                      if (description.contains(entry.key)) {
                        final isOval = [
                          'PLN',
                        ].contains(entry.key);
                        return isOval
                            ? Image.asset(
                                entry.value,
                                width: 128,
                                height: 128,
                              )
                            : ClipOval(
                                child: Image.asset(
                                  entry.value,
                                  width: 128,
                                  height: 128,
                                  fit: BoxFit.cover,
                                ),
                              );
                      }
                    }

                    return widget.type.contains('Transfer')
                        ? Image.asset(
                            'img/logo_transparent.png',
                            width: 128,
                            height: 128,
                            color: Colors.blue,
                          )
                        : Icon(
                            description.contains('Apple')
                                ? Icons.apple
                                : description.contains('Pulsa')
                                    ? Icons.phone_android
                                    : widget.type.contains('Top')
                                        ? Icons.add_circle
                                        : Icons.shopping_cart,
                            color: description.contains('Apple')
                                ? Colors.black
                                : Colors.blue,
                            size: 128,
                          );
                  }(),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Text(
                      widget.date,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const Spacer(),
                    Text(
                      'T-CASH APP - ${widget.fullName}',
                      style: const TextStyle(fontSize: 12),
                    )
                  ],
                ),
                const Divider(height: 32),
                const Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Transaction success!',
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  (widget.type.contains('Top'))
                      ? widget.type
                      : (widget.description?.isNotEmpty == true)
                          ? widget.description!
                          : (widget.type.contains('in'))
                              ? 'Receive Money from ${widget.partyName!.toUpperCase()}'
                              : (widget.type.contains('out'))
                                  ? 'Send Money to ${widget.partyName!.toUpperCase()}'
                                  : '-',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15),
                ),
                const SizedBox(height: 2),
                (widget.additionalInfo?.isNotEmpty == true)
                    ? Text(
                        widget.additionalInfo!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 13),
                      )
                    : Container(),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Text(
                        (widget.type.contains('Top') ||
                                widget.type.contains('in'))
                            ? 'Total Received'
                            : 'Total Payment',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      const Spacer(),
                      Text(
                        _formatAmount(widget.amount),
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      'Payment method',
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    const Spacer(),
                    (widget.type.contains('Top'))
                        ? Text(widget.description!,
                            style: const TextStyle(fontWeight: FontWeight.w400))
                        : const Text('T-CASH Balance',
                            style: TextStyle(fontWeight: FontWeight.w400))
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(height: 4),
                    Visibility(
                      visible: widget.type.contains('Transfer'),
                      child: Row(
                        children: [
                          const Text(
                            'Note:',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            widget.note ?? 'No note available',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(
                  height: 32,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                          child: Row(
                            children: [
                              const Text(
                                'Transaction Detail',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              const Spacer(),
                              Icon(
                                _isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        if (_isExpanded) ...[
                          Row(
                            children: [
                              const Text(
                                'Transaction ID',
                                style: TextStyle(fontSize: 13),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                      text: widget.transactionId));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Copied to clipboard: ${widget.transactionId}'),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: const Icon(
                                  Icons.copy,
                                  size: 16,
                                  color: Colors.blue,
                                ),
                              ),
                              const Spacer(),
                              Text(widget.transactionId)
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Row(
                            children: [
                              Text(
                                'Merchant Order ID',
                                style: TextStyle(fontSize: 13),
                              ),
                              Spacer(),
                              Text('•••JVu2'),
                            ],
                          ),
                        ],
                        if (widget.type.contains('Pay') &&
                            widget.description!.contains('Voucher')) ...[
                          const SizedBox(height: 32),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                showVoucherPopup(context, widget.description,
                                    widget.additionalInfo);
                              },
                              // ignore: deprecated_member_use
                              child: const PrettyQr(
                                size: 100,
                                data: 'Voucher',
                                errorCorrectLevel: QrErrorCorrectLevel.H,
                                roundEdges: true,
                                elementColor: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Center(
                            child: Text(
                              'View your QR Voucher here!',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                Material(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    splashColor: Colors.blue.withOpacity(0.2),
                    onTap: () {
                      Navigator.of(context)
                          .push(createRoute(const HelpCenter(), 0, 1));
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8)),
                      child: const Center(
                          child: Text(
                        'NEED SOME HELP?',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
