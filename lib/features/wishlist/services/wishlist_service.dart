// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:QuickLinker/constants.dart';
import 'package:QuickLinker/features/models/cart_item.dart';
import 'package:QuickLinker/features/models/product.dart';

import 'package:QuickLinker/providers/user_provider.dart';
import 'package:QuickLinker/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class WishlistService extends ChangeNotifier {
  void editWishlist(
      {required BuildContext context,
      required Product product,
      required int amount,
      List<String> selectedColors = const [],
      List<String> selectedSizes = const [],
      bool isRemove = false,
      bool isUpdateQuantityOnly = false}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    http.Response? res;
    try {
      if (isUpdateQuantityOnly) {
        res = await http.put(
          Uri.parse('$productsUri/wishlist'),
          headers: {
            'Authorization': 'Bearer ${userProvider.user.token}',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "product": {
              "_id": product.id,
            },
            "amount": amount,
            "isRemove": isRemove
          }),
        );
      } else {
        print("DATA BEING SENT");
        print(selectedColors);
        print(selectedSizes);
        res = await http.put(
          Uri.parse('$productsUri/wishlist'),
          headers: {
            'Authorization': 'Bearer ${userProvider.user.token}',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "product": {
              "_id": product.id,
              "sizes": selectedSizes,
              "colors": selectedColors
            },
            "amount": amount,
            "isRemove": isRemove
          }),
        );
      }
      print("from wishlist apiiiii?????????????????");
      print(res.body);

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'تم تحديث قائمة الرغبات');
          // instead of keeping the cart as part of state management you could just call api using the req.user id
          CartItem wishlistItem = CartItem(
              product: Product.fromMap(jsonDecode(res!.body)["product"]),
              amount: amount);
          if (isRemove == true) {
            userProvider.user.wishlist
                .removeWhere((item) => item.product.id == product.id);
          } else {
            int existingItemIndex = userProvider.user.wishlist.indexWhere(
              (item) => item.product.id == wishlistItem.product.id,
            );

            if (existingItemIndex != -1) {
              userProvider.user.wishlist[existingItemIndex] = wishlistItem;
            } else {
              userProvider.user.wishlist.add(wishlistItem);
            }
          }
          userProvider.notifyListeners();
        },
      );
    } catch (e) {
      print(e);
      showSnackBar(context, e.toString());
    }
  }

  void moveFromWishlistToCart({
    required BuildContext context,
    required Product product,
    required int amount,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.put(
        Uri.parse('$productsUri/cart'),
        headers: {
          'Authorization': 'Bearer ${userProvider.user.token}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "product": {
            "_id": product.id,
            "sizes": product.sizes,
            "colors": product.colors
          },
          "amount": amount,
          "isRemove": false
        }),
      );
      print("from move to cart apiiiii?????????????????");
      print(res.body);

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'تم نقله من قائمة الرغبات إلى عربة التسوق');
          CartItem cartItem = CartItem(product: product, amount: amount);
          userProvider.user.wishlist
              .removeWhere((item) => item.product.id == product.id);

          int existingItemIndex = userProvider.user.cart.indexWhere(
            (item) => item.product.id == cartItem.product.id,
          );

          if (existingItemIndex != -1) {
            userProvider.user.cart[existingItemIndex] = cartItem;
          } else {
            userProvider.user.cart.add(cartItem);
          }

          userProvider.notifyListeners();
        },
      );
    } catch (e) {
      print(e);
      showSnackBar(context, e.toString());
    }
  }

  getProduct(String productId, BuildContext context) async {
    try {
      http.Response res = await http.get(
        Uri.parse('$productsUri/$productId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print("get product api resonns");
      print(res.body);
      var productDetails = jsonDecode(res.body);
      Product product = Product.fromMap(productDetails);
      return product;
    } catch (e) {
      print("error");
      print(e);
      showSnackBar(context, e.toString());
    }
  }
}
