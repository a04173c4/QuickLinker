// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:QuickLinker/features/common/widgets/bottom_navbar.dart';
import 'package:QuickLinker/features/models/product.dart';
import 'package:QuickLinker/features/models/profile.dart';
import 'package:QuickLinker/features/products/screens/product_details.dart';
import 'package:QuickLinker/features/products/services/product_details_service.dart';
import 'package:QuickLinker/features/search/screens/search_seller_products.dart';
import 'package:QuickLinker/features/search/widgets/search_field.dart';
import 'package:QuickLinker/features/search/widgets/searched_product.dart';
import 'package:QuickLinker/features/seller/screens/seller.dart';
import 'package:QuickLinker/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SellerProfile extends StatefulWidget {
  const SellerProfile({super.key, required this.sellerId});
  final String sellerId;
  static const String routeName = '/view-seller-profile';
  @override
  State<SellerProfile> createState() => _SellerProfileState();
}

class _SellerProfileState extends State<SellerProfile> {
  ProductDetailsService productDetailsService = ProductDetailsService();
  List<Product>? products;
  Profile? sellerProfile;
  @override
  void initState() {
    // TODO: implement initState
    print("in seller profile init state");
    super.initState();

    gg();
    print("it work????");
  }

  getSellerDetails() async {
    products =
        await productDetailsService.getSellerProducts(context, widget.sellerId);
    print("got profucts?");
    print(products![0].desc);

    sellerProfile =
        await productDetailsService.getSellerProfile(widget.sellerId, context);
    print("got seller profile?");
    print(sellerProfile!.name);
    setState(() {});
  }

  gg() async {
    await getSellerDetails();
  }

  void navigateToSearch(String query) {
    Navigator.of(context).pushNamed(SearchSellerProducts.routeName,
        arguments: {"query": query, "sellerId": widget.sellerId});
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return sellerProfile == null || products == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: ListTile(
                trailing: SizedBox(
                  child: ClipOval(
                    child: Image.network(sellerProfile!.img),
                  ),
                ),
                title: Text(
                  "منتجات ${sellerProfile!.name} ",
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'OdinRounded',
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      userProvider.user.role == 'Seller'
                          ? Seller.routeName
                          : BottomNavBar
                              .routeName, // Route name of the home screen
                      (route) => false, // Removes all previous routes
                    );
                  },
                  child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: const Icon(Icons.home_outlined)),
                )
              ],
            ),
            body: sellerProfile == null || products == null
                ? const Center(
                    child: Text('لقد حدث خطأ ما'),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Text(
                          "معلومات عنا: ${sellerProfile!.about}",
                          style: const TextStyle(
                            fontSize: 19,
                            fontFamily: 'OdinRounded',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Text(
                            "الموقع: ${sellerProfile!.street},${sellerProfile!.country} "),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Text("العنوان: ${sellerProfile!.postalCode} "),
                      ),
                      SearchField(onFieldSubmitted: navigateToSearch),
                      Expanded(
                          child: ListView.builder(
                        itemCount: products!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  ProductDetails.routeName,
                                  arguments: products![index]);
                            },
                            // child: Container(
                            //   margin: const EdgeInsets.symmetric(
                            //       horizontal: 9, vertical: 9),
                            //   padding: const EdgeInsets.all(18),
                            //   color: Colors.grey,
                            //   child: Column(
                            //     children: [
                            //       Text(products![index].name),
                            //       Text(products![index].desc),
                            //     ],
                            //   ),
                            // ),
                            child: SearchedProduct(product: products![index]),
                          );
                        },
                      ))
                    ],
                  ),
          );
  }
}
