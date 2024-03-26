import 'package:flutter/material.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/blocked_screen.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/otp_phone_number/otp_phone_number_screen.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/signup/signup_screen.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/verification/face_verifications_options.dart';
import 'package:ride_off_smart_ride_app_flutter/services/api_services/auth.dart';

import '../../services/locationservice.dart';
import '../../services/storage/secureStorageService.dart';
import '../../widgets/bottom_navigation_bar.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key})
      : super(key: key); // Corrected constructor definition

  static String routeName = "/splash";

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
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    var currentUser = await authService.getCurrentUser();
    if (currentUser.isNotEmpty) {
      var isBlocked = currentUser['isBlocked'] as bool?;
      var signedUp = currentUser['signedUp'] as bool?;
      var faceIdVerified = currentUser['faceIdVerified'] as bool?;
      // Init Location Service
      _locationService.initializeAndStart();
      if (isBlocked != null && isBlocked) {
        // user is blocked
        Navigator.pushNamedAndRemoveUntil(
            context, BlockedMessageWidget.routeName, (route) => false);
      } else if (signedUp != null && faceIdVerified != null) {
        if (!signedUp) {
          Navigator.pushNamedAndRemoveUntil(
              context, SignUpScreen.routeName, (route) => false);
        } else if (!faceIdVerified) {
          // TODO use TTL to show verification page
          Navigator.pushNamedAndRemoveUntil(context,
              FaceVerificationOptionsScreen.routeName, (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (route) => false);
        }
      } else {
        // default login user
        Navigator.pushNamedAndRemoveUntil(
            context, OtpPhoneNumberScreen.routeName, (route) => false);
      }
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, OtpPhoneNumberScreen.routeName, (route) => false);
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
