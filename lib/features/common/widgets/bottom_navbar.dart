import 'package:QuickLinker/constants.dart';
import 'package:QuickLinker/features/home/screens/categories.dart';
import 'package:QuickLinker/features/home/screens/home.dart';
import 'package:QuickLinker/features/products/screens/cart.dart';
import 'package:QuickLinker/features/profile/screens/account.dart';
import 'package:QuickLinker/features/wishlist/screens/wishlist.dart';
import 'package:QuickLinker/providers/user_provider.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';

import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:QuickLinker/theme.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  static const String routeName = '/nav';
  const BottomNavBar({super.key});
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;
  double bottomNavBarWidth = 42;
  double bottomNavBarBorderWidth = 5;

  List<Widget> pages = [
    const Home(),
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
              Icons.home_outlined,
              color: teal,
            ),
            title: Text('الرئيسية', style: TextStyle(color: teal),),
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
