import 'package:flutter/material.dart';

class CartColorsExceeded extends StatefulWidget {
  const CartColorsExceeded({super.key});

  @override
  State<CartColorsExceeded> createState() => _CartColorsExceededState();
}

class _CartColorsExceededState extends State<CartColorsExceeded> {
  @override
  Widget build(BuildContext context) {
    return const Dialog(
      child:  Text('أنت تحاول تحديد عدد ألوان أكبر من الكمية التي تريد إضافتها إلى سلة التسوق الخاصة بك'),
    );
  }
}
