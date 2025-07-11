import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';
import 'providers.dart';
import 'checkout_screen.dart';

class BasketScreen extends ConsumerWidget {
  const BasketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);
    final basketNotifier = ref.read(basketProvider.notifier);
    double total = basket.fold(0, (sum, item) => sum + item.product.price * item.quantity);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Basket')),
      body: basket.isEmpty
          ? const Center(child: Text('Your basket is empty.'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...basket.map((item) => Card(
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.product.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.product.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Text('\$${item.product.price.toStringAsFixed(2)}'),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: item.quantity > 1
                                      ? () => basketNotifier.updateQuantity(item.product, item.quantity - 1)
                                      : null,
                                ),
                                Text(item.quantity.toString()),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () => basketNotifier.updateQuantity(item.product, item.quantity + 1),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () => basketNotifier.removeFromBasket(item.product),
                            ),
                          ],
                        ),
                      ),
                    )),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrangeAccent),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: basket.isEmpty ? null : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                      );
                    },
                    child: const Text('Checkout'),
                  ),
                ),
              ],
            ),
    );
  }
} 