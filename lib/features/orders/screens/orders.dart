import 'package:flutter/material.dart';
import 'package:QuickLinker/features/common/widgets/empty.dart';
import 'package:QuickLinker/features/models/order.dart';
import 'package:QuickLinker/features/models/user.dart';
import 'package:QuickLinker/features/orders/screens/order_details.dart';
import 'package:QuickLinker/features/orders/services/order_service.dart';
import 'package:QuickLinker/providers/user_provider.dart';
import 'package:QuickLinker/theme.dart';
import 'package:provider/provider.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});
  static const String routeName = '/orders';
  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<Order>? orders;
  List<Order> ongoingOrders = [];
  List<Order> deliveredOrders = [];

  final OrderService orderService = OrderService();
  List<String> imgs = [
    'assets/images/appliances.jpeg',
    'assets/images/appliances.jpeg',
    'assets/images/appliances.jpeg',
    'assets/images/appliances.jpeg',
  ];
  @override
  void initState() {
    super.initState();
    fetchOrders(context);
  }

  void fetchOrders(context) async {
    orders = await orderService.getOrders(context: context);
    for (var order in orders!) {
      if (order.status == "received" || order.status == "on the way") {
        ongoingOrders.add(order);
      } else if (order.status == "delivered") {
        deliveredOrders.add(order);
      }
    }

    setState(() {});
  }

  bool isOngoingSelected = true;
  bool isDeliveredSelected = false;
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    return orders == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              title: Text(" طلبات ${user.profile.name}"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.07,
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                        color: Color(0xFF282828),
                        borderRadius: BorderRadius.all(Radius.circular(14))),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isOngoingSelected = true;
                                isDeliveredSelected = false;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: isOngoingSelected ? black : null,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(14))),
                              child: const Center(
                                child: Text(
                                  "جاري",
                                  style: TextStyle(
                                    color: white,
                                    fontSize: 22,
                                    fontFamily: 'OdinRounded',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isOngoingSelected = false;
                                isDeliveredSelected = true;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: isDeliveredSelected ? black : null,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(14))),
                              child: const Center(
                                child: Text("تم التسليم",
                                    style: TextStyle(
                                      color: white,
                                      fontSize: 22,
                                      fontFamily: 'OdinRounded',
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  isOngoingSelected
                      ? ongoingOrders.isEmpty
                          ? Column(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.14,
                                ),
                                const Empty(
                                    img: "assets/images/orderempty.png",
                                    title: "لا توجد طلبات جارية",
                                    subtitle:
                                        "لا توجد لديك أي طلبات جارية حاليًا. تسوق في متاجرنا للحصول على أعلى جودة!",
                                    btnText: "تصفح الفئات"),
                              ],
                            )
                          : Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: ongoingOrders.length,
                                      itemBuilder: (context, index) {
                                        Order order = ongoingOrders[index];
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) {
                                                return OrderDetails(
                                                    order: order);
                                              },
                                            ));
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.light
                                                    ? lightAsh
                                                    : ash),
                                            margin: const EdgeInsets.all(8),
                                            child: Column(
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "رقم الطلب: ${order.orderId}",
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: 'OdinRounded',
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                        color: order.status ==
                                                                "received"
                                                            ? Colors.orange
                                                            : order.status ==
                                                                    "on the way"
                                                                ? Colors.blue
                                                                : teal,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    child: Text(
                                                      order.status,
                                                      style: const TextStyle(
                                                        fontSize: 17,
                                                        fontFamily:
                                                            'OdinRounded',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Text(
                                                    "تاريخ: ${order.date}",
                                                    style: const TextStyle(
                                                      fontSize: 17,
                                                      fontFamily: 'OdinRounded',
                                                    ),
                                                  ),
                                                ),
                                                const Divider(
                                                  thickness: 0.4,
                                                ),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "إجمالي المبلغ المدفوع: ${order.amount.toString()}",
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontFamily: 'OdinRounded',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                      : deliveredOrders.isEmpty
                          ? Column(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.14,
                                ),
                                const Empty(
                                    img: "assets/images/orderempty.png",
                                    title: "لا توجد طلبات جاهزة",
                                    subtitle:
                                        "لم تُنجز أي طلبات حتى الآن. بائعونا الموثوقون سيوصلون منتجاتك إليك في أسرع وقت!",
                                    btnText: "تصفح الفئات"),
                              ],
                            )
                          : Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: deliveredOrders.length,
                                      itemBuilder: (context, index) {
                                        Order order = deliveredOrders[index];
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) {
                                                return OrderDetails(
                                                    order: order);
                                              },
                                            ));
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.light
                                                    ? lightAsh
                                                    : ash),
                                            margin: const EdgeInsets.all(8),
                                            child: Column(
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Order ID: ${order.orderId}",
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: 'OdinRounded',
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                        color: order.status ==
                                                                "received"
                                                            ? Colors.orange
                                                            : order.status ==
                                                                    "on the way"
                                                                ? Colors.blue
                                                                : teal,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    child: Text(
                                                      order.status,
                                                      style: const TextStyle(
                                                        fontSize: 17,
                                                        fontFamily:
                                                            'OdinRounded',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Text(
                                                    "Date: ${order.date}",
                                                    style: const TextStyle(
                                                      fontSize: 17,
                                                      fontFamily: 'OdinRounded',
                                                    ),
                                                  ),
                                                ),
                                                const Divider(
                                                  thickness: 0.4,
                                                ),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "إجمالي المبلغ المدفوع: ${order.amount.toString()}",
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontFamily: 'OdinRounded',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                ],
              ),
            ),
          );
  }
}
