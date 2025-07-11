import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';
import 'restaurant_products_screen.dart';
import 'providers.dart';
import 'basket_screen.dart';

class RestaurantsListScreen extends ConsumerStatefulWidget {
  const RestaurantsListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RestaurantsListScreen> createState() => _RestaurantsListScreenState();
}

class _RestaurantsListScreenState extends ConsumerState<RestaurantsListScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final restaurants = [
      Restaurant(
        name: 'Pizza Place',
        description: 'Delicious wood-fired pizzas.',
        imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=400&q=80', // Pepperoni pizza
        rating: 4.5,
      ),
      Restaurant(
        name: 'Sushi Bar',
        description: 'Fresh sushi and sashimi.',
        imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=400&q=80', // Sushi rolls
        rating: 4.8,
      ),
      Restaurant(
        name: 'Burger Joint',
        description: 'Juicy burgers and crispy fries.',
        imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=400&q=80', // Classic burger
        rating: 4.2,
      ),
      Restaurant(
        name: 'Taco Stand',
        description: 'Authentic Mexican tacos.',
        imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=400&q=80', // Tacos
        rating: 4.6,
      ),
    ];

    final filteredRestaurants = restaurants.where((r) {
      final query = searchQuery.toLowerCase();
      return r.name.toLowerCase().contains(query) || r.description.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Restaurants')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search restaurants...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredRestaurants.length,
              itemBuilder: (context, index) {
                final restaurant = filteredRestaurants[index];
                return Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      ref.read(selectedRestaurantProvider.notifier).state = restaurant;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantProductsScreen(restaurant: restaurant),
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
                            restaurant.imageUrl,
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  restaurant.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  restaurant.description,
                                  style: TextStyle(color: Colors.grey[700], fontSize: 15),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.deepOrangeAccent, size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      restaurant.rating.toString(),
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
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