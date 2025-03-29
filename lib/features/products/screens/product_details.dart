// ignore_for_file: avoid_print
import 'package:carousel_slider/carousel_slider.dart';
import 'package:QuickLinker/constants.dart';
import 'package:QuickLinker/features/models/product.dart';
import 'package:QuickLinker/features/products/services/product_details_service.dart';
import 'package:flutter/material.dart';
import 'package:QuickLinker/features/products/widgets/dialogs/cart_colors_exceeded.dart';
import 'package:QuickLinker/features/products/widgets/dialogs/cart_sizes_exceeded.dart';
import 'package:QuickLinker/features/products/widgets/dialogs/select_colors_dialog.dart';
import 'package:QuickLinker/features/products/widgets/dialogs/select_sizes_dialog.dart';
import 'package:QuickLinker/features/seller/screens/seller_profile.dart';
import 'package:QuickLinker/features/wishlist/services/wishlist_service.dart';
import 'package:QuickLinker/theme.dart';
import 'package:QuickLinker/utils.dart';

class ProductDetails extends StatefulWidget {
  static const String routeName = '/product-details';
  final Product product;
  const ProductDetails({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final ProductDetailsService productDetailsService = ProductDetailsService();
  final WishlistService wishlistService = WishlistService();

  List<String> selectedColors = [];
  List<String> selectedSizes = [];
  Map<String, int> selectedColorsDict = {};
  Map<String, int> selectedSizessDict = {};

  int quantity = 1;
  bool isReadMore = false;

  @override
  void initState() {
    super.initState();
  }

  void incrementQuantity() {
    if (quantity >= widget.product.stock) {
      //show some dialog
      return;
    }

    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    if (quantity <= 1) {
      return;
    }
    setState(() {
      quantity--;
    });
  }

  void addToCart() {
  print('🐛 [addToCart] Starting addToCart function');
  print('🖼️ [addToCart] Product image URLs: ${widget.product.img}');
  print('🧮 [addToCart] Initial quantity: $quantity');
  print('🎨 [addToCart] Selected colors: $selectedColors');
  print('📏 [addToCart] Selected sizes: $selectedSizes');

  try {
    if (widget.product.sizes.isEmpty && widget.product.colors.isEmpty) {
      print('🚀 [addToCart] Case 1: No sizes/colors - direct add');
      productDetailsService.editCart(
        context: context,
        product: widget.product.copyWith(img: widget.product.img), // Ensure img is passed
        amount: quantity,
      );
    } else if (widget.product.sizes.isNotEmpty && widget.product.colors.isEmpty) {
      print('🔍 [addToCart] Case 2: Size selection required');
      if (quantity == selectedSizes.length) {
        print('✅ [addToCart] Sizes match quantity - proceeding');
        productDetailsService.editCart(
          context: context,
          product: widget.product.copyWith(img: widget.product.img),
          amount: quantity,
          selectedSizes: selectedSizes,
        );
      } else {
        print('⚠️ [addToCart] Size quantity mismatch - showing dialog');
        showDialog(context: context, builder: (_) => const SelectSizesDialog());
      }
    } else if (widget.product.sizes.isEmpty && widget.product.colors.isNotEmpty) {
      print('🎨 [addToCart] Case 3: Color selection required');
      if (quantity == selectedColors.length) {
        print('✅ [addToCart] Colors match quantity - proceeding');
        productDetailsService.editCart(
          context: context,
          product: widget.product.copyWith(img: widget.product.img),
          amount: quantity,
          selectedColors: selectedColors,
        );
      } else {
        print('⚠️ [addToCart] Color quantity mismatch - showing dialog');
        showDialog(context: context, builder: (_) => const SelectColorsDialog());
      }
    } else {
      print('📏🎨 [addToCart] Case 4: Both sizes/colors required');
      if (quantity == selectedColors.length && quantity == selectedSizes.length) {
        print('✅ [addToCart] Both selections valid - proceeding');
        productDetailsService.editCart(
          context: context,
          product: widget.product.copyWith(img: widget.product.img),
          amount: quantity,
          selectedColors: selectedColors,
          selectedSizes: selectedSizes,
        );
      } else {
        print('⚠️ [addToCart] Selection mismatch - showing dialogs');
        if (quantity != selectedColors.length) {
          showDialog(context: context, builder: (_) => const SelectColorsDialog());
        }
        if (quantity != selectedSizes.length) {
          showDialog(context: context, builder: (_) => const SelectSizesDialog());
        }
      }
    }
    print('✅ [addToCart] Add to cart flow completed successfully');
  } catch (e, stack) {
    print('❌ [addToCart] Error in addToCart: $e');
    print('🔍 [addToCart] Stack trace: $stack');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to add to cart: ${e.toString()}')),
    );
  }
}

  void addToWishlist() {
    print("adding to wishlist");

    if (widget.product.sizes.isEmpty && widget.product.colors.isEmpty) {
      wishlistService.editWishlist(
          context: context, product: widget.product, amount: quantity);
    } else if (widget.product.sizes.isNotEmpty &&
        widget.product.colors.isEmpty) {
      if (quantity == selectedSizes.length) {
        wishlistService.editWishlist(
            context: context,
            product: widget.product,
            amount: quantity,
            selectedSizes: selectedSizes);
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return const SelectSizesDialog();
          },
        );
      }
    } else if (widget.product.sizes.isEmpty &&
        widget.product.colors.isNotEmpty) {
      if (quantity == selectedColors.length) {
        wishlistService.editWishlist(
            context: context,
            product: widget.product,
            amount: quantity,
            selectedColors: selectedColors);
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return const SelectColorsDialog();
          },
        );
      }
    } else {
      if (quantity == selectedColors.length &&
          quantity == selectedSizes.length) {
        wishlistService.editWishlist(
            context: context,
            product: widget.product,
            amount: quantity,
            selectedColors: selectedColors,
            selectedSizes: selectedSizes);
      } else if (quantity == selectedColors.length) {
        showDialog(
          context: context,
          builder: (context) {
            return const SelectSizesDialog();
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return const SelectColorsDialog();
          },
        );
      }
    }
  }

  TextEditingController amountController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: widget.product.img.map(
                (i) {
                  return Builder(
                    builder: (BuildContext context) => Image.network(
                      i,
                      fit: BoxFit.cover,
                      height: 600,
                      width: double.infinity,
                    ),
                  );
                },
              ).toList(),
              options: CarouselOptions(
                viewportFraction: 1,
                height: 440,
              ),
            ),
            // SizedBox(
            //   width: double.infinity,
            //   child: Image.network(
            //     widget.product.img,
            //     fit: BoxFit.cover,
            //     height: 240,
            //   ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.product.name,
                      style: const TextStyle(
                          fontSize: 27, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "\$${widget.product.price}",
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.product.desc,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? ash
                      : lightAsh,
                  fontSize: 16,
                  fontFamily: 'OdinRounded',
                ),
                maxLines: isReadMore ? null : 3,
                overflow: isReadMore ? null : TextOverflow.ellipsis,
              ),
            ),
            GestureDetector(
              onTap: () {
                isReadMore = !isReadMore;
                setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  isReadMore ? "تصغير العرض" : "أقرى المزيد",
                  style: const TextStyle(color: teal),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "الكمية",
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? ash
                      : lightAsh,
                  fontSize: 18,
                  fontFamily: 'OdinRounded',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    // margin: const EdgeInsets.only(right: 300),
                    height: 45,
                    decoration: BoxDecoration(
                        border: Border.all(color: lightAsh),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.transparent),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: decrementQuantity,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.remove),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            quantity.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'OdinRounded',
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: incrementQuantity,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(SellerProfile.routeName,
                            arguments: {"sellerId": widget.product.seller});
                      },
                      child: const Text(
                        'عرض معلومات البائع',
                        style: TextStyle(color: Colors.red),
                      )),
                ),
              ],
            ),
            widget.product.colors.isNotEmpty
                ? const Text(
                    "انقر نقرًا مزدوجًا لتحديد الحجم/اللون وانقر لإلغاء التحديد")
                : const SizedBox.shrink(),
            widget.product.colors.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "الألوان المتاحة",
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? ash
                            : lightAsh,
                        fontSize: 18,
                        fontFamily: 'OdinRounded',
                      ),
                    ),
                  )
                : const SizedBox.shrink(),

            widget.product.colors.isNotEmpty
                ? SizedBox(
                    height: 80,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: (widget.product.colors).map((color) {
                          return GestureDetector(
                            onDoubleTap: () {
                              if (selectedColors.length >= quantity) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const CartColorsExceeded();
                                  },
                                );
                              } else {
                                selectedColors.add(color);
                                selectedColorsDict[color] =
                                    (selectedColorsDict[color] ?? 0) + 1;
                                setState(() {});
                              }
                              print(selectedColors);
                            },
                            onTap: () {
                              if (selectedColors.contains(color)) {
                                selectedColors.remove(color);
                                selectedColorsDict[color] =
                                    (selectedColorsDict[color] ?? 0) - 1;
                                setState(() {});
                              } else {
                                showSnackBar(context, 'لم يتم تحديد هذا اللون');
                              }
                              print(selectedColors);
                            },
                            child: Padding(
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
                                    child: Center(
                                        child: Text(
                                      selectedColorsDict[color].toString() ==
                                              "null"
                                          ? "0"
                                          : selectedColorsDict[color]
                                              .toString(),
                                      style: TextStyle(
                                          color:
                                              color == "white" ? black : white),
                                    )),
                                  ),
                                  Text(
                                    color,
                                    style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? ash
                                            : lightAsh),
                                  )
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),

            widget.product.sizes.isNotEmpty
                ? SizedBox(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: widget.product.sizes.map((size) {
                          return Column(
                            children: [
                              GestureDetector(
                                onDoubleTap: () {
                                  if (selectedSizes.length >= quantity) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const CartSizesExceeded();
                                      },
                                    );
                                  } else {
                                    selectedSizes.add(size);
                                  }
                                  print(selectedSizes);
                                },
                                onTap: () {
                                  if (selectedSizes.contains(size)) {
                                    selectedSizes.remove(size);
                                  } else {
                                    showSnackBar(
                                        context, 'لم يتم تحديد هذا الحجم');
                                  }
                                  print(selectedSizes);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    // padding: const EdgeInsets.all(8),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? ash
                                              : lightAsh),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      sizeMapping[size]!,
                                      style: TextStyle(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? ash
                                              : lightAsh),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),

            Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor:
                                Theme.of(context).brightness == Brightness.light
                                    ? black
                                    : teal),
                        onPressed: addToWishlist,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'أضف إلى قائمة الرغبات ',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'OdinRounded',
                              ),
                            ),
                            Image.asset("assets/images/shopping-cart.png")
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).brightness == Brightness.light
                                    ? black
                                    : teal),
                        onPressed: addToCart,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'أضافة إلى السلة ',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'OdinRounded',
                              ),
                            ),
                            Image.asset("assets/images/shopping-cart.png")
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // // const Padding(
            // //   padding: EdgeInsets.symmetric(horizontal: 10.0),
            // //   child: Text(
            // //     'Rate The Product',
            // //     style: TextStyle(
            // //       fontSize: 22,
            // //       fontWeight: FontWeight.bold,
            // //     ),
            // //   ),
            // // ),
            // // RatingBar.builder(
            // //   initialRating: myRating,
            // //   minRating: 1,
            // //   direction: Axis.horizontal,
            // //   allowHalfRating: true,
            // //   itemCount: 5,
            // //   itemPadding: const EdgeInsets.symmetric(horizontal: 4),
            // //   itemBuilder: (context, _) => const Icon(
            // //     Icons.star,
            // //     color: secondaryColor,
            // //   ),
            // //   onRatingUpdate: (rating) {
            // //     // productDetailsService.rateProduct(
            // //     //   context: context,
            // //     //   product: widget.product,
            // //     //   rating: rating,
            // //     // );
            // //   },
            // // ),
          ],
        ),
      ),
    );
  }
}
