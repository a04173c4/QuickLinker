import 'dart:io';

import 'package:QuickLinker/constants.dart';
import 'package:QuickLinker/features/models/product.dart';
import 'package:QuickLinker/features/seller/services/seller_service.dart';
import 'package:QuickLinker/features/common/widgets/input_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:QuickLinker/features/seller/widgets/select_colors.dart';
import 'package:QuickLinker/features/seller/widgets/select_sizes.dart';
import 'package:QuickLinker/theme.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({super.key, required this.product});
  static const String routeName = '/edit-product';
  final Product product;
  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final SellerService sellerService = SellerService();
  List<String> selectedSizes = [];
  String selectedtype = 'الكترونيات';
  List<File> selectedImages = [];
  List<String> selectedColors = [];

  @override
  void initState() {
    super.initState();
  }

  final editProductKey = GlobalKey<FormState>();
  void pickImages() async {
    final ImagePicker picker = ImagePicker();
    List<XFile>? pickedFiles = await picker.pickMultiImage();

    setState(() {
      selectedImages =
          pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
    });
  }

  void editProduct(name, price, description, stock, type) {
    if (selectedImages.isEmpty) {
      sellerService.editProduct(
          context: context,
          name: name,
          price: price.toDouble(),
          description: description,
          stock: stock,
          type: type,
          id: widget.product.id,
          selectedSizes:
              selectedSizes.isEmpty ? widget.product.sizes : selectedSizes,
          selectedColors:
              selectedColors.isEmpty ? widget.product.colors : selectedColors);
    } else {
      sellerService.editProduct(
          context: context,
          name: name,
          price: price,
          description: description,
          stock: stock,
          type: type,
          images: selectedImages,
          id: widget.product.id,
          selectedSizes:
              selectedSizes.isEmpty ? widget.product.sizes : selectedSizes,
          selectedColors:
              selectedColors.isEmpty ? widget.product.colors : selectedColors);
    }
    setState(() {});
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
    print(widget.product.sizes);
    print(widget.product.colors);
    print("doinwfewf");

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'تعديل ${widget.product.name}',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: editProductKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: () {
                  pickImages();
                },
                child: DottedBorder(
                  color: Theme.of(context).brightness == Brightness.light
                      ? black
                      : lightAsh,
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(10),
                  dashPattern: const [10, 4],
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
                  hintText: widget.product.name,
                  maxLines: 1),
              const SizedBox(
                height: 15,
              ),
              InputField(
                  controller: priceController,
                  hintText: widget.product.price.toString(),
                  maxLines: 1),
              const SizedBox(
                height: 15,
              ),
              InputField(
                  controller: descriptionController,
                  hintText: widget.product.desc,
                  maxLines: 7),
              const SizedBox(
                height: 15,
              ),
              InputField(
                controller: stockController,
                hintText: widget.product.stock.toString(),
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
                    value: 'الكترونيات',
                    child: Text('الكترونيات'),
                  ),
                  DropdownMenuItem(
                    value: 'موضة',
                    child: Text('موضة'),
                  ),
                  DropdownMenuItem(
                    value: 'منزل ومطبخ',
                    child: Text('منزل ومطبخ'),
                  ),
                  DropdownMenuItem(
                    value: 'صحة وعناية شخصية',
                    child: Text('صحة وعناية شخصية'),
                  ),
                  DropdownMenuItem(
                    value: 'كتب وقرطاسية',
                    child: Text('كتب وقرطاسية'),
                  ),
                  DropdownMenuItem(
                    value: 'رياضية',
                    child: Text('رياضية'),
                  ),
                  DropdownMenuItem(
                    value: 'العاب',
                    child: Text('العاب'),
                  ),
                  DropdownMenuItem(
                    value: 'تجميل ومستحضرات',
                    child: Text('تجميل ومستحضرات'),
                  ),
                  DropdownMenuItem(
                    value: 'سيارات',
                    child: Text('سيارات'),
                  ),
                  DropdownMenuItem(
                    value: 'مجوهرات واكسسوارات',
                    child: Text('مجوهرات واكسسوارات'),
                  ),
                  DropdownMenuItem(
                    value: 'بقالة وطعام',
                    child: Text('بقالة وطعام'),
                  ),
                  DropdownMenuItem(
                    value: 'منتجات اطفال',
                    child: Text('منتجات اطفال'),
                  ),
                  DropdownMenuItem(
                    value: 'مستلزمات حيوانات اليفة',
                    child: Text('مستلزمات حيوانات اليفة'),
                  ),
                  DropdownMenuItem(
                    value: 'ادوات وعدد',
                    child: Text('ادوات وعدد'),
                  ),
                  DropdownMenuItem(
                    value: 'قرطاسية مكتبية',
                    child: Text('قرطاسية مكتبية'),
                  ),
                  DropdownMenuItem(
                    value: 'الات موسيقية',
                    child: Text('الات موسيقية'),
                  ),
                  DropdownMenuItem(
                    value: 'اثاث',
                    child: Text('اثاث'),
                  ),
                  DropdownMenuItem(
                    value: 'فنون وحرف',
                    child: Text('فنون وحرف'),
                  ),
                  DropdownMenuItem(
                    value: 'صناعة وعلوم',
                    child: Text('صناعة وعلوم'),
                  ),
                  DropdownMenuItem(
                    value: 'العاب فيديو',
                    child: Text('العاب فيديو'),
                  ),
                  DropdownMenuItem(
                    value: 'موسيقى',
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
                  child: const Text("اختر المقاسات")),
              const SizedBox(
                height: 10,
              ),
              widget.product.sizes.isNotEmpty
                  ? const Text("المقاسات الحالية")
                  : const SizedBox.shrink(),
              widget.product.sizes.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: widget.product.sizes.map(
                        (size) {
                          print("SIZEEEE $size");
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
              selectedSizes.isNotEmpty
                  ? const Text("مقاسات مختارة جديدة")
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
              widget.product.sizes.isNotEmpty
                  ? const Text("الألوان الحالية")
                  : const SizedBox.shrink(),
              widget.product.colors.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: widget.product.colors.map(
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
              selectedColors.isNotEmpty
                  ? const Text("ألوان مختارة جديدة")
                  : const SizedBox.shrink(),
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
                  editProduct(
                    nameController.text.trim().isEmpty
                        ? widget.product.name
                        : nameController.text.trim(),
                    priceController.text.isEmpty
                        ? widget.product.price
                        : double.parse(priceController.text.trim().toString()),
                    descriptionController.text.trim().isEmpty
                        ? widget.product.desc
                        : descriptionController.text.trim(),
                    stockController.text.trim().isEmpty
                        ? widget.product.stock
                        : int.parse(stockController.text.trim()),
                    selectedtype,
                  );
                },
                child: Text(
                  'تعديل ${widget.product.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
