import 'package:flutter/material.dart';

class SelectSizesDialog extends StatelessWidget {
  const SelectSizesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const Dialog(
      child:  Text('أنت تحاول تحديد أحجام أكثر من المبلغ الذي تريد إضافته إلى سلة التسوق الخاصة بك'),
    );
  }
}
