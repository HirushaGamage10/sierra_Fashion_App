import 'package:flutter/material.dart';

class FavoritePage extends StatelessWidget {
  final List<FavoriteItem> favoriteItems = [
    FavoriteItem(
      imageUrl: 'assets/images/product1.png',
      title: 'NIKE RUNNING SHIRT',
      subtitle: 'Men',
      price: 5000.0,
    ),
    FavoriteItem(
      imageUrl: 'assets/images/product5.png',
      title: 'PUMA HOODIE',
      subtitle: 'Men',
      price: 2000.0,
    ),
    FavoriteItem(
      imageUrl: 'assets/images/product4.png',
      title: 'REEBOK TRAINING SHIRT',
      subtitle: 'Men',
      price: 4000.0,
    ),
  ];

  FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark; 
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Favorites',
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
        itemCount: favoriteItems.length,
        itemBuilder: (context, index) {
          final item = favoriteItems[index];
          return FavoriteCard(
            imageUrl: item.imageUrl,
            title: item.title,
            subtitle: item.subtitle,
            price: item.price,
            onDelete: () {
              
              print('${item.title} removed from favorites');
            },
            isDarkMode: isDarkMode, 
          );
        },
      ),
    );
  }
}

class FavoriteCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final double price;
  final VoidCallback onDelete;
  final bool isDarkMode;

  const FavoriteCard({super.key, 
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.onDelete,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        color: isDarkMode ? Colors.grey[850] : Colors.white, 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [

              
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

            
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.black, 
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.grey, 
                      ),
                    ),
                    Text(
                      'Rs. ${price.toString()}',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDarkMode ? Colors.white70 : Colors.black87, 
                      ),
                    ),
                  ],
                ),
              ),
              
              
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoriteItem {
  final String imageUrl;
  final String title;
  final String subtitle;
  final double price;

  FavoriteItem({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.price,
  });
}
