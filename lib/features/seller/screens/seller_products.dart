// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:quicklinker/features/common/widgets/empty.dart';
import 'package:quicklinker/features/models/user.dart';
import 'package:quicklinker/features/seller/screens/add_product.dart';
import 'package:quicklinker/features/seller/screens/edit_product.dart';
import 'package:quicklinker/features/seller/services/seller_service.dart';
import 'package:flutter/material.dart';
import 'package:quicklinker/providers/user_provider.dart';
import 'package:quicklinker/theme.dart';
import 'package:provider/provider.dart';

class SellerProducts extends StatefulWidget {
  const SellerProducts({super.key});
  static const String routeName = 'seller-products';
  @override
  State<SellerProducts> createState() => _SellerProductsState();
}

class _SellerProductsState extends State<SellerProducts> {
  final SellerService sellerService = SellerService();
  List? productList = [];

  void getSellerProducts() async {
    try {
      String res = await sellerService.getSellerProducts(context);

      for (int item = 0; item < (jsonDecode(res)).length; item++) {
        productList!.add(jsonDecode(res)[item]);
      }
      setState(() {});
    } catch (e) {
      // showSnackBar(context, 'something went wrong');
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getSellerProducts();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    return productList == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              toolbarHeight: 80,
              titleSpacing: 0,
              automaticallyImplyLeading: false,
              elevation: 0,
              scrolledUnderElevation: 0,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Text(
                        "مرحباً ${user.profile.name}",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    ConstrainedBox(
                      constraints:
                          const BoxConstraints(maxWidth: 300, maxHeight: 120),
                      child: Image.asset(
                        "assets/images/elogo-full.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: teal,
              elevation: 2,
              onPressed: () {
                Navigator.pushNamed(context, AddProduct.routeName);
              },
              shape: const CircleBorder(),
              tooltip: 'Add New product',
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: productList!.isEmpty
                ? const Empty(
                    img: "assets/images/nop.png",
                    title: "ليس لديك أي منتجات",
                    subtitle: "ابدأ بإضافة المنتجات!",
                    btnText: "")
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 3 / 3.5),
                      itemCount: productList!.length,
                      itemBuilder: (context, index) {
                        var product = productList![index];
                        List<String> images = (product['img'] as List)
                            .map((img) => img.toString())
                            .toList();
                        return Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? const Color.fromARGB(255, 198, 199, 206)
                                  : ash,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(23))),
                          child: ListView(
                            children: [
                              SizedBox(
                                height: 180,
                                child: CarouselSlider(
                                  items: images.map((img) {
                                    return Container(
                                      height: 180,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(28),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                img,
                                              ),
                                              fit: BoxFit.fitHeight)),
                                    );
                                  }).toList(),
                                  options: CarouselOptions(viewportFraction: 1),
                                ),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    product['name'],
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          sellerService.deleteProduct(
                                              context: context,
                                              id: product['_id']);
                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.delete),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                              EditProduct.routeName,
                                              arguments: product);
                                        },
                                        icon: const Icon(Icons.edit),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          );
  }
}
