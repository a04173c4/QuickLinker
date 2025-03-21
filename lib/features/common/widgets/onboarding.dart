import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:quicklinker/features/auth/screens/signup.dart';
import 'package:quicklinker/theme.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});
  static const String routeName = '/onboarding';

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IntroductionScreen(
        key: introKey,
        pages: [
          PageViewModel(
            title: "أختر المنتجات",
            body: "تصفح آلاف المنتجات من بائعين موثوقين بكل سهولة. استخدم فلترات البحث الذكية لتجد ما يناسب ذوقك وميزانيتك في دقائق. سواء كنت تبحث عن أحدث الصيحات أو عروضًا حصرية، ستجد كل ما تحتاجه - وأكثر - في مكان واحد.",
            image: Image.asset('assets/images/onboarding1.png', height: 200),
            decoration: PageDecoration(
              titleTextStyle: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'OdinRounded',
                color: isDarkMode ? teal : black,
              ),
              bodyTextStyle: TextStyle(
                fontSize: 18,
                fontFamily: 'OdinRounded',
                color: isDarkMode ? Colors.white : Colors.black54,
              ),
            ),
          ),
          PageViewModel(
            title: "سهولة الدفع",
            body: "اختار طريقة الدفع المفضلة (بطاقات ائتمان، محافظ رقمية، الدفع عند الاستلام) واستمتع بمعاملات سريعة ومشفرة بأعلى معايير الأمان. لا داعي للقلق - بياناتك المالية تحت حماية مستمرة!",
            image: Image.asset('assets/images/onboarding2.png', height: 200),
            decoration: PageDecoration(
              titleTextStyle: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'OdinRounded',
                color: isDarkMode ? teal : black,
              ),
              bodyTextStyle: TextStyle(
                fontSize: 18,
                fontFamily: 'OdinRounded',
                color: isDarkMode ? Colors.white : Colors.black54,
              ),
            ),
          ),
          PageViewModel(
            title: "إسلتم طلبك",
            body: "استلم منتجاتك في الوقت والمكان الذي يناسبك: توصيل سريع، نقاط استلام، أو حتى توصيل فاخر. نوفر لك تحديثات مباشرة عن حالة الطلب ودعمًا فوريًا لضمان رضاك التام. وفر وقتك، نحن نتعامل مع الباقي!",
            image: Image.asset('assets/images/onboarding3.png', height: 200),
            decoration: PageDecoration(
              titleTextStyle: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'OdinRounded',
                color: isDarkMode ? teal : black,
              ),
              bodyTextStyle: TextStyle(
                fontSize: 18,
                fontFamily: 'OdinRounded',
                color: isDarkMode ? Colors.white : Colors.black54,
              ),
            ),
          ),
        ],
        showSkipButton: true,
        skip: Text(
          'تخطي',
          style: TextStyle(
            fontFamily: 'OdinRounded',
            color: isDarkMode ? Colors.white : black,
          ),
        ),
        next: const Text(
          'التالي',
          style: TextStyle(
            fontFamily: 'OdinRounded',
            color: Colors.white,
          ),
        ),
        done: const Text(
          'إبدأ الآن',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'OdinRounded',
            color: Colors.white,
          ),
        ),
        onDone: () => _navigateToSignup(),
        onSkip: () => _navigateToSignup(),
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: teal,
          color: Colors.grey,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0)
          ),
        ),
        globalBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        freeze: true,
        scrollPhysics: const BouncingScrollPhysics(),
      ),
    );
  }

  void _navigateToSignup() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      Signup.routeName,
      (route) => false,
    );
  }
}