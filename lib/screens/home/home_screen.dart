import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home_screen";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('Home Screen'),
    );
  }
}