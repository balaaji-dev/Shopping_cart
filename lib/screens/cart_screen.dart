import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const CartScreen({
    super.key,
    required this.cartItems,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  // Calculate total number of items
  int get totalItems {
    return widget.cartItems.fold(
      0,
          (sum, item) => sum + item.quantity,
    );
  }

  // Calculate overall cart total
  double get cartTotal {
    return widget.cartItems.fold(
      0,
          (sum, item) => sum + item.subtotal,
    );
  }

  // Increase quantity
  void increaseQuantity(CartItem item) {
    setState(() {
      item.quantity++;
    });
  }

  // Decrease quantity
  void decreaseQuantity(CartItem item) {
    if (item.quantity > 1) {
      setState(() {
        item.quantity--;
      });
    }
  }

  // Remove individual product
  void removeItem(CartItem item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove Product'),
          content: Text(
            'Are you sure you want to remove ${item.product.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    if (confirm == true && mounted) {
      setState(() {
        widget.cartItems.remove(item);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product removed from cart'),
        ),
      );
    }
  }

  // Clear entire cart
  void clearCart() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear Cart'),
          content: const Text(
            'Are you sure you want to remove all products?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );

    if (confirm == true && mounted) {
      setState(() {
        widget.cartItems.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Cart'),
          centerTitle: true,
          actions: [
            if (widget.cartItems.isNotEmpty)
              IconButton(
                onPressed: clearCart,
                icon: const Icon(Icons.delete_sweep),
                tooltip: 'Clear Cart',
              ),
          ],
        ),

        body: widget.cartItems.isEmpty

        // Empty Cart
            ? const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 90,
                color: Colors.grey,
              ),
              SizedBox(height: 15),
              Text(
                'Your cart is empty!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Add some products to get started.',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        )

        // Cart Products
            : Column(
          children: [

            // Total Items
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Items: $totalItems',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${widget.cartItems.length} Products',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Product List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {

                  final item = widget.cartItems[index];

                  return Card(
                    margin: const EdgeInsets.only(
                      bottom: 12,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [

                          // Product Image
                          ClipRRect(
                            borderRadius:
                            BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: item.product.image,
                              width: 90,
                              height: 100,
                              fit: BoxFit.cover,
                              memCacheWidth: 200,
                              memCacheHeight: 200,
                              errorWidget: (context, url, error) {
                                return const Icon(
                                  Icons.image_not_supported,
                                  size: 40,
                                );
                              },
                            )
                          ),

                          const SizedBox(width: 12),

                          // Product Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [

                                Text(
                                  item.product.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  'Price: ₹${item.product.price.toStringAsFixed(2)}',
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  'Subtotal: ₹${item.subtotal.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // Quantity Controls
                                Row(
                                  children: [

                                    IconButton(
                                      onPressed: () {
                                        decreaseQuantity(item);
                                      },
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                      ),
                                    ),

                                    Text(
                                      '${item.quantity}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    IconButton(
                                      onPressed: () {
                                        increaseQuantity(item);
                                      },
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                      ),
                                    ),

                                    const Spacer(),

                                    IconButton(
                                      onPressed: () {
                                        removeItem(item);
                                      },
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Cart Total
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withValues(
                  alpha: 0.08,
                ),
              ),
              child: Column(
                children: [

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        '₹${cartTotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Checkout feature coming soon!',
                            ),
                          ),
                        );
                      },
                      child: const Text('Proceed to Checkout'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
