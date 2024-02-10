import 'package:flutter/material.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/home/home_screen.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/otp_phone_number/otp_phone_number_screen.dart';
import 'package:ride_off_smart_ride_app_flutter/services/api_services/auth.dart';

import '../../services/storage/secureStorageService.dart';

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

final SecureStorageService secureStorageService = SecureStorageService();
final AuthService authService = AuthService();

class _SplashScreenStateState extends State<_SplashScreenState> {
  @override
  void initState() {
    super.initState();
    // TODO Add initialization tasks here, like loading data, checking authentication, etc.
    _initializeApp();
  }

  // Simulate initialization process
  Future<void> _initializeApp() async {
    var currentUser = await authService.getCurrentUser();
    if (currentUser.isNotEmpty) {
      // Send to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else  {
      // force user to OTP login again
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OtpPhoneNumberScreen()),
      );
    }
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
