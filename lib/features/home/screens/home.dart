import 'package:multivendorplatformmobile/constants.dart';
import 'package:multivendorplatformmobile/features/search/screens/search.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:multivendorplatformmobile/features/search/widgets/search_field.dart';
import 'package:multivendorplatformmobile/providers/user_provider.dart';
import 'package:multivendorplatformmobile/theme.dart';
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
  toolbarHeight: 80, // Reduced height for better density
  titleSpacing: 0, // Remove default title padding
  automaticallyImplyLeading: false, // Remove back arrow space
  elevation: 0,
  scrolledUnderElevation: 0,
  title: Container(
    padding: const EdgeInsets.symmetric(horizontal: 16), // Controlled padding
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        // Text with minimal padding
        Padding(
          padding: const EdgeInsets.only(right: 12), // Reduced right spacing
          child: Text(
            "مرحباً ${user.profile.name}",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        
        // Logo with tight constraints
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 300, // Reduced max width
            maxHeight: 120, // Height matching toolbar density
          ),
          child: Image.asset(
            "assets/images/elogo-full.png",
            fit: BoxFit.contain,
            alignment: Alignment.topCenter,
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
           padding:  EdgeInsets.all(12.0),
           child:  Text("المنتجات المميزة",style: TextStyle(fontSize: 24, fontFamily: 'OdinRounded',),),
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
                bottom: 14
                ,
                right: 18,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: white
                  ),
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
              style: TextStyle(fontSize: 20, fontFamily: 'OdinRounded',),
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
