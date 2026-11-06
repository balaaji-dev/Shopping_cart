import 'package:flutter/material.dart';
import '../data/product_data.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'product_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // Stores all selected cart products
  final List<CartItem> cartItems = [];

  // Calculate total number of items
  int get totalCartItems {
    return cartItems.fold(
      0,
          (sum, item) => sum + item.quantity,
    );
  }

  // Add product to cart
  void addToCart(Product product) {
    setState(() {
      // Check whether product already exists
      final index = cartItems.indexWhere(
            (item) => item.product.id == product.id,
      );

      if (index != -1) {
        // Increase existing product quantity
        cartItems[index].quantity++;
      } else {
        // Add new product
        cartItems.add(
          CartItem(product: product),
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shopping Cart'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Badge(
                label: Text('$totalCartItems'),
                child: const Icon(Icons.shopping_cart),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(
                      cartItems: cartItems,
                    ),
                  ),
                ).then((_) {
                  setState(() {});
                });
              },
            ),
          ],
        ),

        body: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.52,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final Product product = products[index];

            return ProductCard(
              product: product,

              onAddToCart: () {
                addToCart(product);
              },

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsScreen(
                      product: product,
                      cartItems: cartItems,
                      onAddToCart: () {
                        addToCart(product);
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
