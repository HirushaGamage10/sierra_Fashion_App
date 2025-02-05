import 'package:sierra/screens/cart_page.dart';
import 'package:sierra/screens/checkout_page.dart';
import 'package:sierra/screens/screens/signup_page.dart';
import 'screens/start_page.dart';
import 'screens/guest_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'widgets/theme_notifier.dart';
import 'screens/login_page.dart';

import 'widgets/navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(
      ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> checkTokenAndRedirect(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      // If token is available, navigate to profile
      Navigator.pushReplacementNamed(context, '/profile');
    } else {
      // If token is not available, navigate to login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeNotifier.isDarkMode ? ThemeData.dark() : ThemeData.light(),
          initialRoute: '/',
          routes: {
            '/': (context) => StartPage(toggleDarkMode: (bool value) {
              themeNotifier.toggleDarkMode(value);
            }, isDarkMode: themeNotifier.isDarkMode),
            '/guest': (context) => GuestPage(),
            '/login': (context) => LoginPage(),
            '/cart': (context) => CartPage(),
            '/checkout': (context) => CheckoutPage(),
            '/signup': (context) => SignupPage(),
            '/home': (context) => MainPage(toggleDarkMode: (bool value) {
              themeNotifier.toggleDarkMode(value);
            }, isDarkMode: themeNotifier.isDarkMode),


          },
        );
      },
    );
  }
}
