import 'package:QuickLinker/features/auth/screens/login.dart';
import 'package:QuickLinker/features/auth/screens/signup.dart';
import 'package:QuickLinker/features/common/widgets/onboarding.dart';
import 'package:QuickLinker/features/orders/screens/orders.dart';
import 'package:QuickLinker/features/profile/screens/user_profile.dart';
import 'package:QuickLinker/features/search/screens/search_category_product.dart';
import 'package:QuickLinker/features/search/screens/search_seller_products.dart';
import 'package:QuickLinker/features/seller/screens/add_product.dart';
import 'package:QuickLinker/features/common/widgets/bottom_navbar.dart';
import 'package:QuickLinker/features/home/screens/home.dart';
import 'package:QuickLinker/features/home/screens/products_by_category.dart';
import 'package:QuickLinker/features/models/product.dart';
import 'package:QuickLinker/features/products/screens/product_details.dart';
import 'package:QuickLinker/features/search/screens/search.dart';
import 'package:flutter/material.dart';
import 'package:QuickLinker/features/seller/screens/edit_product.dart';
import 'package:QuickLinker/features/seller/screens/sales.dart';
import 'package:QuickLinker/features/seller/screens/seller.dart';
import 'package:QuickLinker/features/seller/screens/seller_products.dart';
import 'package:QuickLinker/features/seller/screens/seller_profile.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case Signup.routeName:
      return MaterialPageRoute(
          builder: (_) => const Signup(), settings: routeSettings);
    case Onboarding.routeName:
      return MaterialPageRoute(
          builder: (_) => const Onboarding(), settings: routeSettings);

    case Login.routeName:
      return MaterialPageRoute(
          builder: (_) => const Login(), settings: routeSettings);

    case Home.routeName:
      return MaterialPageRoute(
          builder: (_) => const Home(), settings: routeSettings);
    case BottomNavBar.routeName:
      return MaterialPageRoute(
          builder: (_) => const BottomNavBar(), settings: routeSettings);
    case AddProduct.routeName:
      return MaterialPageRoute(
          builder: (_) => const AddProduct(), settings: routeSettings);
    case ProductsByCategory.routeName:
      final args = routeSettings.arguments as Map<String, String>;
      return MaterialPageRoute(
          builder: (_) => ProductsByCategory(
                category: args['category'] ?? '',
              ),
          settings: routeSettings);
    case ProductDetails.routeName:
      final args = routeSettings.arguments as Product;
      return MaterialPageRoute(
          builder: (_) => ProductDetails(
                product: args,
              ),
          settings: routeSettings);
    case Search.routeName:
      final query = routeSettings.arguments as String;
      return MaterialPageRoute(
          builder: (_) => Search(
                query: query,
              ),
          settings: routeSettings);
    case Seller.routeName:
      return MaterialPageRoute(
          builder: (_) => const Seller(), settings: routeSettings);
    case SellerProducts.routeName:
      return MaterialPageRoute(
          builder: (_) => const SellerProducts(), settings: routeSettings);
    case UserProfile.routeName:
      return MaterialPageRoute(
          builder: (_) => const UserProfile(), settings: routeSettings);
    case SellerProfile.routeName:
      final sellerId = routeSettings.arguments as Map<String, String>;

      return MaterialPageRoute(
          builder: (_) => SellerProfile(
                sellerId: sellerId["sellerId"] ?? '',
              ),
          settings: routeSettings);
    case EditProduct.routeName:
      print("IN ROUTE SETTINGS RARGUMENTS");
      print(routeSettings.arguments);
      final product =
          Product.fromMap(routeSettings.arguments as Map<String, dynamic>);

      return MaterialPageRoute(
          builder: (_) => EditProduct(
                product: product,
              ),
          settings: routeSettings);
    case Orders.routeName:
      return MaterialPageRoute(
          builder: (_) => const Orders(), settings: routeSettings);
    case SearchCategoryProduct.routeName:
      final args = routeSettings.arguments as Map<String, String>;
      return MaterialPageRoute(
          builder: (_) => SearchCategoryProduct(
                query: args['query'] ?? '',
                category: args['category'] ?? '',
              ),
          settings: routeSettings);
    case SearchSellerProducts.routeName:
      final args = routeSettings.arguments as Map<String, String>;
      return MaterialPageRoute(
          builder: (_) => SearchSellerProducts(
                query: args['query'] ?? '',
                sellerId: args['sellerId'] ?? '',
              ),
          settings: routeSettings);
    case Sales.routeName:
      return MaterialPageRoute(
          builder: (_) => const Sales(), settings: routeSettings);
    default:
      print(routeSettings.name);

      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                  child: Builder(builder: (context) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                            builder: (context) {
                              return const Signup();
                            },
                          ), (route) => false);
                        },
                        child: const Text(
                            "الصفحة غير متوفرة، الذهاب لإنشاء حساب"));
                  }),
                ),
              ),
          settings: routeSettings);
  }
}
