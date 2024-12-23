import 'product.dart';

class Cart {
  final List<Product> items;

  Cart() : items = [];

  void addItem(Product product) {
    items.add(product);
  }

  void removeItem(Product product) {
    items.remove(product);
  }

  double get totalPrice => items.fold(0, (sum, item) => sum + item.price);
}
