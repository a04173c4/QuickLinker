// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:QuickLinker/constants.dart';
import 'package:QuickLinker/features/auth/services/auth_service.dart';
import 'package:QuickLinker/features/models/order.dart';
import 'package:QuickLinker/features/seller/screens/seller.dart';
import 'package:QuickLinker/providers/user_provider.dart';
import 'package:QuickLinker/utils.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SellerService {
  void addNewProduct(
      {required BuildContext context,
      required String name,
      required double price,
      required String description,
      required int stock,
      required String type,
      required List<File> images,
      List<String> selectedSizes = const [],
      List<String> selectedColors = const []}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    print("TOKEN: ${userProvider.user.token}");
    try {
      if (images.isNotEmpty) {}
      print(1);
      List<String> imgUrls = [];
      print(2);
      final cloudinary =
          CloudinaryPublic('dwxdeaqqk', 'preset-for-file-upload');
      print(3);
      for (int i = 0; i < images.length; i++) {
        print(4);
        print(images[i].path);
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path,
              resourceType: CloudinaryResourceType.Image, folder: name),
        );
        print(5);
        imgUrls.add(response.secureUrl);
      }
      print("TOKEN: ${userProvider.user.token}");
      http.Response response = await http.post(
        Uri.parse('$productsUri/product/create'),
        headers: {
          'Authorization': "Bearer ${userProvider.user.token}",
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token
        },
        body: jsonEncode({
          "name": name,
          "desc": description,
          "img": imgUrls,
          "type": type,
          "stock": stock,
          "price": price,
          "sizes": selectedSizes,
          "colors": selectedColors
        }),
      );
      print("response from ADD PRODUCT APU");
      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'تم تحميل المنتج بنجاح');
            Navigator.of(context).pushNamedAndRemoveUntil(
              Seller.routeName,
              (route) => false,
            );
          });
    } catch (e) {
      showSnackBar(context, e.toString());
      print("MEOWWWW");
    }
  }

  getSellerProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response response = await http.get(
        Uri.parse('$productsUri/products/seller'),
        headers: {
          'Authorization': "Bearer ${userProvider.user.token}",
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print("response from get sellers products api");
      print(response.body);
      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'تم تحميل المنتجات بنجاح');
          });

      return response.body;
    } catch (e) {
      showSnackBar(context, 'لقد حدث خطأ ما');
    }
  }

  void deleteProduct({
    required BuildContext context,
    required String id,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response response = await http.delete(
        Uri.parse('$productsUri/product/$id'),
        headers: {
          'Authorization': "Bearer ${userProvider.user.token}",
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token
        },
      );

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'تم حذف المنتج بنجاح');
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void editProduct({
    required BuildContext context,
    required String name,
    required String description,
    List<File>? images,
    required String type,
    required int stock,
    required double price,
    List<String> selectedColors = const [],
    List<String> selectedSizes = const [],
    required String id,
    bool available = true,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response? response;
      List<String> imgUrls = [];
      if (images != null) {
        final cloudinary =
            CloudinaryPublic('dwxdeaqqk', 'preset-for-file-upload');
        for (int i = 0; i < images.length; i++) {
          CloudinaryResponse response = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(images[i].path,
                resourceType: CloudinaryResourceType.Image, folder: name),
          );
          imgUrls.add(response.secureUrl);
        }
        // cloudinaryResponse = await cloudinary.uploadFile(
        //   CloudinaryFile.fromFile(image.path,
        //       resourceType: CloudinaryResourceType.Image, folder: name),
        // );

        response = await http.put(
          Uri.parse('$productsUri/product/$id'),
          headers: {
            'Authorization': "Bearer ${userProvider.user.token}",
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "name": name,
            "desc": description,
            "img": imgUrls,
            "type": type,
            "stock": stock,
            "price": price,
            "available": available,
            "sizes": selectedSizes,
            "colors": selectedColors,
          }),
        );
      } else {
        response = await http.put(
          Uri.parse('$productsUri/product/$id'),
          headers: {
            'Authorization': "Bearer ${userProvider.user.token}",
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "name": name,
            "desc": description,
            "type": type,
            "stock": stock,
            "price": price,
            "available": available,
            "sizes": selectedSizes,
            "colors": selectedColors,
          }),
        );
      }

      print("RESPONSE FROM UPDATE PRODUCT API");
      print(response.body);

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () async {
            showSnackBar(context, 'تم تحديث المنتج بنجاح');
            AuthService authService = AuthService();
            await authService.getUserData(context);
            Navigator.pushNamedAndRemoveUntil(context, Seller.routeName,
                ModalRoute.withName(Seller.routeName));
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  getSellerSales(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response response = await http.get(
        Uri.parse('$shoppingUri/seller-sales'),
        headers: {
          'Authorization': "Bearer ${userProvider.user.token}",
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print("");
      print("");
      print("");
      print("");
      print("");
      print("");
      print("");
      print("");

      print("RESPONSE FROM GET SELLER SALES API");
      print(response.body);
      List<Order> sellerSales = [];

      for (var order in (jsonDecode(response.body) as List)) {
        print("ORDER");
        print(order);
        sellerSales.add(Order.fromMap(order));
      }
      print(sellerSales);

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'تم تحميل المبيعات بنجاح');
          });

      return sellerSales;
    } catch (e) {
      print(e);
      showSnackBar(context, e.toString());
    }
  }

  updateDeliveryStatus(
      BuildContext context, String orderId, String status) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response response = await http.put(
        Uri.parse('$shoppingUri/sales/$orderId'),
        headers: {
          'Authorization': "Bearer ${userProvider.user.token}",
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"status": status}),
      );

      print("RESPONSE FROM UPDATE DELIVERY STATUS");
      print(response.body);

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'تم تحديث حالة التسليم بنجاح');
            Navigator.pop(context, status);
          });
    } catch (e) {
      print(e);
      showSnackBar(context, e.toString());
    }
  }
}
