import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailsPage extends StatefulWidget {
  final dynamic product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  String selectedSize = '';
  String selectedColor = '';
  int _currentImageIndex = 0;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    if (widget.product['sizes'].isNotEmpty) {
      selectedSize = widget.product['sizes'][0];
    }
    if (widget.product['colors'].isNotEmpty) {
      selectedColor = widget.product['colors'][0];
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Product Details',
            style: TextStyle(
              fontFamily: 'Poly',
            ),
          ),
        ),
        backgroundColor: isDarkMode ? Colors.grey[900] : const Color.fromRGBO(178, 151, 79, 1),
        elevation: 4,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: IconButton(
              icon: Icon(Icons.favorite_border, color: isDarkMode ? Colors.white : Colors.black),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: isLandscape ? 300 : 500,
                    child: PageView.builder(
                      itemCount: widget.product['images'].length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(19.0),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Container(
                                width: isLandscape
                                    ? MediaQuery.of(context).size.width * 0.3
                                    : MediaQuery.of(context).size.width,
                                height: isLandscape
                                    ? MediaQuery.of(context).size.height * 0.9
                                    : MediaQuery.of(context).size.height * 0.5,
                                child: Image.network(
                                  widget.product['images'][index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.product['images'].length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentImageIndex == index
                                ? Colors.amber
                                : (isDarkMode ? Colors.grey : Colors.grey[300]),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: isLandscape
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildProductDetails(isDarkMode),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildSizeColorQuantitySelection(isDarkMode),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildProductDetails(isDarkMode),
                              _buildSizeColorQuantitySelection(isDarkMode),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomSection(isDarkMode),
        ],
      ),
    );
  }

  // Method to build product details (name, description)
  Widget _buildProductDetails(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.product['name'],
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Product Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.product['description'],
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // Method to build size, color, and quantity selection
  Widget _buildSizeColorQuantitySelection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildSectionTitle('Select Size', isDarkMode),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: widget.product['sizes'].map<Widget>((size) {
            return ChoiceChip(
              label: Text(size),
              labelStyle: TextStyle(
                color: selectedSize == size
                    ? Colors.black
                    : (isDarkMode ? Colors.white : Colors.black),
              ),
              selected: selectedSize == size,
              onSelected: (bool selected) {
                setState(() {
                  selectedSize = size;
                });
              },
              selectedColor: Colors.amber,
              backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        _buildSectionTitle('Select Color', isDarkMode),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: widget.product['colors'].map<Widget>((color) {
            return _buildColorOption(color, _colorFromString(color));
          }).toList(),
        ),
        const SizedBox(height: 16),
        _buildSectionTitle('Select Quantity', isDarkMode),
        _buildQuantitySelector(isDarkMode),
      ],
    );
  }

  // Helper method to build section titles
  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  // Bottom section with Total Price and Add to Cart
  Widget _buildBottomSection(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 0,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Text(
                  'Total Price\nRs. ${widget.product['price'] * quantity}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(178, 151, 79, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String? token = prefs.getString('user_token');

                    if (token == null) {
                      Navigator.pushNamed(context, '/login');
                    } else {
                      await addToCart(token);
                    }
                  },
                  icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
                  label: const Text(
                    'Add to Cart',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build quantity selector
  Widget _buildQuantitySelector(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.remove, size: 28, color: isDarkMode ? Colors.white : Colors.black),
              onPressed: () {
                setState(() {
                  if (quantity > 1) {
                    quantity--;
                  }
                });
              },
            ),
            Text(
              quantity.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            IconButton(
              icon: Icon(Icons.add, size: 28, color: isDarkMode ? Colors.white : Colors.black),
              onPressed: () {
                setState(() {
                  quantity++;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption(String colorName, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = colorName;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(
            color: selectedColor == colorName ? Colors.amber : Colors.black, // Add dark border
            width: 2,
          ),
        ),
        width: 40,
        height: 40,
      ),
    );
  }

  Color _colorFromString(String colorString) {
    switch (colorString.toLowerCase()) {
      case 'black':
        return Colors.black;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'red':
        return Colors.red;
      default:
        return Colors.transparent;
    }
  }

  Future<void> addToCart(String token) async {
    final response = await http.post(
      Uri.parse('https://sierrafashion.store/api/cart/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'product_id': widget.product['id'],
        'quantity': quantity,
        'size': selectedSize,
        'color': selectedColor,
      }),
    );

    if (response.statusCode == 200) {
      // Successfully added to cart
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added to cart')),
      );
    } else {
      // Failed to add to cart
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product to cart')),
      );
    }
  }
}