import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';
import 'providers.dart';
import 'product_details_screen.dart';
import 'basket_screen.dart';

class RestaurantProductsScreen extends ConsumerStatefulWidget {
  final Restaurant restaurant;
  const RestaurantProductsScreen({Key? key, required this.restaurant}) : super(key: key);

  @override
  ConsumerState<RestaurantProductsScreen> createState() => _RestaurantProductsScreenState();
}

class _RestaurantProductsScreenState extends ConsumerState<RestaurantProductsScreen> {
  String searchQuery = '';

  List<Product> getProductsForRestaurant(String restaurantName) {
    switch (restaurantName) {
      case 'Pizza Place':
        return [
          Product(
            name: 'Margherita',
            imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=400&q=80', // Working pizza image
            price: 10.99,
            description: 'Classic pizza with tomato sauce, mozzarella, and fresh basil.'
          ),
          Product(
            name: 'Pepperoni',
            imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=400&q=80', // Pepperoni pizza
            price: 12.49,
            description: 'Pepperoni pizza topped with mozzarella and spicy pepperoni slices.'
          ),
        ];
      case 'Sushi Bar':
        return [
          Product(
            name: 'Salmon Roll',
            imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=400&q=80', // Sushi rolls
            price: 14.99,
            description: 'Fresh salmon roll with rice, seaweed, and a touch of wasabi.'
          ),
          Product(
            name: 'Tuna Sashimi',
            imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=400&q=80', // fallback food image
            price: 16.99,
            description: 'Slices of premium tuna served with soy sauce and wasabi.'
          ),
        ];
      case 'Burger Joint':
        return [
          Product(
            name: 'Classic Burger',
            imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=400&q=80', // Classic burger
            price: 8.49,
            description: 'Juicy beef patty with lettuce, tomato, onion, and house sauce.'
          ),
          Product(
            name: 'Cheese Burger',
            imageUrl: 'https://images.unsplash.com/photo-1551782450-a2132b4ba21d?auto=format&fit=crop&w=400&q=80', // Cheeseburger
            price: 9.29,
            description: 'Beef burger topped with cheddar cheese, pickles, and ketchup.'
          ),
        ];
      case 'Taco Stand':
        return [
          Product(
            name: 'Beef Taco',
            imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=400&q=80', // Tacos
            price: 3.99,
            description: 'Soft taco filled with seasoned beef, lettuce, and cheese.'
          ),
          Product(
            name: 'Chicken Taco',
            imageUrl: 'https://images.unsplash.com/photo-1502741338009-cac2772e18bc?auto=format&fit=crop&w=400&q=80', // Working chicken taco
            price: 4.49,
            description: 'Grilled chicken taco with salsa, cilantro, and lime.'
          ),
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = getProductsForRestaurant(widget.restaurant.name);
    final filteredProducts = products.where((p) {
      final query = searchQuery.toLowerCase();
      return p.name.toLowerCase().contains(query) || p.description.toLowerCase().contains(query);
    }).toList();
    return Scaffold(
      appBar: AppBar(title: Text(widget.restaurant.name)),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      widget.restaurant.imageUrl,
                      width: 220,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(widget.restaurant.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(widget.restaurant.description, style: const TextStyle(fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.deepOrangeAccent, size: 20),
                    const SizedBox(width: 4),
                    Text(widget.restaurant.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 28),
                Text('Products', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepOrangeAccent.shade700)),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (value) => setState(() => searchQuery = value),
                ),
              ],
            ),
          ),
          ...filteredProducts.map((product) => Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsScreen(product: product),
                  ),
                );
              },
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    child: Image.network(
                      product.imageUrl,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(height: 8),
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrangeAccent.shade700, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
      floatingActionButton: Consumer(
        builder: (context, ref, _) {
          final basket = ref.watch(basketProvider);
          final count = basket.fold<int>(0, (sum, item) => sum + item.quantity);
          return FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BasketScreen()),
              );
            },
            icon: const Icon(Icons.shopping_basket),
            label: Text('Basket ($count)'),
            backgroundColor: Colors.deepOrangeAccent,
          );
        },
      ),
    );
  }
} 