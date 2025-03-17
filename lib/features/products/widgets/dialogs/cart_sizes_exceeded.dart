import 'package:flutter/material.dart';

class CartSizesExceeded extends StatefulWidget {
  const CartSizesExceeded({super.key});

  @override
  State<CartSizesExceeded> createState() => _CartSizesExceededState();
}

class _CartSizesExceededState extends State<CartSizesExceeded> {
  @override
  Widget build(BuildContext context) {
    return const Dialog(
      child:  Text('أنت تحاول تحديد أحجام أكثر من المبلغ الذي تريد إضافته إلى سلة التسوق الخاصة بك'),
    );
  }
}
