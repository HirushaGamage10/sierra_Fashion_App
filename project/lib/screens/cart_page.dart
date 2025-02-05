import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/theme_notifier.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<dynamic> cartItems = [];
  double totalPrice = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token');

    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('https://sierrafashion.store/api/cart'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            cartItems = data['cartItems'];
            totalPrice = data['totalPrice'];
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load cart items. Please try again later.')),
          );
        }
      } catch (error) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load cart items. Please try again later.')),
        );
      }
    } else {
      setState(() {
        isLoading = false;
      });
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> _removeCartItem(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token');

    if (token != null) {
      try {
        final response = await http.delete(
          Uri.parse('https://sierrafashion.store/api/cart/remove/$id'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          setState(() {
            cartItems.removeWhere((item) => item['id'] == id);
            totalPrice = cartItems.fold(0, (sum, item) => sum + item['product']['price'] * item['quantity']);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Item removed successfully.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to remove item. Please try again later.')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove item. Please try again later.')),
        );
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Product Cart',
          style: TextStyle(
            fontFamily: 'Poly',
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            fontSize: 28,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: themeNotifier.isDarkMode ? Colors.black : Colors.white,
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Cart Items
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 50), // Add padding to the bottom
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        final imageUrl = '${item['product']['images'][0]}';
                        return CartItem(
                          id: item['id'],
                          imageUrl: imageUrl,
                          title: item['product']['name'],
                          subtitle: 'Color: ${item['color']}, Size: ${item['size']}',
                          price: item['product']['price'],
                          quantity: item['quantity'],
                          onRemove: _removeCartItem,
                        );
                      },
                    ),
                  ),
                  // Total Price
                  Container(
                    margin: const EdgeInsets.only(bottom: 30), // Add margin to the bottom
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                            Text('Rs $totalPrice', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/checkout');
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color.fromRGBO(178, 151, 79, 1),
                            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Check Out', style: TextStyle(fontSize: 18, fontFamily: 'Poppins', fontWeight: FontWeight.w900)),
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

class CartItem extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String title;
  final String subtitle;
  final double price;
  final int quantity;
  final Function(String) onRemove;

  const CartItem({
    super.key,
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.quantity,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        color: themeNotifier.isDarkMode ? Colors.grey[850] : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10),
              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: themeNotifier.isDarkMode ? Colors.white : Colors.black)),
                    Text(subtitle, style: TextStyle(color: Colors.grey)),
                    Text('Rs. ${price.toString()}', style: TextStyle(fontSize: 16, color: themeNotifier.isDarkMode ? Colors.white : Colors.black)),
                    Text('Quantity: $quantity', style: TextStyle(fontSize: 16, color: themeNotifier.isDarkMode ? Colors.white : Colors.black)),
                  ],
                ),
              ),
              Column(
                children: [
                  // Delete Button
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => onRemove(id),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}