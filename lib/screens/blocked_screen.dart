import 'package:flutter/material.dart';

class BlockedMessageWidget extends StatelessWidget {
  static String routeName = "/blocked_screen";
  const BlockedMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('You are Blocked'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'You have been blocked. Please contact us ',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
