import 'dart:convert';

import 'package:QuickLinker/constants.dart';
import 'package:QuickLinker/features/models/order.dart';
import 'package:QuickLinker/features/models/user.dart';
import 'package:QuickLinker/providers/user_provider.dart';
import 'package:QuickLinker/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class OrderService extends ChangeNotifier {
  Future<void> placeOrder({
    required BuildContext context,
  }) async {
    print("IN PLACE ORDER FUNCTION?");
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      print('$shoppingUri/order');
      http.Response res = await http.post(
        Uri.parse('$shoppingUri/order'),
        headers: {
          'Authorization': 'Bearer ${userProvider.user.token}',
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      print("response from order api");
      print(res.body);
      print(res.statusCode);

      httpErrorHandle(
        response: res,
        // ignore: use_build_context_synchronously
        context: context,
        onSuccess: () {
          print("ON SUCCESS>?????????/");
          showSnackBar(context, 'لقد تم تقديم طلبك!');
          User user = userProvider.user.copyWith(
            cart: [],
          );
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString());
    }
  }

  Future<List<Order>> getOrders({
    required BuildContext context,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      print('$shoppingUri/orders');
      http.Response res = await http.get(
        Uri.parse('$shoppingUri/orders'),
        headers: {
          'Authorization': 'Bearer ${userProvider.user.token}',
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      print("response from get orders");
      print(res.body);
      List<Order> data = (jsonDecode(res.body) as List).map((item) {
        print("ITEM UNDER ANALYSIS");
        print(item);
        print(item["amount"]);
        return Order.fromMap(item);
      }).toList();
      print("dataa after casting?");
      print(data);
      return data;
    } catch (err) {
      showSnackBar(context, err.toString());
      return [];
    }
  }
}
