import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:QuickLinker/features/auth/screens/login.dart';
import 'package:QuickLinker/features/auth/services/auth_service.dart';
import 'package:QuickLinker/theme.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});
  static const String routeName = '/signup';
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final signUpKey = GlobalKey<FormState>();

  final AuthService authService = AuthService();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String selectedValue = "Buyer";

  void signUp(BuildContext context) {
    authService.signUp(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      phone: phoneController.text.trim(),
      role: selectedValue,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    TapGestureRecognizer tapRecognizer = TapGestureRecognizer();
    tapRecognizer.onTap = () {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) {
            return const Login();
          },
        ),
        (route) => false,
      );
    };

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              "إنشاء حساب",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
            ),
            RichText(
              text: TextSpan(
                text: 'لديك حساب بالفعل؟ ',
                style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).brightness == Brightness.light
                        ? ash
                        : lightAsh),
                children: <TextSpan>[
                  TextSpan(
                      text: 'تسجيل الدخول',
                      style: const TextStyle(color: teal),
                      recognizer: tapRecognizer),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Form(
              key: signUpKey, // Add the key here
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'أدخل الايميل',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'من فضلك، أدخل الايميل';
                      }
                      return null; //means input has been validated
                    },
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'أدخل كلمة السر',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'من فضلك، أدخل كلمة السر';
                      }
                      return null; //means input has been validated
                    },
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'أدخل رقم هاتفك',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'من فضلك، ادخل رقم هاتفك';
                      }

                      return null; //means input has been validated
                    },
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  DropdownButtonFormField(
                    value: selectedValue,
                    items: const [
                      DropdownMenuItem(
                        value: "Buyer",
                        child: Text("مشتري"),
                      ),
                      DropdownMenuItem(value: "Seller", child: Text("بائع")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value!;
                      });
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  TextButton(
                    onPressed: () {
                      if (signUpKey.currentState!.validate()) {
                        print("ei???");
                        signUp(context);
                      }
                    },
                    child: const Text(
                      'إنشاء حساب',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
