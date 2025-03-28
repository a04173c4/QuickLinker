import 'package:QuickLinker/features/auth/services/auth_service.dart';
import 'package:QuickLinker/features/orders/screens/orders.dart';
import 'package:QuickLinker/features/profile/screens/user_profile.dart';
import 'package:QuickLinker/features/profile/widgets/profile_item.dart';
import 'package:QuickLinker/features/seller/screens/sales.dart';
import 'package:QuickLinker/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:QuickLinker/theme.dart';
import 'package:provider/provider.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    AuthService authService = AuthService();

    return Scaffold(
        backgroundColor: Colors.teal,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.teal,
            title: ListTile(
              contentPadding: const EdgeInsets.only(right: 8),
              leading: CircleAvatar(
                radius: 40,
                // backgroundImage: AssetImage(
                //   "assets/images/kylie2.jpeg",
                // ),
                backgroundImage: NetworkImage(user.profile.img),
              ),
              horizontalTitleGap: 0,
              title: Text(
                user.profile.name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                user.email,
                style: const TextStyle(
                  fontSize: 17,
                  fontFamily: 'OdinRounded',
                ),
              ),
              trailing: GestureDetector(
                  onTap: () {
                    authService.logOut(context);
                  },
                  child: Image.asset("assets/images/logout.png")),
            ),
            centerTitle: false,
          ),
        ),
        body: DraggableScrollableSheet(
          initialChildSize: 1,
          minChildSize: 1,
          maxChildSize: 1,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? white
                    : const Color.fromARGB(255, 18, 18, 19),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: const Text(
                        "المعلومات الشخصية",
                        style: TextStyle(
                          color: lightAsh,
                          fontSize: 19,
                          fontFamily: 'OdinRounded',
                        ),
                      ),
                    ),
                    ProfileItem(
                      icon: Icons.edit,
                      title: "تعديل الملف الشخصي",
                      onTap: () {
                        Navigator.of(context).pushNamed(UserProfile.routeName);
                      },
                      imgUrl: null,
                    ),
                    ProfileItem(
                      icon: null,
                      title: "سجل الطلب",
                      onTap: () {
                        Navigator.of(context).pushNamed(Orders.routeName);
                      },
                      imgUrl: 'assets/images/receipt-edit.png',
                    ),
                    user.role == 'Seller'
                        ? ProfileItem(
                            icon: null,
                            title: "المبيعات",
                            onTap: () {
                              Navigator.of(context).pushNamed(Sales.routeName);
                            },
                            imgUrl: 'assets/images/receipt-edit.png',
                          )
                        : const SizedBox.shrink(),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: const Text(
                        "الدعم والمعلومات",
                        style: TextStyle(
                          color: lightAsh,
                          fontSize: 19,
                          fontFamily: 'OdinRounded',
                        ),
                      ),
                    ),
                    ProfileItem(
                      icon: null,
                      title: "سياسة الخصوصية",
                      onTap: () {},
                      imgUrl: 'assets/images/shield-tick.png',
                    ),
                    ProfileItem(
                      icon: null,
                      title: "الشروط والأحكام",
                      onTap: () {},
                      imgUrl: 'assets/images/document-text.png',
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
