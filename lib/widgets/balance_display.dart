import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BalanceDisplay extends StatelessWidget {
  final bool isVisible;
  final int saldo;

  const BalanceDisplay(
      {super.key, required this.isVisible, required this.saldo});
  String formatSaldo(int saldo) {
    final formatter = NumberFormat('#,###');
    return formatter.format(saldo);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Rp',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(137, 255, 255, 255),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.2, end: 1.0).animate(animation),
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.2, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
              );
            },
            child: Text(
              isVisible
                  ? ' ${formatSaldo(saldo)}'
                  : ' *****', // saldo atau tanda bintang
              key: ValueKey<bool>(isVisible),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
