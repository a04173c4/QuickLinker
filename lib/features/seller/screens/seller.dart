import 'package:QuickLinker/constants.dart';
import 'package:QuickLinker/features/home/screens/categories.dart';
import 'package:QuickLinker/features/products/screens/cart.dart';
import 'package:QuickLinker/features/profile/screens/account.dart';
import 'package:QuickLinker/features/seller/screens/seller_products.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:QuickLinker/features/wishlist/screens/wishlist.dart';
import 'package:badges/badges.dart' as badges;
import 'package:QuickLinker/providers/user_provider.dart';
import 'package:QuickLinker/theme.dart';
import 'package:provider/provider.dart';

class Seller extends StatefulWidget {
  const Seller({super.key});
  static const String routeName = '/seller';
  @override
  State<Seller> createState() => _SellerState();
}

class _SellerState extends State<Seller> {
  int _page = 0;
  double bottomNavBarWidth = 42;
  double bottomNavBarBorderWidth = 5;
  

  List<Widget> pages = [
    const SellerProducts(),
    const Categories(),
    const Wishlist(),
    const Cart(),
    const Account(),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }


  @override
  Widget build(BuildContext context) {

    bool light = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _page,
        backgroundColor: light ? Colors.white : Colors.grey[900], 
        iconSize: 28,
        onItemSelected: (index) => setState(() {
          _page = index;
        }),
        items: [
          FlashyTabBarItem(
            icon: const Icon(
                Icons.shopify,
                color: teal,
              ),
            title: Text('المنتجات', style: TextStyle(color: teal),),
          ),
          FlashyTabBarItem(
            icon: const Icon(
              Icons.grid_view,
              color: teal,
            ),
            title: Text('الفئات'),
          ),
          FlashyTabBarItem(
            icon: const Icon(
              Icons.favorite_border,
              color: teal,
            ),
            title: Text('المفضلة'),
          ),
          FlashyTabBarItem(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: teal,
            ),
            title: Text('السلة'),
          ),
          FlashyTabBarItem(
            icon: const Icon(
              Icons.person_outline_outlined,
              color: teal,
            ),
            title: Text('الإعدادات'),
          ),
        ],
      ),
    );
  }
}
