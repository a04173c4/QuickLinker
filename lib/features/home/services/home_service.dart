// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:quicklinker/constants.dart';
import 'package:quicklinker/features/models/product.dart';
import 'package:quicklinker/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeService {
  getProductsByCategory({
    required BuildContext context,
    required String category,
  }) async {
    try {
      print('$productsUri/category/$category');
      http.Response response = await http.get(
        Uri.parse('$productsUri/category/$category'),
      );
      print("RESPONSE FROM API");
      print(response.body);
      httpErrorHandle(
          response: response,
          // ignore: use_build_context_synchronously
          context: context,
          onSuccess: () {
            showSnackBar(context, 'تم تحميل المنتجات بنجاح');
          });
      List<Product> products =
          (jsonDecode(response.body) as List).map((product) {
        print("IN CAST $product");
        return Product.fromMap(product);
      }).toList();
      print("after cast?");
      return products;
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString());
    }
  }
}
