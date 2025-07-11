import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'restaurant_products_screen.dart';
import 'providers.dart';
import 'models.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final Product product;
  const ProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  ConsumerState<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                product.imageUrl,
                width: 260,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              product.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              product.description,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepOrangeAccent.shade700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
                ),
                Text(
                  quantity.toString(),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => setState(() => quantity++),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(basketProvider.notifier).addToBasket(product, quantity: quantity);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added to basket!')),
                  );
                },
                child: const Text('Add to Basket'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 