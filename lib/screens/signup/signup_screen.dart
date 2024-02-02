import 'package:flutter/material.dart';
import 'package:ride_off_smart_ride_app_flutter/constants.dart';
import 'signup_form.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/signup_screen";

  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //button to go back
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Sign Up"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Sign Up", style: headingStyle),
              Text("Fill form to complete registration", textAlign: TextAlign.center),
              SizedBox(height: 30),
              SizedBox(height: 10),
              SignUpForm(),
            ],
          ),
        ),
      ),
    );
  }
}
