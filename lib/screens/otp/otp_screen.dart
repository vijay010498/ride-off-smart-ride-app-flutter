import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../theme.dart';
import 'components/otp_form.dart';

class OtpScreen extends StatelessWidget {
  final String phoneNumber; // Define phoneNumber variable

  OtpScreen({Key? key, required this.phoneNumber}) : super(key: key);

  static String routeName = "/otp";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OTP Verification"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  "OTP Verification",
                  style: headingStyle,
                ),
                Text("We sent your code to $phoneNumber"), // Display phone number here
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("This code will expire in "),
                    TweenAnimationBuilder(
                      tween: Tween(begin: 60.0, end: 0.0),
                      duration: const Duration(seconds: 121),
                      builder: (_, dynamic value, child) => Text(
                        "00:${value.toInt()}",
                        style: const TextStyle(color: themePrimaryColor),
                      ),
                    ),
                  ],
                ),
                const OtpForm(),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    // OTP code resend
                  },
                  child: const Text(
                    "Resend OTP Code",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

