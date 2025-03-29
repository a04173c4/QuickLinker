import 'package:flutter/material.dart';

// String uri = 'http://<your ip address>:3000';
// String uri = 'https://multivendorapp-user-service.onrender.com';

String uri = "http://127.0.0.1:8001";
String productsUri = 'http://127.0.0.1:8002';
String shoppingUri = 'http://127.0.0.1:8003';

class OnboardingContent {
  String image;
  String title;
  String description;

  OnboardingContent(
      {required this.image, required this.title, required this.description});
}

const Map<String, Color> colorDictionary = {
  "اسود": Colors.black,
  "ابيض": Colors.white,
  "احمر": Colors.red,
  "اخضر": Colors.green,
  "ازرق": Colors.blue,
  "اصفر": Colors.yellow,
  "برتقالي": Colors.orange,
  "وردي": Colors.pink,
  "بنفسجي": Colors.purple,
  "رمادي": Colors.grey,
  "بني": Colors.brown,
  "سماوي": Colors.cyan,
  "كهرماني": Colors.amber,
  "نيلي": Colors.indigo,
  "ازرق مخضر": Color(0xFF008080),
  "ليموني": Colors.lime,
  "برتقالي غامق": Colors.deepOrange,
  "بنفسجي غامق": Colors.deepPurple,
  "ازرق فاتح": Colors.lightBlue,
  "اخضر فاتح": Colors.lightGreen,
  "ازرق رمادي": Colors.blueGrey,
};
Map<String, String> sizeMapping = {
  "US 1 / UK 13 / EU 29": "UK 13",
  "US 1.5 / UK 13.5 / EU 30": "UK 13.5",
  "US 2 / UK 1 / EU 31": "UK 1",
  "US 2.5 / UK 1.5 / EU 31.5": "UK 1.5",
  "US 3 / UK 2 / EU 32": "UK 2",
  "US 3.5 / UK 2.5 / EU 33": "UK 2.5",
  "US 4 / UK 3 / EU 34": "UK 3",
  "US 4.5 / UK 3.5 / EU 35": "UK 3.5",
  "US 5 / UK 3 / EU 36": "UK 3",
  "US 5.5 / UK 3.5 / EU 36.5": "UK 3.5",
  "US 6 / UK 4 / EU 37": "UK 4",
  "US 6.5 / UK 4.5 / EU 37.5": "UK 4.5",
  "US 7 / UK 5 / EU 38": "UK 5",
  "US 7.5 / UK 5.5 / EU 38.5": "UK 5.5",
  "US 8 / UK 6 / EU 39": "UK 6",
  "US 8.5 / UK 6.5 / EU 40": "UK 6.5",
  "US 9 / UK 7 / EU 40.5": "UK 7",
  "US 9.5 / UK 7.5 / EU 41": "UK 7.5",
  "US 10 / UK 8 / EU 42": "UK 8",
  "US 10.5 / UK 8.5 / EU 42.5": "UK 8.5",
  "US 11 / UK 9 / EU 43": "UK 9",
  "US 11.5 / UK 9.5 / EU 44": "UK 9.5",
  "US 12 / UK 10 / EU 44.5": "UK 10",
  "US 13 / UK 11 / EU 46": "UK 11",
  "XS": "UK XS",
  "S": "UK S",
  "M": "UK M",
  "L": "UK L",
  "XL": "UK XL",
  "XXL": "UK XXL"
};
const List<String> colors = [
  "احمر",
  "ازرق",
  "اخضر",
  "اصفر",
  "برتقالي",
  "بنفسجي",
  "وردي",
  "اسود",
  "ابيض",
  "رمادي",
  "بني",
  "سماوي",
  "ارجواني",
];
const List<String> sizes = [
  "US 1 / UK 13 / EU 29",
  "US 1.5 / UK 13.5 / EU 30",
  "US 2 / UK 1 / EU 31",
  "US 2.5 / UK 1.5 / EU 31.5",
  "US 3 / UK 2 / EU 32",
  "US 3.5 / UK 2.5 / EU 33",
  "US 4 / UK 3 / EU 34",
  "US 4.5 / UK 3.5 / EU 35",
  "US 5 / UK 3 / EU 36",
  "US 5.5 / UK 3.5 / EU 36.5",
  "US 6 / UK 4 / EU 37",
  "US 6.5 / UK 4.5 / EU 37.5",
  "US 7 / UK 5 / EU 38",
  "US 7.5 / UK 5.5 / EU 38.5",
  "US 8 / UK 6 / EU 39",
  "US 8.5 / UK 6.5 / EU 40",
  "US 9 / UK 7 / EU 40.5",
  "US 9.5 / UK 7.5 / EU 41",
  "US 10 / UK 8 / EU 42",
  "US 10.5 / UK 8.5 / EU 42.5",
  "US 11 / UK 9 / EU 43",
  "US 11.5 / UK 9.5 / EU 44",
  "US 12 / UK 10 / EU 44.5",
  "US 13 / UK 11 / EU 46",
  "XS",
  "S",
  "M",
  "L",
  "XL",
  "XXL",
];

const List<Map<String, String>> productCategories = [
  {"title": "الكترونيات", "img": "assets/images/electronics.png"},
  {"title": "رياضة ", "img": "assets/images/sports.png"},
  {"title": "مجوهرات واكسسوارات", "img": "assets/images/jewell.webp"},
  {"title": "تجميل ومستحضرات", "img": "assets/images/kylie.png"},
  {"title": "الات موسيقية", "img": "assets/images/piano.jpg"},
  {"title": "صناعة وعلوم", "img": "assets/images/sc.jpg"},
  {"title": "منزل ومطبخ", "img": "assets/images/vase.png"},
  {"title": "صحة ورعاية شخصية", "img": "assets/images/health.webp"},
  {"title": "اثاث", "img": "assets/images/bed.png"},
  {"title": "موضة", "img": "assets/images/fashion.jpg"},
  {"title": "كتب وقرطاسية", "img": "assets/images/books.jpg"},
  {"title": "العاب", "img": "assets/images/games.webp"},
  {"title": "سيارات", "img": "assets/images/automotive.webp"},
  {"title": "بقالة وطعام", "img": "assets/images/groc.webp"},
  {"title": "منتجات اطفال", "img": "assets/images/sports.png"},
  {"title": "مستلزمات حيوانات اليفة", "img": "assets/images/pet.jpg"},
  {"title": "ادوات وعدد", "img": "assets/images/tools.jpg"},
  {"title": "قرطاسية مكتبية", "img": "assets/images/office.jpg"},
  {"title": "فنون وحرف", "img": "assets/images/arts.webp"},
  {"title": "العاب فيديو", "img": "assets/images/ps5.jpg"},
  {"title": "موسيقى", "img": "assets/images/music.png"},
];
const appBarGradient = LinearGradient(
  colors: [
    Color.fromARGB(255, 29, 201, 192),
    Color.fromARGB(255, 125, 221, 216),
  ],
  // stops: [0.5, 1.0],
);

const secondaryColor = Color.fromRGBO(255, 153, 0, 1);
const backgroundColor = Colors.white;
const Color greyBackgroundCOlor = Color(0xffebecee);
var selectedNavBarColor = Colors.cyan[800]!;
const unselectedNavBarColor = Colors.black87;

const List<String> carouselImages = [
  'https://images-eu.ssl-images-amazon.com/images/G/31/img21/Wireless/WLA/TS/D37847648_Accessories_savingdays_Jan22_Cat_PC_1500.jpg',
  'https://images-eu.ssl-images-amazon.com/images/G/31/img2021/Vday/bwl/English.jpg',
  'https://images-eu.ssl-images-amazon.com/images/G/31/img22/Wireless/AdvantagePrime/BAU/14thJan/D37196025_IN_WL_AdvantageJustforPrime_Jan_Mob_ingress-banner_1242x450.jpg',
  'https://images-na.ssl-images-amazأon.com/images/G/31/Symbol/2020/00NEW/1242_450Banners/PL31_copy._CB432483346_.jpg',
  'https://images-na.ssl-images-amazon.com/images/G/31/img21/shoes/September/SSW/pc-header._CB641971330_.jpg',
];

const List<Map<String, String>> categoryImages = [
  {
    'title': 'هواتف',
    'image': 'assets/images/mobiles.jpeg',
  },
  {
    'title': 'اساسيات',
    'image': 'assets/images/essentials.jpeg',
  },
  {
    'title': 'اجهزة',
    'image': 'assets/images/appliances.jpeg',
  },
  {
    'title': 'كتب',
    'image': 'assets/images/books.jpeg',
  },
  {
    'title': 'موضة',
    'image': 'assets/images/fashion.jpeg',
  },
];
