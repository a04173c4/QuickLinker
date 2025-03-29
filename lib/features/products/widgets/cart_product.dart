// ignore_for_file: use_build_context_synchronously

import 'package:QuickLinker/features/models/product.dart';
import 'package:QuickLinker/features/products/screens/product_details.dart';
import 'package:QuickLinker/features/products/services/product_details_service.dart';
import 'package:QuickLinker/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartProduct extends StatefulWidget {
  final int index;
  const CartProduct({
    super.key,
    required this.index,
  });

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  @override
  void initState() {
    super.initState();
    // Initialize quantity from the cart item
    final cartItem = context.read<UserProvider>().user.cart[widget.index];
    print(cartItem.product.colors);
    quantity = cartItem.amount;
    colors = cartItem.product.colors;
    sizes = cartItem.product.colors;
  }

  final ProductDetailsService productDetailsService = ProductDetailsService();

  int? quantity;
  List<String>? colors;
  List<String>? sizes;

  void incrementQuantity() {
    setState(() {
      quantity = quantity! + 1;
    });
  }

  void decrementQuantity() {
    setState(() {
      if (quantity! > 1) quantity = quantity! - 1;
    });
  }

  void editCart(Product product, bool isRemove) {
    productDetailsService.editCart(
        context: context,
        product: product,
        amount: quantity!,
        isRemove: isRemove,
        selectedColors: [],
        selectedSizes: [],
        isUpdateQuantityOnly: true);

    setState(() {});
  }

  String? result;
  void mapItemColors() {
    Map<String, int> itemCounts = {};
    for (var color in colors!) {
      itemCounts[color] = (itemCounts[color] ?? 0) + 1;
    }
    result = itemCounts.entries
        .map((entry) => '${entry.key}: ${entry.value}')
        .join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final cartItem = context.watch<UserProvider>().user.cart[widget.index];
    colors!.isEmpty ? null : mapItemColors();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Container
              Container(
                margin: const EdgeInsetsDirectional.only(end: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.network(
                  cartItem.product.img.isNotEmpty
                      ? cartItem.product.img[0]
                      : 'https://placehold.co/150',
                  fit: BoxFit.contain,
                  height: 135,
                  width: 135,
                ),
              ),

              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        cartItem.product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'OdinRounded',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Price
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '\$${cartItem.product.price}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Colors/Quantity
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        colors!.isNotEmpty
                            ? 'الألوان: $result'
                            : "${cartItem.amount} في السلة",
                        style: const TextStyle(
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Buttons Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: ElevatedButton(
                  onPressed: () async {
                    Product product = await productDetailsService.getProduct(
                        cartItem.product.id, context);
                    Navigator.of(context).pushNamed(
                      ProductDetails.routeName,
                      arguments: product,
                    );
                  },
                  child: const Text('تعديل'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => editCart(cartItem.product, true),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
