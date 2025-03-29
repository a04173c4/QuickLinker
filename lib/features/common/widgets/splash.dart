// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:QuickLinker/features/auth/services/auth_service.dart';
import 'package:QuickLinker/features/common/widgets/onboarding.dart';
import 'package:QuickLinker/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:QuickLinker/providers/user_provider.dart';
import 'package:QuickLinker/features/common/widgets/bottom_navbar.dart';
import 'package:QuickLinker/features/seller/screens/seller.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Wait for both 1-second delay and route determination
    final results = await Future.wait([
      _determineRoute(),
      Future.delayed(const Duration(seconds: 1)),
    ]);

    // Navigate to the determined route
    Navigator.of(context).pushNamedAndRemoveUntil(
      results[0] as String,
      (route) => false,
    );
  }

  Future<String> _determineRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('x-auth-token') ?? '';
    print("Auth token: $token");

    if (token.isEmpty) {
      print("No auth token found");
      return Onboarding.routeName;
    }

    try {
      await AuthService().getUserData(context);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      
      switch (userProvider.user.role) {
        case 'Buyer':
          return BottomNavBar.routeName;
        case 'Seller':
          print("User is a seller");
          return Seller.routeName;
        default:
          return Onboarding.routeName;
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return Onboarding.routeName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 1),
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Image.asset(
                      "assets/images/elogo.png",
                      fit: BoxFit.contain,
                      width: constraints.maxWidth * 0.3,
                    ),
                  ),
                ),
                const Spacer(flex: 1),
              ],
            ),
          );
        },
      ),
    );
  }
}
