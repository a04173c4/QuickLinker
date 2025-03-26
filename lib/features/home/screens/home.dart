import 'package:QuickLinker/constants.dart';
import 'package:QuickLinker/features/search/screens/search.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:QuickLinker/features/search/widgets/search_field.dart';
import 'package:QuickLinker/providers/user_provider.dart';
import 'package:QuickLinker/theme.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const String routeName = '/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void navigateToSearch(String query) {
    Navigator.of(context).pushNamed(Search.routeName, arguments: query);
  }

  int carouselNumber = 0;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
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
      body: ListView(
        children: [
          SearchField(onFieldSubmitted: navigateToSearch),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              "المنتجات المميزة",
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'OdinRounded',
              ),
            ),
          ),
          Stack(
            children: [
              CarouselSlider(
                items: carouselImages.map((img) {
                  return Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                img,
                              ),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(18)),
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                    // autoPlay: true,
                    height: 350,
                    // autoPlayInterval: Duration(seconds: 1),
                    viewportFraction: 0.98,
                    onPageChanged: (index, reason) {
                      setState(() {
                        carouselNumber = index;
                      });
                    }),
              ),
              Positioned(
                bottom: 14,
                right: 18,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: white),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < carouselImages.length; i++)
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: carouselNumber == i ? teal : lightAsh),
                              height: 10,
                              width: 10,
                            ),
                          ),
                      ]),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.topRight,
            padding: const EdgeInsets.all(9),
            child: const Text(
              'أفضل المنتجات',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'OdinRounded',
              ),
            ),
          ),
          CarouselSlider(
            items: carouselImages.map((img) {
              return Padding(
                padding: const EdgeInsets.all(9.0),
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                            img,
                          ),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(18)),
                ),
              );
            }).toList(),
            options: CarouselOptions(
                // autoPlay: true,
                // autoPlayInterval: Duration(seconds: 1),
                viewportFraction: 0.98,
                onPageChanged: (index, reason) {
                  setState(() {
                    carouselNumber = index;
                  });
                }),
          ),
        ],
      ),
    );
  }
}
