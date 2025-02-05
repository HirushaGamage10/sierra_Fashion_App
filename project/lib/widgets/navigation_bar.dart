import 'package:sierra/screens/cart_page.dart';
import 'package:sierra/screens/favorite_page.dart';
import 'package:sierra/screens/profile_page.dart';
import 'package:sierra/screens/screens/order_page.dart';
import 'package:flutter/material.dart';
import '../screens/screens/home Page/home_page.dart';

class MainPage extends StatefulWidget {
  final Function(bool) toggleDarkMode;
  final bool isDarkMode;

  const MainPage({super.key, required this.toggleDarkMode, required this.isDarkMode});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      HomePage(),
      FavoritePage(),
      OrderPage(),
      CartPage(),
      ProfilePage(),
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], 
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _selectedIndex = 0; 
          });
        },
        shape: const CircleBorder(),
        backgroundColor: widget.isDarkMode ? Colors.white : Colors.black, 
        child: Icon(
        Icons.home,
        color: widget.isDarkMode ? Colors.black : Colors.white, 
        size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 8, 
        height: 60,
        color: widget.isDarkMode ? Color.fromRGBO(74, 73, 73, 1) : Color.fromRGBO(178, 151, 79, 1), 
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                _onItemTapped(1); 
              },
              icon: Icon(
                Icons.favorite_border,
                size: 30,
                color: _selectedIndex == 1 ? const Color.fromARGB(255, 0, 0, 0) : Color.fromARGB(255, 255, 255, 255), // Change selected icon color
              ),
            ),
            IconButton(
              onPressed: () {
                _onItemTapped(2); 
              },
              icon: Icon(
                Icons.assignment_rounded,
                size: 30,
                color: _selectedIndex == 2 ? Color.fromARGB(255, 7, 7, 7) : Color.fromARGB(255, 255, 255, 255), 
              ),
            ),
            const SizedBox(width: 15), 
            IconButton(
              onPressed: () {
                _onItemTapped(3); 
              },
              icon: Icon(
                Icons.shopping_cart_outlined,
                size: 30,
                color: _selectedIndex == 3 ? const Color.fromARGB(255, 0, 0, 0) : Color.fromARGB(255, 255, 255, 255), 
              ),
            ),
            IconButton(
              onPressed: () {
                _onItemTapped(4); 
              },
              icon: Icon(
                Icons.person,
                size: 30,
                color: _selectedIndex == 4 ? const Color.fromARGB(255, 0, 0, 0) : Color.fromARGB(255, 255, 255, 255), 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
