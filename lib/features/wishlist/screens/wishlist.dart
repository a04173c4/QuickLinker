import 'package:multivendorplatformmobile/features/common/widgets/empty.dart';
import 'package:multivendorplatformmobile/features/search/screens/search.dart';
import 'package:multivendorplatformmobile/features/wishlist/widgets/wishlist_item.dart';
import 'package:multivendorplatformmobile/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  int quantity = 1;
  void navigateToSearch(String query) {
    Navigator.pushNamed(context, Search.routeName, arguments: query);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      appBar: AppBar(
        title: Text("قائمة رغبات ${user.profile.name}",overflow: TextOverflow.ellipsis,maxLines: 1,),
      ),
      body: Column(
        mainAxisAlignment: user.wishlist.isEmpty
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          user.wishlist.isEmpty
              ? const Empty(
                  img: "assets/images/ewish.png",
                  title: "قائمة أمنياتك فارغة",
                  subtitle:
                      "يبدو أنك لم تُضِف أي شيء إلى قائمة أمنياتك. تفضل باستكشاف أفضل الفئات.",
                  btnText: "تصفح الفئات")
              : ListView.builder(
                  itemCount: user.wishlist.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    
                    return WishlistItem(
                      item: user.wishlist[index]
                    );
                  },
                ),
        ],
      ),
    );
  }
}
