import 'package:flutter/material.dart';
import 'package:quicklinker/features/models/order.dart';
import 'package:quicklinker/features/orders/widgets/order_product.dart';
import 'package:quicklinker/theme.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({super.key, required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "رقم الطلب: ${order.orderId}",
                  style: const TextStyle(
                    fontSize: 17,
                    fontFamily: 'OdinRounded',
                  ),
                ),
                Text(
                  "المبلغ الاجمالي: \$${order.amount}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontFamily: 'OdinRounded',
                  ),
                ),
                Text(
                  "الحالة: ${order.status}",
                  style: TextStyle(
                    color: order.status == "received"
                        ? Colors.orange
                        : order.status == "on the way"
                            ? Colors.blue
                            : teal,
                    fontSize: 20,
                    fontFamily: 'OdinRounded',
                  ),
                ),
                Text(
                  " تم الطلب : ${order.date}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'OdinRounded',
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(14.0),
            child: Text(
              "المنتج المطلوب",
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'OdinRounded',
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: order.items.length,
            itemBuilder: (context, index) {
              return OrderProduct(product: order.items[index]);
            },
          ))
        ],
      ),
    );
  }
}
