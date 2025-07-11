import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';
import 'providers.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);
    double total = basket.fold(0, (sum, item) => sum + item.product.price * item.quantity);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: basket.isEmpty
          ? const Center(child: Text('Your basket is empty.'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Order Summary', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: basket.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = basket[index];
                        return Row(
                          children: [
                            Expanded(
                              child: Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Text('x${item.quantity}', style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 16),
                            Text(' ${(item.product.price * item.quantity).toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(
                        ' ${total.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrangeAccent),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: basket.isEmpty
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Order Confirmed'),
                                  content: const Text('Thank you for your order!'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                      child: const Text('Confirm Order'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
} 