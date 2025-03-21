import 'dart:io';

import 'package:quicklinker/constants.dart';
import 'package:quicklinker/features/seller/services/seller_service.dart';
import 'package:quicklinker/features/common/widgets/input_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quicklinker/features/seller/widgets/select_colors.dart';
import 'package:quicklinker/features/seller/widgets/select_sizes.dart';
import 'package:quicklinker/theme.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});
  static const String routeName = '/add-product';

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final SellerService sellerService = SellerService();
  List<String> selectedSizes = [];
  List<String> selectedColors = [];

  String selectedtype = 'Electronics';
  List<File> selectedImages = [];
  bool isLoading = false;
  final addProductKey = GlobalKey<FormState>();
  void pickImages() async {
    final ImagePicker picker = ImagePicker();
    List<XFile>? pickedFiles = await picker.pickMultiImage();

    setState(() {
      selectedImages =
          pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
    });
  }

  void showSizesDialog() async {
    List<String>? sizesSelected = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const SelectSizes(items: sizes);
      },
    );

    setState(() {
      selectedSizes = sizesSelected!;
    });
  }

  void showColorsDialog() async {
    List<String>? colorsSelected = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const SelectColors(items: colors);
      },
    );

    setState(() {
      selectedColors = colorsSelected!;
    });
  }

  void addNewProduct(
    name,
    description,
    image,
    type,
    stock,
    price,
  ) {
    sellerService.addNewProduct(
        context: context,
        name: name,
        price: price,
        description: description,
        stock: stock,
        type: type,
        images: image,
        selectedColors: selectedColors,
        selectedSizes: selectedSizes);
    print("SELECTED SIZES $selectedSizes $selectedColors");
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'إضافة منتج',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: addProductKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: () {
                  pickImages();
                },
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(10),
                  dashPattern: const [10, 4],
                  color: Theme.of(context).brightness == Brightness.light
                      ? black
                      : lightAsh,
                  child: Center(
                    child: SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: selectedImages.isEmpty
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.folder_open,
                                  size: 45,
                                ),
                                Text(
                                  'اختر صور المنتج الجديد',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            )
                          :
                          //in case you pick one image though make sure it fills the screen
                          selectedImages.length == 1
                              ? Image.file(
                                  selectedImages[0],
                                  // fit: BoxFit.cover,
                                )
                              : GridView.builder(
                                  itemCount: selectedImages.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5,
                                  ),
                                  itemBuilder: (context, index) {
                                    return Image.file(
                                      selectedImages[index],
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              InputField(
                  controller: nameController,
                  hintText: 'Enter product name',
                  maxLines: 1),
              const SizedBox(
                height: 15,
              ),
              InputField(
                  controller: priceController,
                  hintText: 'Enter product price',
                  maxLines: 1),
              const SizedBox(
                height: 15,
              ),
              InputField(
                  controller: descriptionController,
                  hintText: 'Enter product description',
                  maxLines: 7),
              const SizedBox(
                height: 15,
              ),
              InputField(
                controller: stockController,
                hintText: 'Enter product stock',
                maxLines: 1,
              ),
              const SizedBox(
                height: 15,
              ),
              DropdownButton(
                value: selectedtype,
                hint: const Text('أختر نوع المنتج'),
                items: const [
                  DropdownMenuItem(
                    value: 'Electronics',
                    child: Text('الكترونيات'),
                  ),
                  DropdownMenuItem(
                    value: 'Fashion',
                    child: Text('موضة'),
                  ),
                  DropdownMenuItem(
                    value: 'Home and Kitchen',
                    child: Text('أدوات منزلية والمطبخ'),
                  ),
                  DropdownMenuItem(
                    value: 'Health and Personal Care',
                    child: Text('الصحة والعناية الشخصية'),
                  ),
                  DropdownMenuItem(
                    value: 'Books and Stationery',
                    child: Text('الكتب والقرطاسية'),
                  ),
                  DropdownMenuItem(
                    value: 'Sports and Outdoors',
                    child: Text('رياضية'),
                  ),
                  DropdownMenuItem(
                    value: 'Toys and Games',
                    child: Text('ألعاب'),
                  ),
                  DropdownMenuItem(
                    value: 'Beauty and Cosmetics',
                    child: Text('الجمال ومستحضرات التجميل'),
                  ),
                  DropdownMenuItem(
                    value: 'Automotive',
                    child: Text('السيارات'),
                  ),
                  DropdownMenuItem(
                    value: 'Jewelry and Accessories',
                    child: Text('المجوهرات والإكسسوارات'),
                  ),
                  DropdownMenuItem(
                    value: 'Groceries and Food',
                    child: Text('البقالة والطعام'),
                  ),
                  DropdownMenuItem(
                    value: 'Baby Products',
                    child: Text('منتجات أطفال'),
                  ),
                  DropdownMenuItem(
                    value: 'Pet Supplies',
                    child: Text('مستلزمات الحيوانات الأليفة'),
                  ),
                  DropdownMenuItem(
                    value: 'Tools and Hardware',
                    child: Text('الأدوات والأجهزة'),
                  ),
                  DropdownMenuItem(
                    value: 'Office Supplies',
                    child: Text('اللوازم المكتبية'),
                  ),
                  DropdownMenuItem(
                    value: 'Musical Instruments',
                    child: Text('الآلات الموسيقية'),
                  ),
                  DropdownMenuItem(
                    value: 'Furniture',
                    child: Text('أثاث'),
                  ),
                  DropdownMenuItem(
                    value: 'Art and Craft',
                    child: Text('الفنون والحرف اليدوية'),
                  ),
                  DropdownMenuItem(
                    value: 'Industrial and Scientific',
                    child: Text('الصناعية والعلمية'),
                  ),
                  DropdownMenuItem(
                    value: 'Video Games and Consoles',
                    child: Text('ألعاب الفيديو وأجهزة التحكم'),
                  ),
                  DropdownMenuItem(
                    value: 'Music',
                    child: Text('موسيقى'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedtype = value!;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const Text("ينطبق فقط إذا كان منتجك يحتوي على أحجام"),
              TextButton(
                  onPressed: () {
                    showSizesDialog();
                  },
                  child: const Text("أختر المقاسات")),
              const SizedBox(
                height: 10,
              ),
              selectedSizes.isNotEmpty
                  ? const Text("المقاسات المختارة")
                  : const SizedBox.shrink(),
              selectedSizes.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: selectedSizes.map(
                        (size) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              // padding: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(color: ash),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(sizeMapping[size]!),
                            ),
                          );
                        },
                      ).toList()))
                  : const SizedBox.shrink(),
              const SizedBox(
                height: 10,
              ),
              const Text("ينطبق فقط إذا كان منتجك يحتوي على ألوان"),
              TextButton(
                  onPressed: () {
                    showColorsDialog();
                  },
                  child: const Text("الألوان المختارة")),
              const SizedBox(
                height: 10,
              ),
              selectedColors.isNotEmpty
                  ? const Text("الألوان المختارة")
                  : const SizedBox.shrink(),
              selectedColors.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: selectedColors.map(
                        (color) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  height: 37,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colorDictionary
                                            .containsKey(color.toLowerCase())
                                        ? colorDictionary[color.toLowerCase()]
                                        : white,
                                  ),
                                  child: const Center(child: Text("")),
                                ),
                                Text(color)
                              ],
                            ),
                          );
                        },
                      ).toList()))
                  : const SizedBox.shrink(),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  //images not a form field so check for that as well
                  if (addProductKey.currentState!.validate() &&
                      selectedImages.isNotEmpty) {
                    isLoading = true;
                    setState(() {});
                    addNewProduct(
                      nameController.text.trim(),
                      descriptionController.text.trim(),
                      selectedImages,
                      selectedtype,
                      int.parse(stockController.text.trim()),
                      double.parse(priceController.text.trim()),
                    );
                  }
                },
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : const Text('اضافة المنتج'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
