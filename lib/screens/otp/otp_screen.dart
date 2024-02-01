import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../../constants.dart';
import '../../../theme.dart';
import '../../helpers/errorhelper.dart';
import '../../services/otpservice.dart';
import 'components/otp_form.dart';

class OtpScreen extends StatefulWidget {
  static String routeName = "/otp";

  const OtpScreen({super.key});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late Timer _timer;
  int _timerDuration = 60; // Initial timer duration in seconds

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (timer) {
        if (_timerDuration == 0) {
          timer.cancel();
        } else {
          setState(() {
            _timerDuration--;
          });
        }
      },
    );
  }

  void resetTimer() {
    setState(() {
      _timerDuration = 121;
    });
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve arguments
    Map<String, String> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String phoneNumber = arguments['maskedPhoneNumber']!;
    String formattedPhoneNumber = arguments['formattedPhoneNumber']!;
    void _handleOtpGenerationError(dynamic errorMessage) {
      new ErrorHelper().showErrorMessage(context, errorMessage);
    }
    void _resendOtp() async {
      try {
        Logger log = new Logger();

        log.i("Received Phone Number : $formattedPhoneNumber");

        final otpResponse = await new OtpApiService().generateOtp(formattedPhoneNumber);
        // Handle OTP generation response
        resetTimer(); // Reset timer when OTP is resent
      } catch (error) {
        _handleOtpGenerationError(error);
      }
    }

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
                      tween: Tween(begin: 120.0, end: 0.0),
                      duration: Duration(seconds: _timerDuration + 1), // Add 1 to avoid visual discrepancy
                      builder: (_, dynamic value, child) => Text(
                        "00:${_timerDuration.toString().padLeft(2, '0')}", // Format seconds with leading zero
                        style: const TextStyle(color: themePrimaryColor),
                      ),
                    ),
                  ],
                ),
                const OtpForm(),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _resendOtp,
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

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
