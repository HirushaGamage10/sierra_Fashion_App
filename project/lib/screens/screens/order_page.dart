import 'package:flutter/material.dart';

class OrderPage extends StatelessWidget {
  final List<OrderItem> orderItems = [
    OrderItem(
      imageUrl: 'assets/images/product1.png',
      title: 'ADIDAS BASKETBALL LONG SLEEVE TEE',
      price: 3500.0,
    ),
    OrderItem(
      imageUrl: 'assets/images/product3.png',
      title: 'ADIDAS BASKETBALL LONG SLEEVE TEE',
      price: 3500.0,
    ),
  ];

  OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Orders',
          style: TextStyle(
            fontFamily: 'Poly',
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            fontSize: 28,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: orderItems.length,
        itemBuilder: (context, index) {
          final item = orderItems[index];
          return OrderCard(
            imageUrl: item.imageUrl,
            title: item.title,
            price: item.price,
            onTrackOrder: () {
              
              print('Track order for ${item.title}');
            },
            isDarkMode: isDarkMode, 
          );
        },
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double price;
  final VoidCallback onTrackOrder;
  final bool isDarkMode;

  const OrderCard({super.key, 
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.onTrackOrder,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        color: isDarkMode ? Colors.grey[850] : Colors.white, // Dark mode card background
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [

              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imageUrl,
                  height: 70,
   
                  width: 70,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12),

              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.black, // Adjust text color
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Rs. ${price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDarkMode ? Colors.white70 : Colors.black87, // Adjust price text color
                      ),
                    ),
                  ],
                ),
              ),
              
              // Track Order Button
              ElevatedButton(
                onPressed: onTrackOrder,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, 
                  backgroundColor:Color(0xFFBCA46C), //
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Track Order',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderItem {
  final String imageUrl;
  final String title;
  final double price;

  OrderItem({
    required this.imageUrl,
    required this.title,
    required this.price,
  });
}
