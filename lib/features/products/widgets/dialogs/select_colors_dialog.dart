import 'package:flutter/material.dart';

class SelectColorsDialog extends StatelessWidget {
  const SelectColorsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const Dialog(
      child:  Text('أنت تحاول تحديد عدد ألوان أكبر من الكمية التي تريد إضافتها إلى سلة التسوق الخاصة بك'),
    );
  }
}
