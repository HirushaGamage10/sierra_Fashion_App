import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  final Function(bool) toggleDarkMode;
  final bool isDarkMode;

  const StartPage({super.key, required this.toggleDarkMode, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var isLandscape = mediaQuery.orientation == Orientation.landscape;

    return Scaffold(
      body: Stack(
        children: [
          
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/first.jpg'), 
                fit: BoxFit.cover,
              ),
            ),
          ),

          
          Positioned(
            bottom: isLandscape ? -40 : -65, 
            right: isLandscape ? -50 : -65, 
            child: Container(
              height: isLandscape ? 220 : 280, 
              width: isLandscape ? 220 : 280,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 15,
                    offset: const Offset(0, 5), 
                  ),
                ],
              ),
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(24), 
                    backgroundColor: Colors.white, 
                    shadowColor: Colors.transparent, 
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/guest');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 45.0, bottom: 30.0), 
                    child: Text(
                      "Let's Start",
                      style: TextStyle(
                        fontFamily: 'Poly',
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                        fontSize: isLandscape ? 30 : 40, 
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
