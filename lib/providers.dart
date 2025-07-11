import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';

// Selected restaurant provider
final selectedRestaurantProvider = StateProvider<Restaurant?>((ref) => null);

// Selected product provider
final selectedProductProvider = StateProvider<Product?>((ref) => null);

// Basket provider (list of products with quantity)
class BasketItem {
  final Product product;
  int quantity;
  BasketItem({required this.product, this.quantity = 1});
}

final basketProvider = StateNotifierProvider<BasketNotifier, List<BasketItem>>((ref) => BasketNotifier());

class BasketNotifier extends StateNotifier<List<BasketItem>> {
  BasketNotifier() : super([]);

  void addToBasket(Product product, {int quantity = 1}) {
    final index = state.indexWhere((item) => item.product.name == product.name);
    if (index != -1) {
      state[index].quantity += quantity;
      state = List.from(state);
    } else {
      state = [...state, BasketItem(product: product, quantity: quantity)];
    }
  }

  void removeFromBasket(Product product) {
    state = state.where((item) => item.product.name != product.name).toList();
  }

  void updateQuantity(Product product, int quantity) {
    final index = state.indexWhere((item) => item.product.name == product.name);
    if (index != -1) {
      state[index].quantity = quantity;
      state = List.from(state);
    }
  }

  void clearBasket() {
    state = [];
  }
} 