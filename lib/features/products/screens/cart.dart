// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:quicklinker/constants.dart';
import 'package:quicklinker/features/common/widgets/empty.dart';
import 'package:quicklinker/features/models/user.dart';
import 'package:quicklinker/features/orders/services/order_service.dart';
import 'package:quicklinker/features/products/widgets/cart_product.dart';
import 'package:quicklinker/features/search/screens/search.dart';
import 'package:quicklinker/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  int quantity = 1;
  void navigateToSearch(String query) {
    Navigator.pushNamed(context, Search.routeName, arguments: query);
  }

  OrderService orderService = OrderService();
  Future<void> initPaymentSheet(
      BuildContext context, User user, double total) async {
    try {
      http.Response response =
          await http.post(Uri.parse('$shoppingUri/create-payment-intent'),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode({"total": total * 100}));
      final data = jsonDecode(response.body);
      print("DATA FROM STRIPE API");
      print(data);

      final paymentIntent = data['paymentIntent'];
      final ephemeralKey = data['ephemeralKey'];
      final customer = data['customer'];
      const publishableKey =
          "pk_test_51QUj13KvYI3VPzXg09FJihE8d7S6TZhH1snWgfyn7AcwjQkDX1UMYIyqkeBusWVT7VC8B4jSllmjVfYMmF9knYho00dQKl01Bv";

      Stripe.publishableKey = publishableKey;
      BillingDetails billingDetails = BillingDetails(
        email: user.email,
        phone: user.phone,
        name: user.profile.name,
      );

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          merchantDisplayName: 'MOBIZATE',
          paymentIntentClientSecret: paymentIntent,
          customerEphemeralKeySecret: ephemeralKey,
          customerId: customer,
          style: ThemeMode.light,
          billingDetails: billingDetails,
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'IN',
            currencyCode: 'usd',
            testEnv: true,
          ),
        ),
      );

      await Stripe.instance
          .presentPaymentSheet()
          .then((value) {})
          .onError((error, stackTrace) {
        if (error is StripeException) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('${error.error.localizedMessage}')),
          // );
        } else {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('Stripe Error: $error')),
          // );
        }
      });
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error initializing payment: $e')),
      // );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(e.toString())),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    double total = 0;
    print("ei?");
    for (var item in user.cart) {
      total = total + (item.amount * item.product.price).toDouble();
    }
    print("NEW TOTAL $total");
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(" سلة ${user.profile.name}"),
      ),
      body: Column(
        mainAxisAlignment: user.cart.isEmpty
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceBetween,
        children: [
          user.cart.isEmpty
              ? const Empty(
                  img: "assets/images/np.png",
                  title: "سلة التسوق الخاصة بك فارغة",
                  subtitle:
                      "يبدو أنك لم تُضِف أي شيء إلى سلة التسوق الخاصة بك. استكشف أفضل الفئات.",
                  btnText: "تصفح الفئات")
              : ListView.builder(
                  itemCount: user.cart.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return CartProduct(
                      index: index,
                    );
                  },
                ),
          user.cart.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    child: Text(
                      'الدفع \$$total (${user.cart.length} أغراض)',
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'OdinRounded',
                      ),
                    ),
                    onPressed: () async {
                      await initPaymentSheet(context, user, total);
                      await orderService.placeOrder(context: context);
                    },
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
