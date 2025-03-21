// ignore_for_file: use_build_context_synchronously

import 'package:quicklinker/features/common/widgets/bottom_navbar.dart';
import 'package:quicklinker/features/home/services/home_service.dart';
import 'package:quicklinker/features/models/product.dart';
import 'package:quicklinker/features/models/user.dart';
import 'package:quicklinker/features/products/screens/product_details.dart';
import 'package:flutter/material.dart';
import 'package:quicklinker/features/search/screens/search_category_product.dart';
import 'package:quicklinker/features/search/widgets/search_field.dart';
import 'package:quicklinker/features/search/widgets/searched_product.dart';
import 'package:quicklinker/features/seller/screens/seller.dart';
import 'package:quicklinker/providers/user_provider.dart';
import 'package:quicklinker/theme.dart';
import 'package:quicklinker/utils.dart';
import 'package:provider/provider.dart';

class ProductsByCategory extends StatefulWidget {
  static const String routeName = '/product-category';
  final String category;
  const ProductsByCategory({
    super.key,
    required this.category,
  });

  @override
  State<ProductsByCategory> createState() => _ProductsByCategoryState();
}

class _ProductsByCategoryState extends State<ProductsByCategory> {
  final HomeService homeService = HomeService();

  @override
  void initState() {
    super.initState();
    fetchCategoryProducts();
  }

  void navigateToSearch(String query) {
    Navigator.of(context).pushNamed(SearchCategoryProduct.routeName,
        arguments: {"query": query, "category": widget.category});
  }

  List<Product>? products;
  fetchCategoryProducts() async {
    try {
      products = await homeService.getProductsByCategory(
        context: context,
        category: widget.category,
      );
      print("gotten data?");
      print(products);

      setState(() {});
    } catch (e) {
      showSnackBar(context, 'لقد حدث خطأ ما');
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context, listen: false).user;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          title: Text(
            widget.category,
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  user.role == 'Seller'
                      ? Seller.routeName
                      : BottomNavBar.routeName, // Route name of the home screen
                  (route) => false, // Removes all previous routes
                );
              },
              child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: const Icon(Icons.home_outlined)),
            )
          ],
        ),
      ),
      body: products == null
          ? const Center(
              child: CircularProgressIndicator(
                color: teal,
              ),
            )
          : products!.isEmpty
              ? Center(
                  child: Text('لا يوجد منتج بفئة ${widget.category}'),
                )
              : Column(
                  children: [
                    SearchField(onFieldSubmitted: navigateToSearch),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.only(left: 15),
                        itemCount: products!.length,
                        itemBuilder: (context, index) {
                          print(products!.length);
                          print(products);
                          final product = products![index];
                          return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  ProductDetails.routeName,
                                  arguments: products![index],
                                );
                              },
                              child: SearchedProduct(product: product));
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
