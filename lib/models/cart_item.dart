import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  // Calculate subtotal for this product
  double get subtotal {
    return product.price * quantity;
  }
}
