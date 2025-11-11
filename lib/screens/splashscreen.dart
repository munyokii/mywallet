import 'package:flutter/material.dart';
import 'package:mywallet/screens/loginscreen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue.shade900,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _topImageSection(),
            const SizedBox(height: 24),
            _middleScreenText(),
            const SizedBox(height: 32),
            _splashButton(context),
          ],
        ),
      ),
    );
  }
}

Widget _topImageSection() {
  return Container(
    padding: const EdgeInsets.all(16.0),
    child: Center(
      child: Image.asset(
        "assets/images/bank_wallet.png", // Update with a relevant banking image
        width: 200,
        height: 200,
      ),
    ),
  );
}

Widget _middleScreenText() {
  return const Column(
    children: [
      Text(
        "My Pocket Wallet",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "Your secure digital wallet for easy transactions",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: Colors.white70,
        ),
      ),
    ],
  );
}

Widget _splashButton(BuildContext context) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.orangeAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
    ),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    },
    child: const Text(
      "Get Started",
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );
}