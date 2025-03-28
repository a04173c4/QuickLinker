import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:QuickLinker/features/auth/screens/signup.dart';
import 'package:QuickLinker/features/auth/services/auth_service.dart';
import 'package:QuickLinker/theme.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  static const String routeName = '/login';
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final loginKey = GlobalKey<FormState>();

  final AuthService authService = AuthService();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String selectedValue = "Buyer";

  void login(BuildContext context) {
    authService.login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
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
            return const Signup();
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
              "تسجيل الدخول",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
            ),
            RichText(
              text: TextSpan(
                text: "ليس لديك حساب؟ ",
                style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).brightness == Brightness.light
                        ? ash
                        : lightAsh),
                children: <TextSpan>[
                  TextSpan(
                      text: 'إنشاء حساب',
                      style: const TextStyle(color: teal),
                      recognizer: tapRecognizer),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Form(
              key: loginKey, // Add the key here
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'ادخل ايميلك',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'من فضلك، أدخل ايميلك';
                      }
                      return null; //means input has been validated
                    },
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'أدخل كلمة المرور الخاصة بك',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'من فضلك، أدخل كلمة المرور الخاصة بك';
                      }
                      return null; //means input has been validated
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  TextButton(
                    onPressed: () {
                      if (loginKey.currentState!.validate()) {
                        // signUp(context);
                        login(context);
                      }
                    },
                    child: const Text(
                      'تسجيل الدخول',
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
