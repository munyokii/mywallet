// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mywallet/classes/homecontent.dart';
import 'package:mywallet/firebase_options.dart';
import 'package:mywallet/screens/splashscreen.dart'; // Importing the Material package.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyWallet());
}

// Root widget for the app.
class MyWallet extends StatelessWidget {
  const MyWallet({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Pocket Wallet',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const Splashscreen(),
        '/home': (context) =>  const Homecontent(),
        // Add more routes as needed
      },
    );
  }
}