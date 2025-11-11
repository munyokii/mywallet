import 'package:flutter/material.dart';
import 'package:mywallet/classes/homecontent.dart';
import 'package:mywallet/classes/messages.dart';
import 'package:mywallet/classes/settings.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final List<Widget> _pages = [
    const Homecontent(),
    const MessagesScreen(),
    const SettingsScreen(),
  ];

  // Define colors from your Login & Signup screens
  final Color primaryColor = const Color(0xFF4A90E2); // Adjust to match login/signup
  final Color backgroundColor = const Color(0xFFF5F7FA);
  final Color bottomNavSelectedColor = const Color(0xFF4A90E2);
  final Color bottomNavUnselectedColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // Same background color
      appBar: AppBar(
        title: const Text(
          'My Pocket Wallet',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Consistent text color
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor, // Same AppBar color
        elevation: 3,
      ),
      body: _pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: bottomNavSelectedColor, // Matched color
        unselectedItemColor: bottomNavUnselectedColor,
        backgroundColor: Colors.white,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}