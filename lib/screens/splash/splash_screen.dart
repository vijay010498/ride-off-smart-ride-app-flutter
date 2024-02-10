import 'package:flutter/material.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/otp_phone_number/otp_phone_number_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key); // Corrected constructor definition

  static String routeName = "/";

  @override
  Widget build(BuildContext context) {
    return _SplashScreenState(); // Return _SplashScreenState widget directly
  }
}

class _SplashScreenState extends StatefulWidget {
  @override
  _SplashScreenStateState createState() => _SplashScreenStateState();
}

class _SplashScreenStateState extends State<_SplashScreenState> {
  @override
  void initState() {
    super.initState();
    // TODO Add initialization tasks here, like loading data, checking authentication, etc.
    _initializeApp();
  }

  // Simulate initialization process
  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 3)); // Simulate a delay of 3 seconds
    // Navigate to home page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OtpPhoneNumberScreen()), // Replace with your actual home screen widget
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/logo.jpg',
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'SMART RIDE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
