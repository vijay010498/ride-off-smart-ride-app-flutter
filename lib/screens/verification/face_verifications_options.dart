import 'package:flutter/material.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/splash/splash_screen.dart';
import 'package:lottie/lottie.dart';

class FaceVerificationOptionsScreen extends StatelessWidget {
  static String routeName = "/face_verifications_options";
  const FaceVerificationOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Verification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Get verified to Stand out',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Lottie.asset(
                  'assets/animations/selfie_verification_animation.json',
                  width: 300,
                  height: 300,
                  fit: BoxFit.fill,
                )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SplashScreen(),
                  ),
                );
              },
              child: const Text('Start Face Verification'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Perform skip action
              },
              child: const Text('Skip for Now'),
            ),
          ],
        ),
      ),
    );
  }
}
